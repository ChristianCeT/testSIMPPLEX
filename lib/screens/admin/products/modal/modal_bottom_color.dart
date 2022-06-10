import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  /* List<Widget> _list = []; */
  /*  void initState() {
    _list = List.generate(0, (i) {
      return _rowImageAndColor(
        null,
        null,
        null,
      );
    });
    super.initState();
  } */

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
        body: _con.list.isEmpty
            ? const Center(child: Text("No hay data"))
            : Column(children: [
                Text("Imagenes añadidas ${_con.list.length}"),
                Expanded(
                  child: ListView.builder(
                    itemCount: _con.list.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: UniqueKey(),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            const Spacer(),
                            SlidableAction(
                              flex: 1,
                              onPressed: (_) {
                                _con.list.removeAt(index);
                                refresh();
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
                              _con.list.removeAt(index);
                              refresh();
                            },
                          ),
                        ),
                        child: _con.list[index],
                      );
                    },
                  ),
                ),
              ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.primaryColor,
          onPressed: () {
            _con.list.add(_rowImageAndColor(
              null,
              null,
              null,
            ));
            refresh();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _rowImageAndColor(
      File? imageFile, int? numberFile, String? imageProductEditT) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _con.showAlertDialog();
            }, // cuando hay un parametro
            child: imageFile != null
                ? SizedBox(
                    height: 140,
                    width: 40,
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(
                    height: 100,
                    width: 100,
                    child: Image(
                      image: imageProductEditT != null
                          ? NetworkImage(imageProductEditT)
                          : const AssetImage('assets/images/noImagen.png')
                              as ImageProvider,
                    )),
          ),
          Column(
            children: [
              const Text("Hola"),
              Container(
                width: 10,
                height: 10,
                color: Colors.red,
              )
            ],
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
