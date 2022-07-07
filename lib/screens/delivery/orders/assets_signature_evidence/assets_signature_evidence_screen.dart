import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:simpplex_app/screens/delivery/orders/assets_signature_evidence/assets_signature_evidence_controller.dart';
import 'package:simpplex_app/utils/utils.dart';

class SignatureEvidenceScreen extends StatefulWidget {
  const SignatureEvidenceScreen({Key? key}) : super(key: key);

  static String routeName = "/delivery/signature";

  @override
  State<SignatureEvidenceScreen> createState() =>
      _SignatureEvidenceScreenState();
}

class _SignatureEvidenceScreenState extends State<SignatureEvidenceScreen> {
  final AssetsSignatureListController _con = AssetsSignatureListController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dataReturn =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    _con.imageFileReturn = dataReturn["imageFile"];
    _con.imageSignature = dataReturn["firmaImage"];
    _con.pointsValue = dataReturn["firma"];

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop({
              "imageFile": _con.imageFile,
              "firma": _con.pointsValue,
              "firmaImage": _con.imageSignature
            });
          },
        ),
        title: const Text("Evidencias"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: _signature(_con.controllerSignature, _con.iconButtons, size),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(children: const [
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Image(
            width: 120,
            image: AssetImage("assets/images/repartidorsignature.png"),
          ),
        ),
      ]),
    );
  }

  Widget _signature(SignatureController _controller,
      List<Map<String, dynamic>> iconButtons, Size size) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _stackTitle("INGRESAR FIRMA"),
        Container(
          clipBehavior: Clip.hardEdge,
          height: 255,
          width: 275,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: MyColors.primaryColor.withOpacity(0.5),
          ),
          child: Signature(
            controller: _controller,
            height: 250,
            width: 270,
            backgroundColor: Colors.grey[200]!,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        buttonActions(iconButtons),
        const SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 1.5,
          color: MyColors.primaryColor,
        ),
        const SizedBox(
          height: 8,
        ),
        _stackTitle("INGRESAR FOTO"),
        imageContainer(_con.imageFile, size),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Stack _stackTitle(String title) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        const Positioned(
          child: Image(
            image: AssetImage("assets/images/rectanglecloud.png"),
          ),
        ),
        Positioned(
          top: 10,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonActions(List<Map<String, dynamic>> iconButtons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: iconButtons.map((button) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryColor.withOpacity(0.3),
                spreadRadius: 5,
              )
            ],
            borderRadius: BorderRadius.circular(38),
          ),
          width: 38,
          height: 38,
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () async {
              if (button["accion"] == 1) {
                _con.pointsValue = _con.controllerSignature.points;

                final imageFileUint8List =
                    await _con.controllerSignature.toPngBytes();

                _con.convertToFile(imageFileUint8List);
              } else if (button["accion"] == 2) {
                _con.controllerSignature.undo();
              } else if (button["accion"] == 3) {
                _con.controllerSignature.redo();
              } else {
                _con.controllerSignature.clear();
                _con.pointsValue = null;
                _con.imageSignature = null;
              }
            },
            child: button["icono"],
            backgroundColor: MyColors.primaryColor,
            elevation: 1,
          ),
        );
      }).toList(),
    );
  }

  Widget imageContainer(File? imageFile, Size size) {
    return GestureDetector(
      onTap: () {
        _con.selectedImage(ImageSource.camera);
      }, // cuando hay un parametro
      child: imageFile != null
          ? Stack(children: [
              Container(
                height: 220,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: MyColors.primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12)),
                width: size.width * 0.673,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  height: 200,
                  alignment: Alignment.centerLeft,
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.fill,
                    width: size.width * 0.6,
                  ),
                ),
              ),
            ])
          : Stack(
              children: [
                Container(
                  height: 220,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12)),
                  width: size.width * 0.673,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    height: 200,
                    alignment: Alignment.centerLeft,
                    child: Image(
                      fit: BoxFit.fill,
                      width: size.width * 0.6,
                      image: const AssetImage(
                        'assets/images/noImagen.png',
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
