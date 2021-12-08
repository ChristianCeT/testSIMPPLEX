import 'package:client_exhibideas/screens/Login/login_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  static String routeName = "/Login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // _ privada sin raya al piso variable publica

  LoginController _con = new LoginController();

  // metodo que se ejecuta al abrir un page
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      color: Colors.white,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(top: -92, left: -100, child: _circleLogin()),
          Positioned(top: 55, left: 25, child: _textLogin()),
          SingleChildScrollView(
            child: Column(
              children: [
                _imageBanner(),
                /*   _lottieAnimation(), */
                _textFieldEmail(),
                _textFieldPassword(),
                _buttonLogin(),
                _textDontHaveAcoount(),
              ],
            ),
          ),
        ],
      ),
    ));
  }

/*   Widget _lottieAnimation() {
    return Lottie.asset("assets/json/Furniture.json",
        width: 150, height: 150, fit: BoxFit.fill);
  } */

  Widget _textLogin() {
    return Text(
      "LOGIN",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _textDontHaveAcoount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("¿No tienes cuenta?"),
        SizedBox(
          width: 7,
        ),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            "Registrate aquí",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: MyColors.primaryColor),
          ),
        )
      ],
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.login,
        child: Text("Ingresar"),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: "Contraseña",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: "Correo electrónico",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _circleLogin() {
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor),
    );
  }

  Widget _imageBanner() {
    return Container(
      margin: EdgeInsets.only(
          top: 100, bottom: MediaQuery.of(context).size.height * 0.01),
      child: Image.asset(
        "assets/images/LOGO3.png",
        width: 300,
        height: 180,
      ),
    );
  }
}
