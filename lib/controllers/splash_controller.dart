import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/shared/ui_helper.dart';
import 'package:librebook/ui/views/home/home_view.dart';

class SplashController extends GetxController {
  final appdata = GetStorage();

  @override
  void onInit() {
    super.onInit();
    appdata.writeIfNull('isDarkMode', false);
    final isDarkMode = appdata.read('isDarkMode');
    setDarkMode(isDarkMode);
    Get.testMode = true;
    Future.delayed(Duration(milliseconds: 800))
        .then((value) => Get.off(HomeView()));
  }

  setDarkMode(bool value) async {
    if (value) {
      Get.changeTheme(kDarkTheme);
      setCurrentOverlay(value);
    } else {
      Get.changeTheme(kLightTheme);
      setCurrentOverlay(value);
    }
  }
}
