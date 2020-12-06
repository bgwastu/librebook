import 'package:get_it/get_it.dart';
import 'package:librebook/models/book_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DownloadDatabase {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store('download_store');

  static init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, 'download_database.db');
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }

  static close() async {
    final Database db = GetIt.I.get();
    db.close();
  }

  Future<List<Map<String, dynamic>>> getDownloadList() async {
    final record = await _store.find(_database);
    final downloadList = record.map((e) {
      final book = Book(id: e['id'],
        authors: List<String>.from(e['authors']),
        cover: e['cover'],
        description: e['description'],
        format: e['format'],
        language: e['language'],
        md5: e['md5'],
        mirrorUrl: e['mirrorUrl'],
        title: e['title'],
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
    return _store.add(_database, {
      'title': book.title,
      'md5': book.md5,
      'authors': book.authors,
      'cover': book.cover,
      'path': path,
      'format': book.format,
      'id': book.id,
      'mirrorUrl': book.mirrorUrl,
      'language': book.language,
      'description': book.description,
    });
  }

  Future<RecordSnapshot<dynamic, dynamic>> getDownloadedBookByMD5(String md5) {
    return _store.findFirst(_database,
        finder: Finder(filter: Filter.equals('md5', md5)));
  }

  Future update(Book book, String taskId) async {
    final downloadedBook = await getDownloadedBookByMD5(book.md5);
    if (downloadedBook == null) {
      throw Exception('Downloaded book not found');
    }
    return _store.record(downloadedBook.key).update(_database, {
      'title': book.title,
      'authors': book.authors,
      'imageUrl': book.cover,
      'taskId': taskId
    });
  }

  Future delete(String md5) {
    return _store.delete(
        _database, finder: Finder(filter: Filter.equals('md5', md5)));
  }
}
