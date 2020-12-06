import 'package:get/get.dart';
import 'package:librebook/database/download_database.dart';

class HomeController extends GetxController {
  final _downloadDatabase = DownloadDatabase();
  
  
  Future<List<Map<String, dynamic>>> getDownloadList() async {
    final listDownload = _downloadDatabase.getDownloadList();
    return listDownload;
  }
}