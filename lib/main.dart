import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:librebook/app/locator.dart';
import 'package:librebook/database/download_database.dart';
import 'package:librebook/ui/shared/theme.dart';
import 'package:librebook/ui/views/splash/splash_view.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    // delete this
    debug: true,
  );
  DownloadDatabase.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        child: GetMaterialApp(
          title: 'Librebook',
          debugShowCheckedModeBanner: false,
          theme: kLightTheme,
          home: SplashView(),
        ));
  }
}
