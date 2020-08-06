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

  Future<List<Map<String, dynamic>>> searchFantasyBook(String query) async {
    final listBook = await _bookService.findFiction(query, '1');
    return listBook.toSet().toList();
  }

  Future<List<Book>> searchGeneralBook(String query) async {
    final listBook = await _bookService.findGeneral(query, '1');
    return listBook;
  }

  Future<Book> getDetailBookFiction(String url) async {
    final book = await _bookService.getDetailFictionBook(url);
    return book;
  }
}
