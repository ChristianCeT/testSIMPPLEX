import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/screens/admin/categories/create_update/admin_categories_create_page.dart';
import 'package:simpplex_app/screens/admin/categories/list_categories/list_categories_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);
  static String routeName = "/admin/categories/list";

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ListCategoriesController _con = ListCategoriesController();

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
        title: const Text("Categories"),
      ),
      body: FutureBuilder(
        future: _con.getCategories(),
        builder: (context, AsyncSnapshot<List<Category>?> snapshot) {
          if (snapshot.hasData) {
            final List<Category> categories = snapshot.data!;
            if (categories.isNotEmpty) {
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final Category category = categories[index];
                  return Dismissible(
                    onDismissed: (_) {
                      _con.deleteUser(category.id!);
                    },
                    key: UniqueKey(),
                    child: ListTile(
                      title: Text("${category.nombre}"),
                      subtitle: Text("${category.descripcion}"),
                      leading: Icon(
                        Icons.category_outlined,
                        color: MyColors.primaryColor,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: MyColors.primaryColor,
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, AdminCategoriesCreateUpdatePage.routeName,
                            arguments: ["editar", category]);
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ),
              );
            }
          } else {
            return const NoDataWidget(
              text: "No hay categorías",
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
              context, AdminCategoriesCreateUpdatePage.routeName,
              arguments: [
                "agregar", null,
              ]);
        },
        backgroundColor: MyColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
