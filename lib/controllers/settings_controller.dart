import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:librebook/database/settings_database.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';

class SettingsController extends GetxController {
  final _settingDatabase = SettingsDatabase();
  final appdata = GetStorage();
  RxString generalBookMirror1 = ''.obs;
  RxString generalBookMirror2 = ''.obs;
  RxString fictionBookMirror1 = ''.obs;
  RxString fictionBookMirror2 = ''.obs;
  RxString libgenUrl = ''.obs;
  RxString downloadLocation = ''.obs;
  RxBool isDarkMode = false.obs;

  @override
  void onReady() {
    super.onReady();
    // get theme status
    isDarkMode.value = getThemeStatus();
    setDarkMode(isDarkMode.value);
    getAll();
  }


  bool getThemeStatus() {
    appdata.writeIfNull('isDarkMode', false);
    return appdata.read('isDarkMode');
  }

  setDarkMode(bool value) async {
    print('Dark mode: ' + value.toString());
    appdata.write('isDarkMode', value);
    isDarkMode.value = value;
    if(value){
      Get.changeThemeMode(ThemeMode.dark);
      await Future.delayed(Duration(milliseconds: 100));
      setCurrentOverlay(value);
    }else{
      Get.changeThemeMode(ThemeMode.light);
      await Future.delayed(Duration(milliseconds: 100));
      setCurrentOverlay(value);
    }
    Get.appUpdate();
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

  setDownloadLocation(newDirectory) {
    downloadLocation.value = newDirectory;
    _settingDatabase.setDownloadLocation(downloadLocation.value);
  }

  Future setLibgenUrl() => _settingDatabase.setLibgenUrl(libgenUrl.value);
}
