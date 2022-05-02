import 'package:client_exhibideas/screens/Login/login_page.dart';
import 'package:client_exhibideas/screens/splash/default_button.dart';
import 'package:client_exhibideas/screens/splash/splash_content.dart';
import 'package:client_exhibideas/utils/constants.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/utils/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Bienvenido a SIMPPLEX ¡A comprar!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text": "Brindamos una experiencia única \n¿Qué esperas para comprar?",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "Es fácil comprar en SIMPPLEX \nSólo quedate en casa",
      "image": "assets/images/splash_3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                          image: splashData[index]["image"]!,
                          text: splashData[index]["text"]!,
                        ))),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenHeight(20)),
                  child: Column(
                    children: [
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(splashData.length,
                            (index) => buildDot(index: index)),
                      ),
                      const Spacer(
                        flex: 3,
                      ),
                      DefaultButton(
                        text: "Continuar",
                        press: () {
                          Navigator.pushNamed(context, LoginPage.routeName);
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 6),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
          color: currentPage == index ? MyColors.primaryColor : Colors.blueGrey,
          borderRadius: BorderRadius.circular(3)),
    );
  }
}
