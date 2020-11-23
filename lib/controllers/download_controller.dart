import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/database/download_database.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/services/download_service.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController {
  final _downloadServices = locator<DownloadService>();
  final _downloadDb = DownloadDatabase();

  ///is page currently download?
  Future<bool> isCurrentlyDownload(String taskId)async {
    final download = await _downloadDb.getByTaskId(taskId);
    print('download: ' + download.toString());
    return download != null;
  }  

  /// return task id
  Future<String> download(Book book) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await DownloadsPathProvider.downloadsDirectory;

      final isUrlWorking = await _downloadServices.checkMirror(book.mirrorUrl);

      if (!isUrlWorking) {
        print('error: url is not working');
        throw Exception('Url is not working');
      }

      final bookUrl = await _downloadServices.getDownloadUrl(book.mirrorUrl);

    } else {
      print('permission denied');
    }
  }
}
