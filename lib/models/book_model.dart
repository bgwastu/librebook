import 'package:librebook/models/mirror_model.dart';
import 'package:librebook/utils/book_category.dart';
import 'package:meta/meta.dart';

class Book {
  final String id;
  final String md5;
  final String title;
  final String description;
  final String cover;
  List<String> authors;
  final String format;
  final List<DownloadMirror> listMirror;
  final BookCategory bookCategory;
  final String language;

  Book({
    @required this.bookCategory,
    @required this.id,
    @required this.md5,
    @required this.cover,
    @required this.title,
    @required this.listMirror,
    @required this.authors,
    @required this.format,
    @required this.description,
    @required this.language,
  }) {
    if (this.authors.isEmpty) {
      authors = ['No Author'];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'md5': md5,
      'title': title,
      'description': description,
      'cover': cover,
      'authors': authors,
      'format': format,
      'listMirror': listMirror,
      'language': language,
    };
  }
}
