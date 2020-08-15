import 'book_model.dart';
import 'package:meta/meta.dart';

class BookSearchDetail {
  final int currentPage;
  final int lastPage;
  final bool isGeneral;
  final List<Book> listBook;

  BookSearchDetail({
    @required this.currentPage,
    @required this.lastPage,
    @required this.listBook,
    @required this.isGeneral,
  });
}
