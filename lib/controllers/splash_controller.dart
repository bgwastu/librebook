import 'package:get/get.dart';
import 'package:librebook/ui/views/home/home_view.dart';

class SplashController extends GetxController {
  Future redirect() async {
    await Future.delayed(Duration(milliseconds: 500));
    Get.off(HomeView());
  }
}
