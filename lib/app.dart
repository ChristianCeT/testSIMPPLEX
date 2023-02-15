import 'package:simpplex_app/screens/splash2.0/splash.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return MaterialApp(
      title: "EXHIBIDEAS",
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreenV2.routName,
      routes: routes,
      theme: ThemeData.light().copyWith(
        primaryColor: MyColors.primaryColor,
        backgroundColor: MyColors.primaryColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: MyColors.primaryColor,
        ),
      ),
    );
  }
}
