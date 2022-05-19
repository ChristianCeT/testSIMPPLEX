import 'package:simpplex_app/screens/client/update/client_update_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({Key? key}) : super(key: key);
  static String routeName = "/client/update";

  @override
  _ClientUpdatePageState createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {
  final ClientUpdateController _con = ClientUpdateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar perfil")),
      body: Container(
          width: double.infinity,
          color: Colors.white,
          height: double.infinity,
          child: (SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                _imageUser(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      _textFieldEmail(),
                      const SizedBox(height: 10),
                      _textFieldName(),
                      const SizedBox(height: 10),
                      _textFieldLastName(),
                      const SizedBox(height: 10),
                      _textFieldPhone(),
                      const SizedBox(height: 10),
                      _textFieldPassword(),
                      const SizedBox(height: 10),
                      _textFieldConfirmPassword(),
                      const SizedBox(height: 10),
                      _buttonUpdateData(),
                    ],
                  ),
                ),
              ],
            ),
          ))),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile!)
            : _con.user?.image != null
                ? NetworkImage(_con.user!.image!)
                : const AssetImage("assets/images/noAvatar2.png")
                    as ImageProvider,
        radius: 55,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _textFieldEmail() {
    return TextField(
      controller: _con.emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: MyColors.primaryColor,
      decoration: InputDecorations.authInputDecoration(
          hintText: "Correo electrónico",
          labelText: "Correo electrónico",
          prefixIcon: Icons.email_outlined),
    );
  }

  Widget _textFieldName() {
    return TextField(
      controller: _con.nameController,
      keyboardType: TextInputType.text,
      cursorColor: MyColors.primaryColor,
      decoration: InputDecorations.authInputDecoration(
        hintText: "Nombre",
        labelText: "Nombre de usuario",
        prefixIcon: Icons.person_outline,
      ),
    );
  }

  Widget _textFieldLastName() {
    return TextField(
        controller: _con.lastnameController,
        keyboardType: TextInputType.text,
        cursorColor: MyColors.primaryColor,
        decoration: InputDecorations.authInputDecoration(
          hintText: "Apellido",
          labelText: "Apellido del usuario",
          prefixIcon: Icons.person_outline,
        ));
  }

  Widget _textFieldPhone() {
    return TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecorations.authInputDecoration(
          hintText: "Teléfono",
          labelText: "Teléfono",
          prefixIcon: Icons.phone_android_outlined,
        ));
  }

  Widget _textFieldPassword() {
    return TextField(
      controller: _con.passwordController,
      obscureText: true,
      decoration: InputDecorations.authInputDecoration(
          hintText: "Contraseña",
          labelText: "Contraseña",
          prefixIcon: Icons.lock_outline),
    );
  }

  Widget _textFieldConfirmPassword() {
    return TextField(
      controller: _con.confirmPasswordController,
      obscureText: true,
      decoration: InputDecorations.authInputDecoration(
          hintText: "Confirmar contraseña",
          labelText: "Confirmar contraseña",
          prefixIcon: Icons.lock_outline),
    );
  }

  Widget _buttonUpdateData() {
    return MaterialButton(
        onPressed: _con.isEnable ? _con.update : null,
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
        ));
  }

  void refresh() {
    setState(() {});
  }
}
