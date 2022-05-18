import 'package:client_exhibideas/screens/splash/splash_screen.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      title: "SIMPPLEX",
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen1.routeName,
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
