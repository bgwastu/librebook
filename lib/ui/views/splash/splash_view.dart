import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final controller = Get.put(SplashController());
  @override
  void initState() {
    super.initState();
    controller.redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Librebook'),
      ),
    );
  }
}
