import 'package:simpplex_app/screens/Login/login_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/input_decorations.dart';
import 'package:simpplex_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String routeName = "/Login";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // _ privada sin raya al piso variable publica

  final LoginController _con = LoginController();

  // metodo que se ejecuta al abrir un page
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BackgroundWidget(
        page: "loginPage",
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.24),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Image(
                      image: AssetImage("assets/images/Simplex.png"),
                    ),
                    const SizedBox(height: 30),
                    _loginForm(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Aún no tienes cuenta?"),
                        TextButton(
                          onPressed: _con.goToRegisterPage,
                          child: Text(
                            "Click aquí",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: MyColors.primaryColor),
                          ),
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                MyColors.primaryColor.withOpacity(0.07)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      children: [
        _textFieldEmail(),
        const SizedBox(height: 30),
        _textFieldPassword(),
        const SizedBox(height: 30),
        MaterialButton(
          key: const Key("buttonLogin"),
          onPressed: _con.login,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledColor: Colors.grey,
          elevation: 0,
          color: MyColors.primaryColor,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: const Text(
              'Ingresar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldEmail() {
    return TextField(
      key: const Key('inputEmail'),
      autocorrect: false,
      controller: _con.emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecorations.authInputDecoration(
        hintText: 'jhon.doe@hotmail.com',
        labelText: 'Correo electrónico',
        prefixIcon: Icons.alternate_email_rounded,
      ),
    );
  }

  Widget _textFieldPassword() {
    return TextField(
      key: const Key('inputPassword'),
      controller: _con.passwordController,
      obscureText: true,
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: InputDecorations.authInputDecoration(
        hintText: '******',
        labelText: 'Contraseña',
        prefixIcon: Icons.lock_outline,
      ),
    );
  }
}
