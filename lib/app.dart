import 'package:client_exhibideas/screens/splash/splash_screen.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/utils/routes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Exhibideas",
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen1.routeName,
      routes: routes,
      theme: ThemeData(
          backgroundColor: MyColors.primaryColor,
          appBarTheme: const AppBarTheme(elevation: 0)),
    );
  }
}
