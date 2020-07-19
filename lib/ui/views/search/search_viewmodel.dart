import 'package:librebook/app/locator.dart';
import 'package:librebook/services/book_service.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  final _bookService = locator<BookService>();
  bool isFantasySearch = false;

  setFantasySearch(bool value) {
    isFantasySearch = value;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> findFantasyBooks(String query) {
    return _bookService.findFiction(query, '1');
  }
}