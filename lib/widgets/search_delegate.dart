import 'package:flutter/material.dart';
import 'package:simpplex_app/models/user.dart';
import 'package:simpplex_app/screens/admin/users/user_details_screen.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';

class SearchDelegateUsers extends SearchDelegate {
  List<User> users;
  final String dataParameter;
  List<User> _filter = [];

  @override
  String get searchFieldLabel => "Buscar usuario";

  SearchDelegateUsers({required this.users, required this.dataParameter});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close, color: MyColors.primaryColor),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_outlined, color: MyColors.primaryColor),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        itemCount: _filter.length,
        itemBuilder: (_, index) {
          return _filter.isNotEmpty
              ? _UserItem(user: _filter[index], parameterSuggest: dataParameter)
              : const NoDataWidget(
                  text: "No hay usuarios :(",
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = users
        .where((usuario) => "${usuario.nombre} ${usuario.apellido}"
            .toLowerCase()
            .contains(query.trim().toLowerCase()))
        .toList();

    return ListView.builder(
        itemCount: _filter.length,
        itemBuilder: (_, index) {
          return _filter.isNotEmpty
              ? _UserItem(user: _filter[index], parameterSuggest: dataParameter)
              : const NoDataWidget(
                  text: "No hay usuarios :(",
                );
        });
  }
}

class _UserItem extends StatelessWidget {
  final User user;
  final String parameterSuggest;
  const _UserItem(
      {Key? key, required this.user, required this.parameterSuggest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    user.id = 'search-${user.id}';

    return ListTile(
      leading: Hero(
        tag: user.id!,
        child: Container(
          width: 45,
          height: 45,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: FadeInImage(
            placeholder: const AssetImage('assets/images/noImagen.png'),
            image: user.image != null
                ? NetworkImage(user.image!)
                : const AssetImage('assets/images/noImagen.png')
                    as ImageProvider,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text("${user.nombre}"),
      subtitle: Text("${user.correo}"),
      onTap: () {
        Navigator.pushReplacementNamed(
            context, AdminUserDetailsScreen.routeName,
            arguments: [user, parameterSuggest]);
      },
    );
  }
}
