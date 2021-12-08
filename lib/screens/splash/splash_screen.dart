import 'package:client_exhibideas/screens/splash/body.dart';
import 'package:client_exhibideas/utils/size_config.dart';
import 'package:flutter/material.dart';

class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({Key key}) : super(key: key);
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}
