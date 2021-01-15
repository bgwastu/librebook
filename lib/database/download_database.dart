import 'package:librebook/database/app_database.dart';
import 'package:librebook/models/book_model.dart';
import 'package:librebook/models/mirror_model.dart';
import 'package:librebook/utils/book_category.dart';
import 'package:sembast/sembast.dart';

class DownloadDatabase {
  final StoreRef _store = intMapStoreFactory.store('download_store');

  Future<Database> get _database => AppDatabase.instance.database;

  Future<List<Map<String, dynamic>>> getDownloadList() async {
    final record = await _store.find(await _database);
    final downloadList = record.map((e) {
      final book = Book(
        id: e['id'],
        authors: List<String>.from(e['authors']),
        cover: e['cover'],
        description: e['description'],
        format: e['format'],
        language: e['language'],
        md5: e['md5'],
        listMirror: List.from([
          DownloadMirror(name: 'first', url: e['firstMirror']),
          DownloadMirror(name: 'second', url: e['secondMirror'])
        ]),
        title: e['title'],
        bookCategory: bookCategoryFromString(e['category']),
      );
      return {
        'book': book,
        'path': ['path'],
      };
    }).toList();
    return downloadList;
  }

  Future insert(Book book, String path) async {
    final currentBook = await getDownloadedBookByMD5(book.md5);
    if (currentBook != null) {
      return null;
    }
    return _store.add(await _database, {
      'title': book.title,
      'md5': book.md5,
      'authors': book.authors,
      'cover': book.cover,
      'path': path,
      'format': book.format,
      'id': book.id,
      'firstMirror': book.listMirror[0].url,
      'secondMirror': book.listMirror[1].url,
      'language': book.language,
      'description': book.description,
      'category': book.bookCategory.toString()
    });
  }

  Future<RecordSnapshot<dynamic, dynamic>> getDownloadedBookByMD5(
      String md5) async {
    return _store.findFirst(await _database,
        finder: Finder(filter: Filter.equals('md5', md5)));
  }

  Future update(Book book, String taskId) async {
    final downloadedBook = await getDownloadedBookByMD5(book.md5);
    if (downloadedBook == null) {
      throw Exception('Downloaded book not found');
    }
    return _store.record(downloadedBook.key).update(await _database, {
      'title': book.title,
      'authors': book.authors,
      'imageUrl': book.cover,
      'taskId': taskId
    });
  }

  Future delete(String md5) async {
    return _store.delete(await _database,
        finder: Finder(filter: Filter.equals('md5', md5)));
  }
}
