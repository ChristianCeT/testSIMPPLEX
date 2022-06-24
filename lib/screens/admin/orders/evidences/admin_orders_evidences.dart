import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simpplex_app/models/orders.dart';
import 'package:simpplex_app/utils/my_colors.dart';

class AdminEvidencesScreen extends StatelessWidget {
  const AdminEvidencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _photoEvidence(
            "Firma del Cliente: ${order.cliente!.nombre} ${order.cliente!.apellido}",
            order.firmaEvidencia!,
          ),
          const SizedBox(
            height: 15,
          ),
          _photoEvidence(
              "Evidencia de la entrega del pedido", order.fotoEvidencia!),
        ],
      ),
    );
  }

  Widget _photoEvidence(String title, String foto) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.primaryColor.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                width: 150,
                height: 170,
                child: Image(image: NetworkImage(foto), fit: BoxFit.fill),
              ),
              OutlinedButton(
                onPressed: () async {
                  final tempDir = await getTemporaryDirectory();

                  final path = "${tempDir.path}/${DateTime.now()}.png";

                  await Dio().download(foto, path);

                  final respuesta =
                      await GallerySaver.saveImage(path, toDcim: true);

                  if (respuesta == true) {
                    Fluttertoast.showToast(
                        msg: "Imagen guardada con éxito",
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: MyColors.primaryColor);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Error al guardar una imagen",
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: MyColors.primaryColor);
                  }
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      MyColors.primaryColor.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                child: Icon(
                  Icons.download,
                  color: MyColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
