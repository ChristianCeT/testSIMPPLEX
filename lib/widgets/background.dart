import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final String page;
  const BackgroundWidget({Key? key, required this.child, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [
        const _PurpleBox(),
        _HeaderWidget(
          page: page,
        ),
        child,
      ]),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final String page;
  const _HeaderWidget({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: page == "loginPage" ? 200 : 0,
        child: page == "loginPage"
            ? const Icon(
                Icons.person_pin,
                color: Colors.white,
                size: 100,
              )
            : Container(),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(children: const [
        //Es para posicionar elementos en un stack
        Positioned(child: _Bubble(), top: 90, left: 30),
        Positioned(child: _Bubble(), top: -40, left: -30),
        Positioned(child: _Bubble(), top: -50, right: -20),
        Positioned(child: _Bubble(), bottom: -50, left: -10),
        Positioned(child: _Bubble(), bottom: 120, right: 20),
      ]),
    );
  }

  //Metodo que renderiza el gradiente
  BoxDecoration _purpleBackground() => const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(252, 171, 4, 100),
          Color.fromRGBO(252, 172, 4, 100),
        ]),
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.2),
      ),
    );
  }
}
