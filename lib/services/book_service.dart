import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:librebook/models/book_model.dart';
import 'package:web_scraper/web_scraper.dart';

@lazySingleton
class BookService {
  // TODO: make this dynamic variable
  final url = 'http://gen.lib.rus.ec';
  final category = 'fiction';

  Client _client = Client();

  Future<List<Book>> bookSearch(String input) async {
    final scraper = WebScraper(url);
    if (await scraper.loadWebPage('/$category/?q=$input')) {
      List<Map<String, dynamic>> elements =
          scraper.('tbody > tr > td', ['text']);
      print(elements);
    }

    // List<Book> books = [];
    // final response = await _client.get(url + '/$category/?q=$input');
    // final document = parse(response.body);
    // final asd = document.querySelectorAll('tbody > tr').map((e) {
    //   final author = e.querySelectorAll('td')[0].text;
    //   final series = e.querySelectorAll('td')[1].text;
    //   final title = e.querySelectorAll('td')[2].innerHtml;
    //   final regex = RegExp('(?<=href=").*?(?=")');
    //   final language = e.querySelectorAll('td')[3].text;
    //   final titleUrl = url + regex.firstMatch(title).group(0);
    //   return titleUrl;
    // }).toList();

    // final asds = asd.map((uri) async {
    // final webScraper = WebScraper(url);
    // if(await webScraper.loadWebPage())
    //   final response = await _client.get(uri);
    //   final document2 = parse(response.body);
    //   final id = uri.split('/')[4];
    //   final title = document2.querySelector('.record_title').text;
    //   final cover = document.querySelector('[alt=cover]').attributeValueSpans
    //   return title;
    // }).toList();
    // final val = await Future.wait(asds);
    // print(val);
  }
}
