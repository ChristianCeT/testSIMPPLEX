import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalBottomColorController {
  late BuildContext context;
  late Function refresh;

  PickedFile? pickedFile;
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  int index = 0;

  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  List<Map<String, dynamic>> listMap = [];

  final TextEditingController colorNameController = TextEditingController();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    refresh();
  }

  Future selectedImage(ImageSource image, int indexImage) async {
    final XFile? pickedFile = await _picker.pickImage(source: image);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      listItemsPhoto(indexImage);
      refresh();
    }
    Navigator.pop(context);
    refresh();
  }

  void listItemsPhoto(int index) {
    if (imageFile != null) {
      if (index == listMap[index]["posicion"]) {
        listMap[index]["file"] = imageFile;
        listMap[index]["path"] = imageFile?.path;
      }
    }
    refresh();
  }

  void showAlertDialog(int indexImage) {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        selectedImage(ImageSource.gallery, indexImage);
      },
      child: const Text("Galería"),
    );

    Widget cameraButton = ElevatedButton(
      onPressed: () {
        selectedImage(ImageSource.camera, indexImage);
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

  void changeColor(Color color) {
    pickerColor = color;
    refresh();
  }

  void updateColor(int indexImage) {
    currentColor = pickerColor;
    listMap[indexImage]["color"] = currentColor;
    listMap[indexImage]["colorName"] = colorNameController.text;
    colorNameController.text = "";
    Navigator.of(context).pop();
    refresh();
  }

  void deleteImage(int indexImage) {
    listMap.removeAt(indexImage);

    for (var element in listMap) {
      if (element["posicion"] > indexImage) {
        element["posicion"]--;
      }
    }

    refresh();
  }
}
