import 'package:librebook/app/locator.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/services/book_service.dart';
import 'package:stacked/stacked.dart';

class SearchResultGeneralViewModel extends BaseViewModel {
  bool isLoading = false;
  BookSearchDetail bookSearchDetail;
  final _bookService = locator<BookService>();
  List<Book> listBook = [];

  setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  setBookSearchDetail(BookSearchDetail bookSearchDetail) {
    this.bookSearchDetail = bookSearchDetail;
    listBook.addAll(bookSearchDetail.listBook);
  }

  setBookSearchDetailNew(BookSearchDetail bookSearchDetail) {
    this.bookSearchDetail = bookSearchDetail;
    listBook = bookSearchDetail.listBook;
  }

  checkLastPage() {
    print('currentPage: ' + bookSearchDetail.currentPage.toString());
    print('lastPage: ' + bookSearchDetail.lastPage.toString());
    if (bookSearchDetail.currentPage >= bookSearchDetail.lastPage) {
      return;
    }
  }

  Future loadData(String query) async {
    setLoading(true);
    checkLastPage();
    Stopwatch stopwatch = new Stopwatch()..start();
    print('loaddataTrigger');
    // Delay to prevent server exception
    await Future.delayed(Duration(seconds: 2));
    final page = this.bookSearchDetail.currentPage + 1;
    try {
      final nextBookSearchDetail = await _bookService.findGeneral(query, page);
      setBookSearchDetail(nextBookSearchDetail);
    } catch (e) {
      print('exception bangs');
    }
    setLoading(false);
    print(
        'loadData(page: ${page.toString()}) executed in ${stopwatch.elapsed}');
  }

  Future onRefreshData(String query) async {
    setLoading(true);
    final nextBookSearchDetail = await _bookService.findGeneral(query, 1);
    setBookSearchDetailNew(nextBookSearchDetail);
    setLoading(false);
  }
}
