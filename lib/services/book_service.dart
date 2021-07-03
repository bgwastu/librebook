import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/services/download_service.dart';
import 'package:librebook/utils/book_category.dart';
import 'package:librebook/utils/custom_exception.dart';

class BookService {
  final Client _client;
  BookService() : _client = Client();

  //TODO: make option for this variable
  final url = 'http://gen.lib.rus.ec';

  final _downloadService = DownloadService();

  Future<BookSearchDetail> findFiction(String query, int page) async {
    final response = await _client.get(url + '/fiction/?q=$query&page=$page');

    // Future for detail book
    List<Future<Book>> fListBook = [];

    // Check server
    if (response.statusCode != 200) {
      throw ServerException();
    }

    // Parse data
    final document = parse(response.body);

    // Condition when file was not found
    final bool ifNotFound = response.body.contains('No files were found.');
    if (ifNotFound) {
      throw SearchNotFoundException();
    }

    // Check if the page has page selector
    final pageSelector = document.querySelector('.page_selector');
    var currentPage = 1;
    var lastPage = 1;

    // Fill currentPage and lastPage if page selector was available
    if (pageSelector != null) {
      // Get current page
      currentPage = int.parse(RegExp(r'(\d+) \/ (\d+)')
          .firstMatch(document.querySelector('.page_selector').text)
          .group(1));

      // Get last page
      lastPage = int.parse(RegExp(r'(\d+) \/ (\d+)')
          .firstMatch(document.querySelector('.page_selector').text)
          .group(2));
    }

    document.querySelectorAll('table > tbody > tr').forEach((e) {
      // Get detail book path url
      final path =
          e.querySelectorAll('td')[2].querySelector('a').attributes['href'];

      // Get detail book and put to fListBook
      final fBook = _getDetailFictionBook(path);
      fListBook.add(fBook);
    });

    // Process future of list book.
    final listBook = await Future.wait(fListBook);

    return BookSearchDetail(
      currentPage: currentPage,
      lastPage: lastPage,
      listBook: listBook,
      isGeneral: false,
    );
  }

  Future<Book> _getDetailFictionBook(String path) async {
    final response = await _client.get(url + path);

    //TODO: error handling

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

    // Author null filter
    authors.removeWhere((author) => author.isEmpty);

    // Get format
    final format = [...document.querySelectorAll('table.record > tbody > tr')]
        .map((e) => e.text.trim())
        .where((text) => text.contains('Format'))
        .map((text) => text.split(':')[1].trim())
        .first
        .toLowerCase();

    // Get language
    final language = [...document.querySelectorAll('table.record > tbody > tr')]
        .map((e) => e.text.trim())
        .where((text) => text.contains('Language'))
        .map((text) => text.split(':')[1].trim())
        .first;

    // Get description
    var descriptionElement =
        document.querySelector('div#book-description-full');

    // If genesis dont provide description
    String description = '';
    if (descriptionElement != null) {
      if (descriptionElement.text.isNotEmpty) {
        description = descriptionElement.text.replaceAll('\s{2,}', '').trim();
      }
    }

    // Get cover url
    var cover = document.querySelector('div > img').attributes['src'];

    // Check is valid URL
    final isValidURL = Uri.parse(cover).isAbsolute;
    if(!isValidURL){
      cover = url + cover;
    }

    // If default cover was not available
    if (cover == '/static/no_cover.png') {
      cover = url + '/static/no_cover.png';
    }

    final listMirror = _downloadService.getListUrlMirror(md5, BookCategory.Fiction);
    // Return
    final book = Book(
      id: id,
      title: title,
      authors: authors,
      cover: cover,
      format: format,
      description: description,
      md5: md5,
      listMirror: listMirror,
      language: language,
      bookCategory: BookCategory.Fiction,
    );
    return book;
  }

  Future<BookSearchDetail> findGeneral(String query, int page) async {
    final response =
        await _client.get('$url/search.php?req=$query&page=$page&phrase=1');
    List<Book> listBook = [];

    // Server check
    if (response.statusCode != 200) {
      throw ServerException();
    }

    // Parse data
    final document = parse(response.body);

    // Condition when file was not found
    final ifNotFound = document
        .querySelectorAll(
            'table[align="center"] > tbody > tr:not(:first-child)')
        .isEmpty;
    if (ifNotFound) {
      throw SearchNotFoundException();
    }

    // Pagination
    var currentPage = 1;
    var lastPage = 1;
    final pageSelector = RegExp(r'(\d+)')
        .allMatches(document.querySelector('td > font').text)
        .length;

    // Fill currentPage and lastPage if page selector was available
    if (pageSelector > 1) {
      // Get last page & current result
      final filesFound = RegExp(r'(\d+)')
          .allMatches(document.querySelector('td > font').text)
          .first
          .group(0);
      final currentResult = RegExp(r'(\d+)')
          .allMatches(document.querySelector('td > font').text)
          .toList()[1]
          .group(0);

      // Parse and make it lastPage and currentPage
      lastPage = int.parse(filesFound) ~/ 25;
      currentPage = int.parse(currentResult) ~/ 25 + 1;
    }

    // Scrape books id
    final listBookId = document
        .querySelectorAll(
            'table[align="center"] > tbody > tr:not(:first-child)')
        .map((e) => e.querySelectorAll('td')[0].text)
        .toList();

    // if listBookId was not empty then fetch detail book
    if (listBookId.isNotEmpty) {
      listBook.addAll(await _getGeneralDetailBook(listBookId));
    }

    return BookSearchDetail(
        currentPage: currentPage,
        lastPage: lastPage,
        listBook: listBook,
        isGeneral: true);
  }

  Future<List<Book>> _getGeneralDetailBook(List<String> ids) async {
    final response = await _client.get(
        '$url/json.php?ids=${ids.join(',')}&fields=id,title,descr,md5,coverurl,author,extension,language');

    // Check server
    if (response.statusCode != 200) {
      throw ServerException(message: 'Error getGeneralDetailBook');
    }

    List<dynamic> body = json.decode(response.body);
    final listBook = body.map((bookMap){
      // Check if cover was't available
      if (bookMap['coverurl'].toString().isEmpty) {
        bookMap['coverurl'] = url + '/img/blank.png';
      } else {
        bookMap['coverurl'] = url + '/covers/' + bookMap['coverurl'];
      }

      final listMirror = _downloadService.getListUrlMirror(bookMap['md5'], BookCategory.General);
      return Book(
        id: bookMap['id'],
        title: bookMap['title'] ?? '',
        description: bookMap['description'] ?? '',
        md5: bookMap['md5'],
        cover: bookMap['coverurl'],
        authors: [bookMap['author']] ?? [''],
        format: bookMap['extension'],
        language: bookMap['language'],
        listMirror: listMirror,
        bookCategory: BookCategory.General,
      );
    }).toList();
    return listBook;
  }
}
