import 'package:get/get.dart';
import 'package:librebook/ui/views/home/home_view.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(milliseconds: 800))
        .then((value) => Get.off(HomeView()));
  }
}
