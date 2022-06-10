import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ModalBottomColorController {
  late BuildContext context;
  late Function refresh;

  PickedFile? pickedFile;
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  ProgressDialog? _progressDialog;
  List<Widget> list = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context);
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
