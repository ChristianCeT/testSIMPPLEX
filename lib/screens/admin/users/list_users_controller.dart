import 'package:flutter/material.dart';
import 'package:simpplex_app/models/models.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/utils/share_preferences.dart';

class AdminUserListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();
  int? totalUsers = 0;
  List<User>? users = [];
  bool isLoading = true;
  final UsersProvider _usersProvider = UsersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read("user"));
    _usersProvider.init(context, sessionUser: user);
    refresh();
  }

  Future<List<User>?> getUsers() async {
    users = await _usersProvider.getUsers();
    if (totalUsers == 0) {
      totalUsers = users?.length ?? 0;
      refresh();
    }
    if (totalUsers != users?.length) {
      totalUsers = users?.length ?? 0;
      refresh();
    }
    return users;
  }

  Future<List<User>?> getUsersDynamic(String rol) async {
    users = await _usersProvider.getUsersByRolDynamic(rol);
    if (totalUsers == 0) {
      totalUsers = users?.length ?? 0;
      refresh();
    }
    if (totalUsers != users?.length) {
      totalUsers = users?.length ?? 0;
      refresh();
    }
    return users;
  }

  deleteUser(String id) async {
    String? message = await _usersProvider.deleteUserById(id);
    return message;
  }

  countUsers(String rol) async {}
}
