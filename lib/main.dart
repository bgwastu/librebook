import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/views/splash/splash_view.dart';

import 'app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Librebook',
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      themeMode: ThemeMode.light,
      enableLog: true,
      home: SplashView(),
      supportedLocales: [
        Locale('en', ''),
        Locale('de', ''),
        Locale('fr', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale == locale) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
    );
  }
}
