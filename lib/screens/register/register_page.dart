import 'package:client_exhibideas/screens/register/register_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../widgets/input_decorations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);
  static String routeName = "/register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _con = RegisterController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BackgroundWidget(
        page: "createAccount",
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                CardContainer(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Image(
                            image: AssetImage("assets/images/Simplex.png"),
                            height: 38,
                          ),
                          _imageUser()
                        ],
                      ),
                      _registerForm(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya tienes una cuenta?"),
                          TextButton(
                            onPressed: _con.back,
                            child: Text(
                              "Ingresa aquí",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: MyColors.primaryColor),
                            ),
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                MyColors.primaryColor.withOpacity(0.07),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile)
            : const AssetImage("assets/images/noAvatar2.png"),
        radius: 45,
        backgroundColor: Colors.grey[350],
      ),
    );
  }

  Widget _registerForm() {
    return Column(
      children: [
        _textFieldEmail(),
        const SizedBox(height: 15),
        _textFieldName(),
        const SizedBox(height: 15),
        _textFieldLastName(),
        const SizedBox(height: 15),
        _textFieldPhone(),
        const SizedBox(height: 15),
        _textFieldPassword(),
        const SizedBox(height: 15),
        _textFieldConfirmPassword(),
        const SizedBox(height: 15),
        MaterialButton(
          onPressed: _con.isEnable ? _con.register : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledColor: Colors.grey,
          elevation: 0,
          color: MyColors.primaryColor,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: const Text(
              'Registarte',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldEmail() {
    return TextField(
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

  Widget _textFieldName() {
    return TextField(
      autocorrect: false,
      controller: _con.nameController,
      keyboardType: TextInputType.text,
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Jhon',
        labelText: 'Nombre',
        prefixIcon: Icons.person_outline_rounded,
      ),
    );
  }

  Widget _textFieldLastName() {
    return TextField(
      autocorrect: false,
      controller: _con.nameController,
      keyboardType: TextInputType.text,
      decoration: InputDecorations.authInputDecoration(
        hintText: 'Doe Lore',
        labelText: 'Apellido',
        prefixIcon: Icons.person_outline_rounded,
      ),
    );
  }

  Widget _textFieldPhone() {
    return TextField(
      autocorrect: false,
      controller: _con.nameController,
      keyboardType: TextInputType.number,
      decoration: InputDecorations.authInputDecoration(
        hintText: '999666232',
        labelText: 'Teléfono',
        prefixIcon: Icons.phone_outlined,
      ),
    );
  }

  Widget _textFieldPassword() {
    return TextField(
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

  Widget _textFieldConfirmPassword() {
    return TextField(
      controller: _con.confirmPasswordController,
      obscureText: true,
      autocorrect: false,
      keyboardType: TextInputType.text,
      decoration: InputDecorations.authInputDecoration(
        hintText: '******',
        labelText: 'Confirma tu contraseña',
        prefixIcon: Icons.lock_outline,
      ),
    );
  }

/* _con.isEnable ? _con.register : null */
  void refresh() {
    setState(() {});
  }
}
