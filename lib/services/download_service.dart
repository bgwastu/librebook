import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:librebook/models/mirror_model.dart';
import 'package:librebook/utils/book_category.dart';

class DownloadService {
  final Client _client;

  DownloadService() : _client = Client();

  //TODO: move to setting
  final generalFirstMirror = 'http://library.lol/main/';
  final generalSecondMirror = 'http://libgen.gs/ads.php?md5=';
  final fictionFirstMirror = 'http://library.lol/fiction/';
  final fictionSecondMirror = 'http://libgen.gs/foreignfiction/ads.php?md5=';

  /// Get download url by just provide [mirror]
  Future<String> getDownloadUrl(List<DownloadMirror> listMirror) async {
    final fListDownloadUrl = listMirror.map((mirror) async {
      print(mirror.url);
      if (mirror.name == 'first') {
        // first mirror
        final response = await _client.get(mirror.url);
        if (response.statusCode != 200) {
          return null;
        }
        final document = parse(response.body);

        // get mirror urls
        final mirrorUrl = document.querySelector('li > a')
            .attributes['href'];
        return mirrorUrl;
      } else {
        // second mirror
        final response = await _client.get(mirror.url);
        if (response.statusCode != 200) {
          throw Exception('Download was failed because of dead mirror(s)');
        }
        final document = parse(response.body);
        final mirrorUrl = document.querySelector('a').attributes['href'];
        return mirrorUrl;
      }
    }).toList();

    final listDownloadUrl = await Future.wait(fListDownloadUrl);

    listDownloadUrl.removeWhere((mirror) => mirror == null);

    return listDownloadUrl.first;
  }

  /// Parse download url from gen.lib.rus.ec & libgen.lc mirror
  List<DownloadMirror> getListUrlMirror(
      String md5, BookCategory category)  {
    if (category == BookCategory.General) {
      return [
        DownloadMirror(name: 'first', url: generalFirstMirror + md5),
        DownloadMirror(name: 'second', url: generalSecondMirror + md5),
      ];
    } else {
      return [
        DownloadMirror(name: 'first', url: fictionFirstMirror + md5),
        DownloadMirror(name: 'second', url: fictionSecondMirror + md5),
      ];
    }
  }

  /// Check mirror url or random url if website was active
  Future<bool> checkMirror(String mirror) async {
    final response = await _client.get(mirror);
    return response.statusCode == 200 ? true : false;
  }
}
