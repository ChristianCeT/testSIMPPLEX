import 'package:client_exhibideas/models/address.dart';
import 'package:client_exhibideas/screens/client/address/list/client_address_list_controller.dart';
import 'package:client_exhibideas/utils/my_colors.dart';
import 'package:client_exhibideas/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientAddressListPage extends StatefulWidget {
  ClientAddressListPage({Key key}) : super(key: key);

  static String routeName = "/client/address/list";

  @override
  _ClientAddressListPageState createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  ClientAddressListController _con = new ClientAddressListController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Direcciones"),
        actions: [
          _iconAdd(),
        ],
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned(
            child: _textSelectAddress(),
            top: 0,
          ),
          Container(margin: EdgeInsets.only(top: 50), child: _listAddress())
        ],
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _noAddress() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(),
          child: NoDataWidget(
            text: "Agrega una nueva dirección",
          ),
        ),
        _buttonNewAddress()
      ],
    );
  }

  Widget _buttonNewAddress() {
    return Container(
      height: 40,
      child: ElevatedButton(
        onPressed: _con.goToNewAddress,
        child: Text("Nueva dirección"),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: Colors.green),
      ),
    );
  }

  Widget _listAddress() {
    return FutureBuilder(
        future: _con.getAddress(),
        builder: (context, AsyncSnapshot<List<Address>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index) {
                    return _radioSelectorAddress(snapshot.data[index], index);
                  });
            } else {
              return _noAddress();
            }
          } else {
            return NoDataWidget(
              text: "No hay productos",
            );
          }
        });
  }

  Widget _radioSelectorAddress(Address address, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                  value: index,
                  groupValue: _con.radioValue,
                  onChanged: _con.handleRadioValueChange),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address?.direccion ?? "",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(address?.avenida ?? "",
                      style: TextStyle(
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

  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: _con.createOrder,
        child: Text("PAGAR"),
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
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        "Elige donde recibir tus compras",
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _iconAdd() {
    return IconButton(
        onPressed: _con.goToNewAddress,
        icon: Icon(
          Icons.add_outlined,
          color: Colors.white,
        ));
  }

  void refresh() {
    setState(() {});
  }
}
