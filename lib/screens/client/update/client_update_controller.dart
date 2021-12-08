import 'dart:convert';
import 'dart:io';
import 'package:client_exhibideas/models/response_api.dart';
import 'package:client_exhibideas/models/user.dart';
import 'package:client_exhibideas/provider/user_provider.dart';
import 'package:client_exhibideas/screens/client/products/client_products_menu/client_products_menu.dart';
import 'package:client_exhibideas/utils/my_snackbar.dart';
import 'package:client_exhibideas/utils/share_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ClientUpdateController {
  BuildContext context;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController lastnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;
  ProgressDialog _progressDialog;
  bool isEnable = true;
  User user;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read("user"));
    usersProvider.init(context, sessionUser: user);
    emailController.text = user.correo;
    nameController.text = user.nombre;
    lastnameController.text = user.apellido;
    phoneController.text = user.telefono;
    refresh();
  }

  void update() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (confirmPassword != password) {
      MySnackBar.show(context, "Las contraseñas no coinciden");
      return;
    }

    _progressDialog.show(max: 100, msg: "Espere un momento....");
    isEnable = false;

    User myUser = new User(
      id: user.id,
      nombre: name,
      apellido: lastname,
      correo: email,
      telefono: phone,
      image: user.image,
      password: password,
    );

    Stream stream = await usersProvider.updateWithImage(myUser, imageFile);

    stream.listen((res) async {
      // devuelve un responseApi de user
      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message);

      if (responseApi.success) {
        ResponseApi responseApi2 = await usersProvider.getById(myUser.id);
        User userData = await User.fromJson(responseApi2.data);

        print("USUARIO OBTENIDO JSON ${userData.toJson()}");
        _sharedPref.save(
            'user', userData.toJson()); // guardar el usuario en sesión

        Navigator.pushNamedAndRemoveUntil(
            context, ClienteProductsMenu.routeName, (route) => false);
      } else {
        isEnable = true;
      }
    });
  }

  Future selectedImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile?.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectedImage(ImageSource.gallery);
        },
        child: Text("Galería"));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectedImage(ImageSource.camera);
        },
        child: Text("Camara"));

    AlertDialog alertDialog = AlertDialog(
      title: Text("Selecciona tu imagen"),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void back() {
    Navigator.pop(context);
  }
}
