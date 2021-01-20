import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:librebook/controllers/settings_controller.dart';
import 'package:librebook/database/download_database.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/services/download_service.dart';
import 'package:librebook/ui/shared/download_dialog.dart';
import 'package:librebook/utils/download_status.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  final _downloadServices = Get.put(DownloadService());
  final _downloadDb = Get.put(DownloadDatabase());
  final _settingController = Get.put(SettingsController());


  RxInt _progress = 0.obs;
  Rx<DownloadStatus> downloadStatus = DownloadStatus.unInitialized.obs;
  RxBool isAlreadyDownloaded = false.obs;
  String _fileDir;

  RxInt _received = 0.obs;
  RxInt _total = 0.obs;

  /// Is this book already downloaded?
  Future isCompleted(String md5) async {
    final download = await _downloadDb.getDownloadedBookByMD5(md5);
    // check is file is still available
    if (download != null) {
      // if the download still available in database but not in the file then delete database
      if (!await File(download['path']).exists()) {
        await _downloadDb.delete(download['md5']);
      }
    }
    isAlreadyDownloaded.value = download != null;
  }

  Future deleteBook(String md5, String path) async {
    await _downloadDb.delete(md5);
    if (await File(path).exists()) {
      await File(path).delete();
      downloadStatus.value = DownloadStatus.unInitialized;
      isAlreadyDownloaded.value = false;
    }
  }

  Future<String> getPath(String md5) async {
    final book = await _downloadDb.getDownloadedBookByMD5(md5);
    if (book == null) {
      throw Exception('Book not found, make sure to download it first');
    }
    return book['path'];
  }

  @override
  void onReady() {
    super.onReady();
    downloadStatus.listen((status) {
      if (status == DownloadStatus.loading) {
        if (Get.isDialogOpen) Get.back();
        Get.dialog(
          Obx(() {
            return WillPopScope(
                onWillPop: () => Future.value(false),
                child: DownloadDialog(
                  progress: _progress.value,
                  received: _received.value,
                  total: _total.value,
                ));
          }),
          barrierDismissible: false,
          useRootNavigator: true,
        );
      } else if (status == DownloadStatus.completed) {
        if (Get.isDialogOpen) {
          Get.back();
        }
        Get.dialog(DownloadCompletedDialog(fileDir: _fileDir));
      } else if (status == DownloadStatus.error) {
        if (Get.isDialogOpen) {
          Get.back();
        }
        Get.dialog(DownloadErrorDialog());
        downloadStatus.value = DownloadStatus.unInitialized;
      }
    });
  }

  openFile(Book book) async {
    final downloadedBook = await _downloadDb.getDownloadedBookByMD5(book.md5);
    final path = downloadedBook['path'];
    final res = await OpenFile.open(
      path,
      type: lookupMimeType(path),
    );
    if (res.type != ResultType.done) {
      Get.rawSnackbar(
        message: res.message,
        duration: Duration(milliseconds: 1500),
        isDismissible: true,
        title: 'Error',
      );
    }
  }

  Future download(Book book) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      // Reset all value
      downloadStatus.value = DownloadStatus.loading;
      _progress.value = 0;
      _received.value = 0;
      _total.value = 0;

      final externalDir = await _settingController.getDownloadLocation();

      //TODO: need internet connection handler

      try {
        final downloadUrl =
            await _downloadServices.getDownloadUrl(book.listMirror);
        _fileDir = externalDir +
            '/' +
            book.title +
            ' - ' +
            book.authors[0] +
            '.' +
            book.format;
        _fileDir = path.join(externalDir,
            book.title + ' - ' + book.authors[0] + '.' + book.format);
        final response = await Dio().download(
          downloadUrl,
          _fileDir,
          onReceiveProgress: _onReceiveProgress,
        );
        // result
        final isCompleted = response.statusCode == 200;
        if (isCompleted) {
          await _downloadDb.insert(book, _fileDir);
          downloadStatus.value = DownloadStatus.completed;
          isAlreadyDownloaded.value = true;
        }
      } catch (e) {
        print('Error!: ' + e.toString());
        downloadStatus?.value = DownloadStatus.error;
        throw e;
      }
    } else {
      print('permission denied');
    }
  }

  void _onReceiveProgress(int receivedBytes, int totalBytes) async {
    _received.value = receivedBytes;
    _total.value = totalBytes;
    if (totalBytes != -1) {
      _progress.value =
          int.parse((receivedBytes / totalBytes * 100).toStringAsFixed(0));
      // TODO: don't forget to delete it
      print(_progress.value);
    }
  }
}
