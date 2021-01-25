import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librebook/controllers/splash_controller.dart';
import 'package:package_info/package_info.dart';

class SplashView extends StatelessWidget {
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {

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
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text(
                    'Librebook v' + snapshot.data.version,
                    style: TextStyle(color: Colors.grey[600]),
                  );
                }
                return Container();
              },
            )
          )
        ],
      ),
    );
  }
}
