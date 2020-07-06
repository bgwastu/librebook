import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/app/router.gr.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        title: 'Librebook',
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: Router().onGenerateRoute,
        initialRoute: Routes.splashView,
        theme: kLightTheme,
      ),
    );
  }
}
