import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/services/download_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class DownloadController extends GetxController {
  final _downloadServices = locator<DownloadService>();
  RxBool isDownloading = false.obs;
  RxString progress = '0'.obs;
  Dio _dio;

  DownloadController() : _dio = Dio();

  Future download(Book book) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await DownloadsPathProvider.downloadsDirectory;

      // is Downloading
      isDownloading.value = true;

      final isUrlWorking = await _downloadServices.checkMirror(book.mirrorUrl);

      if (!isUrlWorking) {
        print('error: url is not working');
        return;
      }

      final bookUrl = await _downloadServices.getDownloadUrl(book.mirrorUrl);

      _dio.download(
        bookUrl,
        path.join(externalDir.path, book.title + ' - ' + book.authors[0]),
        
        onReceiveProgress: (rcv, total){
          print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

          progress.value = ((rcv / total) * 100).toStringAsFixed(0);

          // isDownloading
          if(progress.value == '100'){
            isDownloading.value = false;
          }else if(double.parse(progress.value) < 100){
            isDownloading.value = true;
          }
        }
      ).then((_) {
        if(progress.value == '100'){
          isDownloading.value = false;
        }
      });

    } else {
      print('permission denied');
    }
  }
}
