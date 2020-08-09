import 'package:meta/meta.dart';

class Book {
  final String id;
  final String md5;
  final String title;
  final String description;
  final String cover;
  List<String> authors;
  final String format;
  final String mirrorUrl;
  final String language;

  Book({
    @required this.id,
    @required this.md5,
    @required this.cover,
    @required this.title,
    @required this.mirrorUrl,
    @required this.authors,
    @required this.format,
    @required this.description,
    @required this.language
  }) {
    if (this.authors.isEmpty) {
      authors = ['No Author'];
    }
  }
}
