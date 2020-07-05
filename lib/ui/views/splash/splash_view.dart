import 'package:flutter/material.dart';
import 'package:librebook/ui/views/splash/splash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.nonReactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Text('Librebook'),
        ),
      ),
      viewModelBuilder: () => SplashViewModel(),
      onModelReady: (model) => model.redirect(),
    );
  }
}