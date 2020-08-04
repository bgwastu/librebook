import 'package:librebook/app/locator.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/services/book_service.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  final _bookService = locator<BookService>();
  bool isFantasySearch = false;
  int fantasyBookPage = 1;
  List<Map<String, dynamic>> listFantasyBook = [];


  setFantasySearch(bool value) {
    isFantasySearch = value;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> searchFantasyBooks(
      String query) async {
    final listBook = await _bookService.findFiction(query, '1');
    return listBook.toSet().toList();
  }

  Future<List<Map<String, dynamic>>> suggestionGeneralBooks(
      String query) async {
    final listBook = await _bookService.findGeneral(query, '1');
    return listBook
        .map((book) => {
              'title': book.title,
              'authors': book.authors,
              'type': 'General',
            })
        .toSet()
        .toList();
  }

  Future<Book> getDetailBookFiction(String url) async {
    final book = _bookService.getDetailFictionBook(url);
    return book;
  }

  // Future<List<Map<String, dynamic>>> suggestionBooks(String query) async {
  //   Stopwatch stopwatch = new Stopwatch()..start();
  //   final listFantasyBook = suggestionFantasyBooks(query);
  //   final listGeneralBook = suggestionGeneralBooks(query);

  //   List<Map<String, dynamic>> listBook = [];
  //   await Future.wait([listFantasyBook, listGeneralBook])
  //       .then((value) => value.forEach((chunkListBook) {
  //             listBook.addAll(chunkListBook);
  //           }));
  //   print('selesai: ' + listBook.length.toString());
  //   print('getSearchListBook executed in ${stopwatch.elapsed}');
  //   return listBook;
  // }
}
