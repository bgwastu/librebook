import 'package:get/get.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/models/book_search_detail_model.dart';
import 'package:librebook/services/book_service.dart';

class SearchController extends GetxController {
  final _bookService = locator<BookService>();
  bool isFantasySearch = false;

  // data
  BookSearchDetail currentFantasySearchDetail;
  BookSearchDetail currentGeneralSearchDetail;

  // busy
  var isFantasyBusy = false.obs;
  var isGeneralBusy = false.obs;

  setFantasyBusy(bool isBusy) {
    isFantasyBusy.value = isBusy;
  }

  setGeneralBusy(bool isBusy) {
    isGeneralBusy.value = isBusy;
  }

  List<Map<String, dynamic>> listFantasyBook = [];

  Future<BookSearchDetail> searchFantasyBook(String query) async {
    setFantasyBusy(true);
    final fantasySearchDetail = await _bookService.findFiction(query, 1);
    currentFantasySearchDetail = fantasySearchDetail;
    setFantasyBusy(false);
    return fantasySearchDetail;
  }

  Future<BookSearchDetail> searchGeneralBook(String query) async {
    setGeneralBusy(true);
    final generalSearchDetail = await _bookService.findGeneral(query, 1);
    currentGeneralSearchDetail = generalSearchDetail;
    setGeneralBusy(false);
    return generalSearchDetail;
  }
}