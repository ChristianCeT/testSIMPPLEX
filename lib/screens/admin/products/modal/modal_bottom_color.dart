import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simpplex_app/screens/admin/products/modal/modal_bottom_color_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/input_decorations.dart';

class ModalBottomScreenProduct extends StatefulWidget {
  const ModalBottomScreenProduct({Key? key}) : super(key: key);

  @override
  State<ModalBottomScreenProduct> createState() =>
      _ModalBottomScreenProductState();
}

class _ModalBottomScreenProductState extends State<ModalBottomScreenProduct> {
  final ModalBottomColorController _con = ModalBottomColorController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listMap = ModalRoute.of(context)!.settings.arguments
        as List<Map<String, dynamic>>;

    _con.listMap = listMap;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Scaffold(
        body: _con.listMap.isEmpty
            ? const Center(child: Text("No hay data"))
            : Column(children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Imágenes subidas: ",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.5), fontSize: 17),
                    ),
                    Text(
                      "${_con.listMap.length}",
                      style: TextStyle(
                          color: MyColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _con.listMap.length,
                    itemBuilder: (_, index) {
                      _con.index = index;
                      return Slidable(
                        key: UniqueKey(),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            const Spacer(),
                            SlidableAction(
                              flex: 1,
                              onPressed: (_) {
                                _con.deleteImage(index);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Borrar',
                            ),
                          ],
                          dismissible: DismissiblePane(
                            closeOnCancel: true,
                            onDismissed: () {
                              _con.deleteImage(index);
                            },
                          ),
                        ),
                        child: _rowImageAndColor(_con.listMap[index], index),
                      );
                    },
                  ),
                ),
              ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.primaryColor,
          onPressed: () {
            setState(() {
              _con.listMap.add({
                "posicion": _con.listMap.length,
                "file": null,
                "path": null,
                "color": null,
                "colorName": null,
              });
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _rowImageAndColor(Map listMap, int indexImage) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            key: UniqueKey(),
            onTap: () {
              _con.showAlertDialog(indexImage);
            }, // cuando hay un parametro
            child: listMap["file"] != null
                ? _imageProduct(
                    Image.file(
                      listMap["file"],
                      fit: BoxFit.fill,
                    ),
                  )
                : listMap["path"] != null
                    ? _imageProduct(
                        Image.network(
                          listMap["path"],
                          fit: BoxFit.fill,
                        ),
                      )
                    : _imageProduct(
                        const Image(
                          image: AssetImage('assets/images/noImagen.png'),
                        ),
                      ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _colorWidget(indexImage);
                },
              );
            },
            child: SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _con.listMap[indexImage]["color"] == null
                        ? "Ninguno"
                        : _con.listMap[indexImage]["colorName"],
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircleAvatar(
                      backgroundColor: _con.listMap[indexImage]["color"] ??
                          MyColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Widget child) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        height: 92,
        width: 95,
        child: child,
      ),
    );
  }

  Widget _colorWidget(int indexImage) {
    return AlertDialog(
      title: TextField(
        controller: _con.colorNameController,
        decoration: InputDecorations.authInputDecoration(
            hintText: "Azul marino", labelText: "Ingrese el nombre del color"),
      ),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: _con.pickerColor,
          onColorChanged: _con.changeColor,
          hexInputBar: true,
          pickerAreaHeightPercent: 0.75,
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(MyColors.primaryColor),
          ),
          onPressed: () {
            _con.colorNameController.text.isEmpty
                ? "No"
                : _con.updateColor(indexImage);
          },
          child: const Text(
            "Elegir",
          ),
        ),
      ],
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
