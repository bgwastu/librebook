import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/splash_controller.dart';
import 'package:librebook/ui/shared/ui_helper.dart';

class SplashView extends StatelessWidget {
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    // set initial overlay
    changeOverlay();

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              height: 150,
              width: 150,
              child: Image.asset('assets/icon/icon.png'),
            ),
          ),
          Positioned(
            bottom: 16,
            child: Text(
              'Librebook v0.0.1-alpha',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        ],
      ),
    );
  }
}
