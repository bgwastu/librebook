import 'package:get/get.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/services/book_service.dart';

class SearchResultController extends GetxController {
  var isLoading = false.obs;
  Rx<BookSearchDetail> bookSearchDetail;
  final _bookService = locator<BookService>();
  RxList<Book> listBook = RxList<Book>();

  setLoading(bool isLoading) {
    this.isLoading.value = isLoading;
  }

  setBookSearchDetail(BookSearchDetail bookSearchDetail) {
    this.bookSearchDetail = bookSearchDetail.obs;
    listBook.addAll(bookSearchDetail.listBook);
  }

  setBookSearchDetailNew(BookSearchDetail bookSearchDetail) {
    this.bookSearchDetail = bookSearchDetail.obs;
    listBook = bookSearchDetail.listBook.obs;
  }

  bool isLastPage() {
    return bookSearchDetail.value.currentPage >= bookSearchDetail.value.lastPage;
  }

  Future loadData(String query) async {
    if(!isLastPage()){
    setLoading(true);
    // Delay to prevent server exception
    await Future.delayed(Duration(seconds: 2));
    final page = this.bookSearchDetail.value.currentPage + 1;

    // get next list book with condition
    BookSearchDetail nextBookSearchDetail;
    if (bookSearchDetail.value.isGeneral) {
      nextBookSearchDetail = await _bookService.findGeneral(query, page);
    } else {
      nextBookSearchDetail = await _bookService.findFiction(query, page);
    }
    setBookSearchDetail(nextBookSearchDetail);
    setLoading(false);
    }
    
  }

  Future onRefreshData(String query) async {
    setLoading(true);
    // get next list book with condition
    BookSearchDetail nextBookSearchDetail;
    if (bookSearchDetail.value.isGeneral) {
      nextBookSearchDetail = await _bookService.findGeneral(query, 1);
    } else {
      nextBookSearchDetail = await _bookService.findFiction(query, 1);
    }
    setBookSearchDetailNew(nextBookSearchDetail);
    setLoading(false);
  }
}
