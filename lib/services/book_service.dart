import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:librebook/models/book_model.dart';

@lazySingleton
class BookService {
  final Client _client;
  BookService() : _client = Client();

  //TODO: make option for this variable
  final url = 'https://libgen.is';
  final category = 'fiction';
  final formatFileSelection = ['pdf', 'epub'];
  final language = 'English';

  /// Find fiction book from libgen
  ///
  /// Need to pass [query] and [page]. Returns List Map [title, authors, url, format]
  Future<List<Map<String, dynamic>>> findFiction(
      String query, String page) async {
    final response = await _client
        .get(url + '/$category/?q=$query&page=$page&language=$language');

    // Check server
    if (response.statusCode != 200) {
      throw Exception('Can\'t connect to server');
    }

    final document = parse(response.body);

    // Condition if has no file
    final ifNotFound = response.body.contains('No files were found.');
    if (ifNotFound) {
      throw Exception('No search Result');
    }
    final hasil = document
        .querySelectorAll('table > tbody > tr')
        .map((e) {
          // Get the author(s)
          final authors = [...e.querySelectorAll('ul.catalog_authors > li')]
              .map((author) => author.text.replaceAll(',', ''))
              .where((author) => author.isNotEmpty)
              .toList();

          // Get the title of book
          final title = e.querySelectorAll('td')[2].text;

          // Get the detail url
          final url =
              e.querySelectorAll('td')[2].querySelector('a').attributes['href'];

          // Get the format of book
          final format = RegExp(r'(.*)\s\/')
              .firstMatch(e.querySelectorAll('td')[4].innerHtml)
              .group(1)
              .toLowerCase();
          return {
            'title': title,
            'authors': authors,
            'url': this.url + url,
            'format': format,
          };
        })
        .where((book) => formatFileSelection.contains(book['format']))
        .toList();
    return hasil;
  }

  /// Find general (Sci-Fi) book from libgen
  ///
  /// Need to pass search [query] and [page]. Returns [List] of [Book]
  Future<List<Book>> findGeneral(String query, String page) async {
    final response = await _client.get('$url/search.php?req=$query&page=$page');

    // Server check
    if (response.statusCode != 200) {
      throw Exception('Can\'t connect to server');
    }

    final document = parse(response.body);

    // Scrape books id
    final listBookId = document
        .querySelectorAll(
            'table[align="center"] > tbody > tr:not(:first-child)')
        .map((e) {
          final id = e.querySelectorAll('td')[0].text;
          final format = e.querySelectorAll('td')[8].text.toLowerCase();
          return {
            'id': id,
            'format': format,
          };
        })
        .where((e) => formatFileSelection.contains(e['format']))
        .map((e) => e['id'])
        .toList();

    // Check if list book was empty
    if (listBookId.isEmpty) {
      return [];
    }

    // get list book
    final listBook = await _getGeneralDetailBook(listBookId);

    return listBook;
  }

  /// Get list [book] for general (Sci-Fi) book from libgen
  ///
  /// Need to pass list id(s). Returns [List] of [Book]
  Future<List<Book>> _getGeneralDetailBook(List<String> ids) async {
    final response = await _client.get(
        '$url/json.php?ids=${ids.toString()}&fields=id,title,descr,md5,coverurl,author,extension');

    // Check server
    if (response.statusCode != 200) {
      throw Exception('Can\'t connect to server');
    }

    List<dynamic> body = json.decode(response.body);
    final listBook = body.map((bookMap) {
      return Book(
        id: bookMap['id'],
        title: bookMap['title'],
        description: bookMap['description'],
        md5: bookMap['md5'],
        cover: url + '/covers/' + bookMap['coverurl'],
        authors: [bookMap['author']],
        format: bookMap['extension'],
        mirrorUrl: url + '/get.php?md5=' + bookMap['md5'],
      );
    }).toList();
    return listBook;
  }

  /// Get detail fiction book
  ///
  /// Use if you want get [Book] object
  /// This fuction was creted because lack of API for fiction book in libgen.
  ///
  /// Need to pass [detail url]. Returns [Book]
  Future<Book> getDetailFictionBook(String url) async {
    final response = await _client.get(url);
    final document = parse(response.body);

    // Get title
    final title = [...document.querySelectorAll('table.record > tbody > tr')]
        .map((e) => e.text.trim())
        .where((text) => text.contains('Title'))
        .map((text) => text.split(':')[1].trim())
        .first;

    // Get genesis id
    final id = [...document.querySelectorAll('table.record > tbody > tr')]
        .map((e) => e.text.trim())
        .where((text) => text.contains('ID'))
        .map((text) => text.split(':')[1].trim())
        .first;

    // Get file md5
    final md5 = document.querySelector('table.hashes > tbody > tr > td').text;

    // Get author(s)
    final authors = [...document.querySelectorAll('ul.catalog_authors > li')]
        .map((author) => author.text.replaceAll(',', ''))
        .toList();

    final format = [...document.querySelectorAll('table.record > tbody > tr')]
        .map((e) => e.text.trim())
        .where((text) => text.contains('Format'))
        .map((text) => text.split(':')[1].trim())
        .first
        .toLowerCase();

    // Get description
    var descriptionElement =
        document.querySelector('div#book-description-full');

    // First mirror url
    String mirrorUrl =
        document.querySelector('ul.record_mirrors > li > a').attributes['href'];

    // If genesis dont provide description
    String description = '';
    if (descriptionElement != null) {
      description = descriptionElement.text.replaceAll('\s{2,}', '').trim();
    }

    // Get cover url
    final cover = document.querySelector('div > img').attributes['src'];

    final book = Book(
        id: id,
        title: title,
        authors: authors,
        cover: cover,
        format: format,
        description: description,
        md5: md5,
        mirrorUrl: mirrorUrl);
    return book;
  }

  /// Get book cover url.
  ///
  /// This function is usually used for fantasy typed book.
  /// Need to pass [detail url]. Returns [String]
  Future<String> getCoverUrl(String url) async {
    final response = await _client.get(url);
    final document = parse(response.body);

    final coverUrl = document.querySelector('div > img').attributes['src'];
    return coverUrl;
  }
}
