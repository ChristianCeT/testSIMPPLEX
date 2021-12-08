import 'package:client_exhibideas/screens/register/register_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  static String routeName = "/register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController _con = new RegisterController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
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
          Positioned(top: -92, left: -100, child: _circle()),
          Positioned(top: 60, left: 25, child: _textRegister()),
          Positioned(top: 45, left: -8, child: _iconBack()),
          Positioned(top: 25, width: 200, left: 155, child: _imageBanner()),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 150),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _imageUser(),
                  SizedBox(height: 30),
                  _textFieldEmail(),
                  _textFieldName(),
                  _textFieldLastName(),
                  _textFieldPhone(),
                  _textFieldPassword(),
                  _textFieldConfirmPassword(),
                  _buttonLogin()
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile)
            : AssetImage("assets/images/noAvatar2.png"),
        radius: 55,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _circle() {
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor),
    );
  }

  Widget _iconBack() {
    return IconButton(
        onPressed: _con.back,
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 16,
        ));
  }

  Widget _textRegister() {
    return Text(
      "REGÍSTRATE",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: "Nombres",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.lastnameController,
        decoration: InputDecoration(
            hintText: "Apellidos",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person_add_alt_1_outlined,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: "Teléfono",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: MyColors.primaryColor,
            )),
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

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: "Confirmar contraseña",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.isEnable ? _con.register : null,
        child: Text("Registrarse"),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _imageBanner() {
    return Container(
      child: Image.asset(
        "assets/images/LOGO3.png",
        width: 200,
        height: 100,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
