import 'package:get_it/get_it.dart';
import 'package:librebook/models/book_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DownloadDatabase {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store("download_store");

  static init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "download_database.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }

  static close() async {
    final Database db = GetIt.I.get();
    db.close();
  }

  Future insert(Book book, String filePath) {
    return _store.add(_database, {'book': book, 'filePath': filePath});
  }

  Future update(int id, Book book, String filePath) {
    return _store
        .record(id)
        .update(_database, {'book': book, 'filePath': filePath});
  }

  Future delete(int id) {
    _store.record(id).delete(_database);
  }
}
