import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/screens/client/address/list/client_address_list_controller.dart';
import 'package:simpplex_app/utils/utils.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({Key? key}) : super(key: key);

  static String routeName = "/client/address/list";

  @override
  _ClientAddressListPageState createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  final ClientAddressListController _con = ClientAddressListController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Direcciones"),
        actions: [
          _iconAdd(),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            child: _textSelectAddress(),
            top: 0,
          ),
          Container(
              margin: EdgeInsets.only(top: size.height * 0.08),
              child: _listAddress(size)),
        ],
      ),
    );
  }

  Widget _noAddress() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(),
          child: const NoDataWidget(
            text: "Agrega una nueva dirección",
          ),
        ),
        _buttonNewAddress()
      ],
    );
  }

  Widget _buttonNewAddress() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: _con.goToNewAddress,
        child: const Text("Nueva dirección"),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _listAddress(Size size) {
    return Column(
      children: [
        FutureBuilder(
            future: _con.getAddress(),
            builder: (context, AsyncSnapshot<List<Address>?> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  _con.totalAddress = snapshot.data!.length;
                  return Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _radioSelectorAddress(
                              snapshot.data![index], index);
                        }),
                  );
                } else {
                  return _noAddress();
                }
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ));
              }
            }),
        _con.totalAddress > 0 ? _buttonAccept(size) : Container()
      ],
    );
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _con.radioValue,
                onChanged: _con.handleRadioValueChange,
                activeColor: MyColors.primaryColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.direccion ?? "",
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(address.avenida ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                      )),
                ],
              )
            ],
          ),
          Divider(
            color: MyColors.primaryColor,
          )
        ],
      ),
    );
  }

  Widget _buttonAccept(Size size) {
    return Container(
      height: 50,
      width: double.infinity,
      margin:
          EdgeInsets.symmetric(vertical: size.height * 0.07, horizontal: 30),
      child: ElevatedButton(
        onPressed: _con.createOrder,
        child: const Text("PAGAR"),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _textSelectAddress() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: const Text(
        "Elige donde recibir tus compras",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _iconAdd() {
    return IconButton(
        onPressed: _con.goToNewAddress,
        icon: const Icon(
          Icons.add_outlined,
          color: Colors.white,
        ));
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
