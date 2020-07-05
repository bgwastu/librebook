import 'package:librebook/app/locator.dart';
import 'package:librebook/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  Future redirect() async {
    await Future.delayed(Duration(milliseconds: 500));
    await _navigationService.replaceWith(Routes.homeView);
  }
}
