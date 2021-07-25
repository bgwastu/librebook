import 'dart:io';


import 'package:librebook/database/app_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';

class SettingsDatabase {
  final StoreRef _store = StoreRef('settings');

  Future<Database> get _database => AppDatabase.instance.database;

  //TODO: Make this value dynamic
  final defaultMainUrl = 'http://gen.lib.rus.ec';
  final defaultGeneralFirstMirror = 'http://library.lol/main/';
  final defaultGeneralSecondMirror = 'http://libgen.gs/ads.php?md5=';
  final defaultFictionFirstMirror = 'http://library.lol/fiction/';
  final defaultFictionSecondMirror =
      'http://libgen.gs/foreignfiction/ads.php?md5=';

  Future<Directory> defaultDownloadLocation = getApplicationDocumentsDirectory();

  setDefaultSetting() async {
    final downloadPath = await defaultDownloadLocation;
    _store.record(1).add(await _database, defaultGeneralFirstMirror);
    _store.record(2).add(await _database, defaultGeneralSecondMirror);
    _store.record(3).add(await _database, defaultMainUrl);
    _store.record(4).add(await _database, defaultFictionFirstMirror);
    _store.record(5).add(await _database, defaultFictionSecondMirror);
    _store.record(6).add(await _database, downloadPath);
  }

  Future<String> getGeneralMirror1() async =>
      await _store.record(1).get(await _database);

  Future<String> getGeneralMirror2() async =>
      await _store.record(2).get(await _database);

  Future setGeneralMirror1(String mirror1) async =>
      await _store.record(1).update(await _database, mirror1);

  Future setGeneralMirror2(String mirror2) async =>
      await _store.record(2).update(await _database, mirror2);

  Future<String> getLibgenUrl() async =>
      await _store.record(3).get(await _database);

  Future setLibgenUrl(String libgenUrl) async =>
      _store.record(3).update(await _database, libgenUrl);

  Future<String> getFictionMirror1() async =>
      await _store.record(4).get(await _database);

  Future<String> getFictionMirror2() async =>
      await _store.record(5).get(await _database);

  Future setFictionMirror1(String mirror1) async =>
      await _store.record(4).update(await _database, mirror1);

  Future setFictionMirror2(String mirror2) async =>
      await _store.record(5).update(await _database, mirror2);

  Future setDownloadLocation(String downloadPath) async =>
      _store.record(6).update(await _database, downloadPath);

  Future<String> getDownloadLocation() async =>
      await _store.record(6).get(await _database);
}
