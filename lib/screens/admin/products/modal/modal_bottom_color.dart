import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simpplex_app/screens/admin/products/modal/modal_bottom_color_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';

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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Scaffold(
        body: _con.listMap.isEmpty
            ? const Center(child: Text("No hay data"))
            : Column(children: [
                Text("Imagenes añadidas ${_con.listMap.length}"),
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
                        child: _rowImageAndColor(
                            _con.listMap[index]["file"], index),
                      );
                    },
                  ),
                ),
              ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.primaryColor,
          onPressed: () {
            setState(() {
              _con.listMap.add({
                "posicion": _con.listMap.length,
                "file": null,
                "path": null,
                "color": null,
              });
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _rowImageAndColor(File? imageFile, int indexImage) {
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
            child: imageFile != null
                ? SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(
                      image: AssetImage('assets/images/noImagen.png'),
                    )),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Selecciona tu color"),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _con.pickerColor,
                          onColorChanged: _con.changeColor,
                          hexInputBar: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    MyColors.primaryColor)),
                            onPressed: () {
                              _con.updateColor(indexImage);
                            },
                            child: const Text(
                              "Elegir",
                            )),
                      ],
                    );
                  });
            },
            child: Column(
              children: [
                const Text("Color"),
                Container(
                  width: 25,
                  height: 25,
                  color: _con.listMap[indexImage]["color"] ??
                      MyColors.primaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
