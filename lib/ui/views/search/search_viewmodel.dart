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

  Future<List<Map<String, dynamic>>> suggestionFantasyBooks(
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
            })
        .toSet()
        .toList();
  }

  Future<List<Map<String, dynamic>>> suggestionBooks(String query) async {
    final listFantasyBook = suggestionFantasyBooks(query);
    final listGeneralBook = suggestionGeneralBooks(query);

    List<Map<String, dynamic>> listBook = [];
    print('waiting');
    await Future.wait([listFantasyBook, listGeneralBook])
        .then((value) => value.forEach((chunkListBook) {
          listBook.addAll(chunkListBook);
        }));
    print('selesai: ' + listBook.length.toString());
    return listBook;
  }
}
