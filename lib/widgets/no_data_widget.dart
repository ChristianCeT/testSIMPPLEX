import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String text;
  const NoDataWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      padding: const EdgeInsets.all(70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/no-items.png", fit: BoxFit.contain),
          Text(text)
        ],
      ),
    );
  }
}
