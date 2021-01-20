import 'package:get/get.dart';
import 'package:librebook/database/settings_database.dart';

class SettingsController extends GetxController {
  final _settingDatabase = SettingsDatabase();
  RxString generalBookMirror1 = ''.obs;
  RxString generalBookMirror2 = ''.obs;
  RxString fictionBookMirror1 = ''.obs;
  RxString fictionBookMirror2 = ''.obs;
  RxString libgenUrl = ''.obs;
  RxString downloadLocation = ''.obs;


  @override
  void onInit() {
    super.onInit();
    getAll();
    libgenUrl.listen((val) {
      print(val);
    });
  }

  getAll() async {
    generalBookMirror1.value = await getGeneralMirror1();
    generalBookMirror2.value = await getGeneralMirror2();
    fictionBookMirror1.value = await getFictionMirror1();
    fictionBookMirror2.value = await getFictionMirror2();
    libgenUrl.value = await getLibgenUrl();
    downloadLocation.value = await getDownloadLocation();
  }

  Future<String> getGeneralMirror1() => _settingDatabase.getGeneralMirror1();

  Future<String> getGeneralMirror2() => _settingDatabase.getGeneralMirror2();

  Future<String> getFictionMirror1() => _settingDatabase.getFictionMirror1();

  Future<String> getFictionMirror2() => _settingDatabase.getFictionMirror2();

  Future<String> getLibgenUrl() => _settingDatabase.getLibgenUrl();

  Future<String> getDownloadLocation() =>
      _settingDatabase.getDownloadLocation();

  Future setGeneralMirror1() =>
      _settingDatabase.setGeneralMirror1(generalBookMirror1.value);

  Future setGeneralMirror2() =>
      _settingDatabase.setGeneralMirror2(generalBookMirror2.value);

  Future setFictionMirror1() =>
      _settingDatabase.setFictionMirror1(fictionBookMirror1.value);

  Future setFictionMirror2() =>
      _settingDatabase.setFictionMirror1(fictionBookMirror2.value);

  Future setDownloadLocation(newDirectory) {
    downloadLocation.value = newDirectory;
    _settingDatabase.setDownloadLocation(downloadLocation.value);
  }

  Future setLibgenUrl() => _settingDatabase.setLibgenUrl(libgenUrl.value);
}
