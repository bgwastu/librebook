import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/database/download_database.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/services/download_service.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/utils/consts.dart';
import 'package:librebook/utils/download_status.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;

class DownloadController extends GetxController {
  final _downloadServices = locator<DownloadService>();
  final _downloadDb = DownloadDatabase();
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

  init() {
    downloadStatus.listen((status) {
      if (status == DownloadStatus.loading) {
        if (Get.isDialogOpen) {
          Get.back();
        }
        Get.dialog(
          Obx(() {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                title: _progress.value == 0
                    ? Text('Waiting for server reply...')
                    : Text('Downloading...'),
                content: _progress.value == 0
                    ? LinearProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LinearProgressIndicator(value: _progress.value / 100),
                          verticalSpaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_progress.value.toString() + '%'),
                              Text(
                                Constants.formatBytes(_received.value, 1) +
                                    ' of ' +
                                    Constants.formatBytes(_total.value, 1),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            );
          }),
          barrierDismissible: false,
          useRootNavigator: true,
        );
      } else if (status == DownloadStatus.completed) {
        if (Get.isDialogOpen) {
          Get.back();
        }
        Get.dialog(AlertDialog(
            title: Text('Download completed!'),
            content: Text('Do you want to open the book?'),
            actions: [
              MaterialButton(
                onPressed: () => Get.back(),
                child: Text('NO', style: TextStyle(color: secondaryColor)),
              ),
              MaterialButton(
                onPressed: () async {
                  await OpenFile.open(_fileDir, type: lookupMimeType(_fileDir));
                  Get.back();
                },
                child: Text('YES', style: TextStyle(color: secondaryColor),),
              ),
            ]));
      } else if (status == DownloadStatus.error) {
        if (Get.isDialogOpen) {
          Get.back();
        }
        Get.dialog(AlertDialog(
          title: Text('Error has been occurred'),
          content: Text(':('),
        ));
        downloadStatus.value = DownloadStatus.unInitialized;
      }
    });
  }

  openFile(Book book) async {
    final downloadedBook = await _downloadDb.getDownloadedBookByMD5(book.md5);
    final path = downloadedBook['path'];
    await OpenFile.open(path, type: lookupMimeType(path));
  }

  Future download(Book book) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      downloadStatus.value = DownloadStatus.loading;
      final externalDir = await DownloadsPathProvider.downloadsDirectory;

      //TODO: need internet connection handler

      try {
        final isUrlWorking =
            await _downloadServices.checkMirror(book.mirrorUrl);

        if (!isUrlWorking) {
          downloadStatus.value = DownloadStatus.error;
          print('error: url is not working');
          throw Exception('Url is not working');
        }
        final bookUrl = await _downloadServices.getDownloadUrl(book.mirrorUrl);
        _fileDir = externalDir.path +
            '/' +
            book.title +
            ' - ' +
            book.authors[0] +
            '.' +
            book.format;
        final response = await Dio().download(
          bookUrl,
          path.join(externalDir.path,
              book.title + ' - ' + book.authors[0] + '.' + book.format),
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
        downloadStatus.value = DownloadStatus.error;
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
