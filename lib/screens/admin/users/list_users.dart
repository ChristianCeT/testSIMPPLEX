import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/screens/admin/users/list_users_controller.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);
  static const String routeName = '/admin/users/list';

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AdminUserListController _con = AdminUserListController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios '),
      ),
      body: Column(
        children: [
          Text("USUARIOS REGISTRADOS: ${_con.totalNumbers}"),
          FutureBuilder(
            future: _con.getUsers(),
            builder: (context, AsyncSnapshot<List<User>?> snapshot) {
              if (snapshot.hasData) {
                final List<User> users = snapshot.data!;
                if (users.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final User user = users[index];
                        return Dismissible(
                            background: Container(
                              color: Colors.red,
                            ),
                            key: UniqueKey(),
                            child: ListTile(
                              title: Text(user.correo!),
                              subtitle: Text(user.nombre!),
                              onTap: () {
                                //TODO: IMPLEMENTAR EL ACTUALIZAR CON DATOS DEL USUARIO

                                // ignore: avoid_print
                                print("USUARIO ${user.id}");
                              },
                            ));
                      },
                    ),
                  );
                } else {
                  return const NoDataWidget(
                    text: "No usuarios",
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
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
