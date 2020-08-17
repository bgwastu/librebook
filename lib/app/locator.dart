import 'package:get_it/get_it.dart';
import 'package:librebook/services/book_service.dart';
import 'package:librebook/services/download_service.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => BookService());
  locator.registerLazySingleton(() => DownloadService());
}
