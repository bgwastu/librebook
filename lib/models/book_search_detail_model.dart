import 'book_model.dart';

class BookSearchDetail {
  final int currentPage;
  final int lastPage;
  final List<Book> listBook;

  BookSearchDetail({this.currentPage, this.lastPage, this.listBook});
}
