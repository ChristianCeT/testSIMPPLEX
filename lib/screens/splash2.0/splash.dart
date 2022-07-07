import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simpplex_app/screens/Login/login_page.dart';
import 'package:simpplex_app/utils/utils.dart';

class SplashScreenV2 extends StatefulWidget {
  const SplashScreenV2({Key? key}) : super(key: key);
  static String routName = '/inicio/splash';

  @override
  State<SplashScreenV2> createState() => _SplashScreenV2State();
}

class _SplashScreenV2State extends State<SplashScreenV2> {
  double opacityLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.routeName, (route) => false),
    );

    return Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.ease,
          duration: const Duration(seconds: 4),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: const Center(
              child: SizedBox(
                width: 400,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image(
                    image: AssetImage(
                      "assets/images/Simplex.png",
                    ),
                    width: 200,
                  ),
                  radius: 105,
                ),
              ),
            ),
          ),
        ));
  }
}
