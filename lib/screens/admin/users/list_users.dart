import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/screens/admin/users/list_users_controller.dart';
import 'package:simpplex_app/screens/admin/users/user_details_screen.dart';
import 'package:simpplex_app/utils/my_colors.dart';
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
    final String parameter =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: Column(
        children: [
          Text("USUARIOS REGISTRADOS: ${_con.totalUsers}"),
          FutureBuilder(
            future: parameter == "Usuarios"
                ? _con.getUsers()
                : _con.getUsersDynamic(parameter),
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
                          onDismissed: (_) {
                            _con.deleteUser(user.id!);
                          },
                          key: UniqueKey(),
                          child: ListTile(
                            title: Row(children: [
                              Text("${user.nombre} ${user.apellido}"),
                            ]),
                            subtitle: Text("${user.correo}"),
                            leading: Container(
                              width: 45,
                              height: 45,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: FadeInImage(
                                image: user.image != null
                                    ? NetworkImage(user.image!)
                                    : const AssetImage(
                                            "assets/images/no-avatar.png")
                                        as ImageProvider,
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(seconds: 1),
                                placeholder: const AssetImage(
                                    "assets/images/no-avatar.png"),
                              ),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: MyColors.primaryColor,
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AdminUserDetailsScreen.routeName,
                                  arguments: user);
                              // ignore: avoid_print
                              print("USUARIO ${user.id}");
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const NoDataWidget(
                    text: "No usuarios",
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: MyColors.primaryColor,
                  ),
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
