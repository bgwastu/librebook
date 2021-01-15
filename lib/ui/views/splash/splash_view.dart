import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/splash_controller.dart';

class SplashView extends StatelessWidget {

  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Librebook'),
      ),
    );
  }
}
