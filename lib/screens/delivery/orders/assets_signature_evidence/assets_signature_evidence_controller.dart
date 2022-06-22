import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/orders_provider.dart';
import 'package:simpplex_app/utils/share_preferences.dart';
import 'package:flutter/material.dart';

class AssetsSignatureListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();

  File? imageFile;

  File? imageFileReturn;

  File? imageSignature;

  final OrdersProvider _ordersProvider = OrdersProvider();

  List<Point>? pointsValue = [];

  final SignatureController controllerSignature = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> iconButtons = [
    {"icono": const Icon(Icons.check, color: Colors.white), "accion": 1},
    {"icono": const Icon(Icons.arrow_back, color: Colors.white), "accion": 2},
    {
      "icono": const Icon(Icons.arrow_forward, color: Colors.white),
      "accion": 3
    },
    {"icono": const Icon(Icons.clear, color: Colors.white), "accion": 4}
  ];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(
        await sharedPref.read("user")); // PUEDE TARDAR UN TIEMPO EN OBTENER
    _ordersProvider.init(context, user!);

    if (imageFileReturn != null ||
        pointsValue != null ||
        imageSignature != null) {
      imageFile = imageFileReturn;
      controllerSignature.points = pointsValue ?? [];
    }

    refresh();
  }

  Future selectedImage(ImageSource imageSource) async {
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.canPop(context);
    refresh();
  }

  void convertToFile(imageFileUint8List) async {
    final tempDir = await getTemporaryDirectory();

    File fileSignature = File(
        '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');

    if (imageFileUint8List != null) {
      fileSignature.writeAsBytesSync(imageFileUint8List);
      imageSignature = fileSignature;
    }
  }
}
