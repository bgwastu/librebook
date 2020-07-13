import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DownloadService {
  final Client _client;

  DownloadService() : _client = Client();

  /// Get download url by just provide [mirror]
  Future<String> getDownloadUrl(String mirror) async {
    final response = await _client.get(mirror);
    final document = parse(response.body);
    if (response.statusCode != 200) {
      throw Exception('No Download Url');
    }
    final downloadUrl = document.querySelector('h2 > a').attributes['href'];
    return downloadUrl;
  }

  /// Check mirror url or random url if website was active
  Future<bool> checkMirror(String mirror) async {
    final response = await _client.get(mirror);
    return response.statusCode == 200 ? true : false;
  }
}
