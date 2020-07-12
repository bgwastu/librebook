import 'package:flutter/foundation.dart';

class Book {
  final String id;
  final String md5;
  final String title;
  final String description;
  final String cover;
  final List<String> authors;
  final String format;
  final String mirrorUrl;

  Book({
    @required this.id,
    @required this.md5,
    @required this.cover,
    @required this.title,
    @required this.mirrorUrl,
    @required this.authors,
    @required this.format,
    @required this.description,
  });
}
