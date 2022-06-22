import 'dart:convert';
import 'dart:io';
import 'package:simpplex_app/models/response_api.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/screens/Login/login_page.dart';
import 'package:simpplex_app/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RegisterController {
  late BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  File? imageFile;
  late Function refresh;

  late ProgressDialog _progressDialog;

  final ImagePicker _picker = ImagePicker();

  bool isEnable = true;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void register() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastname.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      MySnackBar.show(context, "Debes ingresar todos los campos");
      return;
    }

    validateEmail(email);

    if (confirmPassword != password) {
      MySnackBar.show(context, "Las contraseñas no coinciden");
      return;
    }

    if (password.length < 6) {
      MySnackBar.show(
          context, "La contraseña debe tener al menos 6 caracteres");
      return;
    }

    _progressDialog.show(max: 100, msg: "Espere un momento");
    isEnable = false;

    User user = User(
      nombre: name,
      apellido: lastname,
      correo: email,
      telefono: phone,
      password: password,
    );

    Stream? stream = await usersProvider.createWithImage(user, imageFile);

    stream?.listen((res) {
      // devuelve un responseApi de user
      /* ResponseApi responseApi = await usersProvider.create(user); */

      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print("RESPUESTA: ${responseApi.toJson()}");

      MySnackBar.show(context, responseApi.message!);

      if (responseApi.success!) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        });
      } else {
        isEnable = true;
      }
    });
  }

  Future selectedImage(ImageSource imageSource) async {
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectedImage(ImageSource.gallery);
        },
        child: const Text("Galería"));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectedImage(ImageSource.camera);
        },
        child: const Text("Cámara"));

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

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      MySnackBar.show(context, "Ingresa un correo válido");
    }
    return null;
  }

  void back() {
    Navigator.pop(context);
  }
}
