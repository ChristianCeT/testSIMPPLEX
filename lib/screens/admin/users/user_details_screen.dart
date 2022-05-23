import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/screens/admin/users/user_details_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/input_decorations.dart';

class AdminUserDetailsScreen extends StatefulWidget {
  static const routeName = "/admin/users/details";

  const AdminUserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AdminUserDetailsScreen> createState() => _AdminUserDetailsScreenState();
}

class _AdminUserDetailsScreenState extends State<AdminUserDetailsScreen> {
  final AdminUserDetailsController _con = AdminUserDetailsController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    _con.userData = user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuario ${user.nombre}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _userForm(user),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_outlined),
        backgroundColor: MyColors.primaryColor,
        onPressed: () {
          print("GUARDAR DATOS ACTUALIZADOS");
        },
      ),
    );
  }

  Widget _userForm(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Column(children: [
          Column(
            children: [
              _textFieldEmail(),
              _textFieldName(),
              _textFieldLastName(),
              _textFieldPhone(),
              _textFieldPassword(),
              SwitchListTile.adaptive(
                activeColor: MyColors.primaryColor,
                title: const Text(
                  "CLIENTE:",
                  style: TextStyle(fontSize: 15),
                ),
                value: user.roles?[0].nombre == null ? false : true,
                onChanged: (value) {},
              ),
              SwitchListTile.adaptive(
                activeColor: MyColors.primaryColor,
                title: const Text(
                  "REPARTIDOR:",
                  style: TextStyle(fontSize: 15),
                ),
                value: user.roles!.length > 1 &&
                        user.roles![1].nombre == "REPARTIDOR"
                    ? true
                    : user.roles!.length > 2 &&
                            user.roles![2].nombre == "REPARTIDOR"
                        ? true
                        : false,
                onChanged: (value) {},
              ),
              SwitchListTile.adaptive(
                activeColor: MyColors.primaryColor,
                title: const Text(
                  "ADMINISTRADOR:",
                  style: TextStyle(fontSize: 15),
                ),
                value: user.roles!.length > 1 &&
                        user.roles![1].nombre == "ADMIN"
                    ? true
                    : user.roles!.length > 2 && user.roles![2].nombre == "ADMIN"
                        ? true
                        : false,
                onChanged: (value) {},
              ),
            ],
          )
        ]),
      ),
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

  void refresh() {
    setState(() {});
  }
}
