import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/database/download_database.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/services/download_service.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/utils/consts.dart';
import 'package:librebook/utils/download_status.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class DownloadController extends GetxController {
  final _downloadServices = locator<DownloadService>();
  final _downloadDb = DownloadDatabase();
  RxInt _progress = 0.obs;
  Rx<DownloadStatus> _status = DownloadStatus.unInitialized.obs;
  String _fileDir;

  RxInt _received = 0.obs;
  RxInt _total = 0.obs;

  ///is page currently download?
  Future<bool> isCurrentlyDownload(String taskId) async {
    final download = await _downloadDb.getByTaskId(taskId);
    print('download: ' + download.toString());
    return download != null;
  }

  init() {
    _status.listen((status) {
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
                child: Text('No'),
              ),
              //TODO: implement this button
              MaterialButton(
                onPressed: () async {
                  await OpenFile.open(_fileDir);
                  Get.back();
                },
                child: Text('Yes'),
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
        _status.value = DownloadStatus.unInitialized;
      }
    });
  }

  /// return task id
  Future<String> download(Book book) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      _status.value = DownloadStatus.loading;
      final externalDir = await DownloadsPathProvider.downloadsDirectory;

      //TODO: need internet connection handler

      try {
        final isUrlWorking =
            await _downloadServices.checkMirror(book.mirrorUrl);

        if (!isUrlWorking) {
          _status.value = DownloadStatus.error;
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
          _status.value = DownloadStatus.completed;
        }
      } catch (e) {
        print('Error!: ' + e.toString());
        _status.value = DownloadStatus.error;
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
