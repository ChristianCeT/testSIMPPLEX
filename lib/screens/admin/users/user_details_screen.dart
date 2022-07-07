import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/screens/admin/users/list_users.dart';
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _con.userData = data[0] as User;
    _con.parameter = data[1] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("Usuario ${data[0].nombre}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacementNamed(context, UserScreen.routeName,
                arguments: _con.parameter);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _imageUser(),
            _userForm(data[0]),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_outlined),
        backgroundColor: MyColors.primaryColor,
        onPressed: _con.updateUser,
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile!)
            : _con.userData?.image != null
                ? NetworkImage(_con.userData!.image!)
                : const AssetImage("assets/images/noAvatar2.png")
                    as ImageProvider,
        radius: 75,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _userForm(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
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
                value: user.roles![0].active,
                onChanged: (value) {},
              ),
              SwitchListTile.adaptive(
                activeColor: MyColors.primaryColor,
                title: const Text(
                  "REPARTIDOR:",
                  style: TextStyle(fontSize: 15),
                ),
                value: user.roles![1].active,
                onChanged: (value) {
                  _con.updateAvailableRolUser(value, 1);
                },
              ),
              SwitchListTile.adaptive(
                activeColor: MyColors.primaryColor,
                title: const Text(
                  "ADMINISTRADOR:",
                  style: TextStyle(fontSize: 15),
                ),
                value: user.roles![2].active,
                onChanged: (value) {
                  _con.updateAvailableRolUser(value, 2);
                },
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
