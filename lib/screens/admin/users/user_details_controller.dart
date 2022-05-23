
import 'package:flutter/material.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/utils/share_preferences.dart';

class AdminUserDetailsController {
  late BuildContext context;
  late Function refresh;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? user;
  SharedPref sharedPref = SharedPref();
  late User? userData;
  List<User>? users = [];

  final UsersProvider _usersProvider = UsersProvider();


  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read("user"));
    emailController.text = userData?.correo ?? "";
    nameController.text = userData?.nombre ?? "";
    lastnameController.text = userData?.apellido ?? "";
    phoneController.text = userData?.telefono ?? "";
    _usersProvider.init(context, sessionUser: user);
    refresh();
  }

 
}
