import 'package:librebook/app/locator.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/services/book_service.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  final _bookService = locator<BookService>();
  bool isFantasySearch = false;
  int index = 1;

  setIndex(int index) {
    index = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> listFantasyBook = [];

  Future<BookSearchDetail> searchFantasyBook(String query) async {
    final listBook = _bookService.findFiction(query, 1);
    return listBook;
  }

  Future<BookSearchDetail> searchGeneralBook(String query) async {
    final listBook = _bookService.findGeneral(query, 1);
    return listBook;
  }
}
