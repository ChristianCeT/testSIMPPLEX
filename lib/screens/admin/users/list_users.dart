import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/screens/admin/users/list_users_controller.dart';
import 'package:simpplex_app/screens/admin/users/menu_users/menu_users_screen.dart';
import 'package:simpplex_app/screens/admin/users/user_details_screen.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';
import 'package:simpplex_app/widgets/search_delegate.dart';

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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
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
        actions: [
          IconButton(
            onPressed: () => showSearch(
                context: context,
                delegate: SearchDelegateUsers(
                    users: _con.users!, dataParameter: parameter)),
            icon: const Icon(Icons.search_outlined),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, MenuUsersScreen.routeName, (route) => false);
          },
        ),
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

                        return Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              const Spacer(),
                              SlidableAction(
                                flex: 1,
                                onPressed: (_) {
                                  _con.deleteUser(user.id!);
                                  setState(() {
                                    users.removeAt(index);
                                  });
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
                                _con.deleteUser(user.id!);
                                setState(() {
                                  users.removeAt(index);
                                });
                              },
                            ),
                          ),
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
                              Navigator.pushReplacementNamed(
                                  context, AdminUserDetailsScreen.routeName,
                                  arguments: [user, parameter]);
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
