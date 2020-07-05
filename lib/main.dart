import 'package:flutter/material.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/app/router.gr.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librebook',
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: Router().onGenerateRoute,
      initialRoute: Routes.splashView,
    );
  }
}
