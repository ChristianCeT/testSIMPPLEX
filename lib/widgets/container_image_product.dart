import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simpplex_app/screens/admin/products/modal/modal_bottom_color.dart';
import 'package:simpplex_app/utils/my_colors.dart';

class ModalColorImage extends StatelessWidget {
  final List<Map> listMap;
  const ModalColorImage({Key? key, required this.listMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Añadir imagen principal"),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: MyColors.primaryColor,
                width: 1,
              ),
              primary: MyColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () async {
              await showMaterialModalBottomSheet(
                  context: context,
                  builder: (context) => const ModalBottomScreenProduct(),
                  settings: RouteSettings(
                      name: "ModalBottomScreenProduct", arguments: listMap));
            },
            child: const Text(
              "Seleccionar",
            ),
          ),
        ],
      ),
    );
  }
}
