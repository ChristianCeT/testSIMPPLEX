import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simpplex_app/models/response_api.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/screens/admin/users/list_users.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AdminUserDetailsController {
  late BuildContext context;
  late Function refresh;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? user;
  final SharedPref _sharedPref = SharedPref();
  late User? userData;
  bool isEnable = true;
  List<User>? users = [];
  UsersProvider usersProvider = UsersProvider();
  final ImagePicker _picker = ImagePicker();
  ProgressDialog? _progressDialog;
  File? imageFile;

  late String parameter;

  final UsersProvider _usersProvider = UsersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read("user"));
    usersProvider.init(context, sessionUser: user);
    emailController.text = userData?.correo ?? "";
    nameController.text = userData?.nombre ?? "";
    lastnameController.text = userData?.apellido ?? "";
    phoneController.text = userData?.telefono ?? "";
    _usersProvider.init(context, sessionUser: user);
    refresh();
  }

  updateAvailableRolUser(bool rolactive, int posicion) {
    userData?.roles![posicion].active == true
        ? userData?.roles![posicion].active = false
        : userData?.roles![posicion].active = true;
    refresh();
  }

  void updateUser() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    _progressDialog!.show(
        max: 100,
        msg: "Espere un momento....",
        progressBgColor: MyColors.primaryColor,
        progressValueColor: Colors.grey[300] ?? Colors.grey);
    isEnable = false;

    User dataUser = User(
        id: userData!.id,
        correo: email,
        nombre: name,
        apellido: lastname,
        telefono: phone,
        password: password,
        roles: userData?.roles);

    Stream? stream =
        await usersProvider.updateUserWithImagev2(dataUser, imageFile);

    stream?.listen((res) async {
      // devuelve un responseApi de user
      _progressDialog!.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message!);

      if (responseApi.success!) {
        if (responseApi.data['_id'] == user!.id) {
          userData = User.fromJson(responseApi.data);
          _sharedPref.save('user', userData!.toJson());
          Navigator.pushReplacementNamed(
              context, UserScreen.routeName,
              arguments: parameter);
          refresh();
        }
        Navigator.pushReplacementNamed(
            context, UserScreen.routeName,
            arguments: parameter);
        refresh();
      } else {
        isEnable = true;
      }
    });

    refresh();
  }

  Future selectedImage(ImageSource image) async {
    final XFile? pickedFile = await _picker.pickImage(source: image);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      refresh();
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        selectedImage(ImageSource.gallery);
      },
      child: const Text("Galería"),
    );

    Widget cameraButton = ElevatedButton(
      onPressed: () {
        selectedImage(ImageSource.camera);
      },
      child: const Text("Camara"),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Selecciona tu imagen"),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
