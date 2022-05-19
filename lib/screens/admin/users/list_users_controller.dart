import 'package:flutter/material.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/utils/share_preferences.dart';

class AdminUserListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref sharedPref = SharedPref();
  int totalNumbers = 0;
  List<User>? users = [];
  final UsersProvider _usersProvider = UsersProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.read("user"));
    _usersProvider.init(context, sessionUser: user);
    totalNumbers = (await _usersProvider.getUsers())!.length;
    refresh();
  }

  Future<List<User>?> getUsers() async {
    users = await _usersProvider.getUsers();
    return users;
  }
}
