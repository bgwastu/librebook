import 'package:flutter/foundation.dart';
import 'package:librebook/models/author_model.dart';

class Book {
  final String id;
  final String isbn;
  final String cover;
  final String title;
  final String series;
  final List<Author> authors;
  final String format;
  final String fileSize;
  final String downloadUrl;
  final String description;

  Book({
    @required this.id,
    @required this.isbn,
    @required this.cover,
    @required this.title,
    this.series,
    @required this.authors,
    @required this.format,
    @required this.fileSize,
    @required this.downloadUrl,
    @required this.description,
  });
}
