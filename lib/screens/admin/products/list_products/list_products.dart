import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/app.dart';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/screens/admin/products/list_products/list_products_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';

class ListProductsScreen extends StatefulWidget {
  const ListProductsScreen({Key? key}) : super(key: key);

  static String routeName = '/admin/list_products';

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  final ListProductsController _con = ListProductsController();

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
        title: const Text("Listado de productos"),
      ),
      body: FutureBuilder(
        future: _con.getCategories(),
        builder: (context, AsyncSnapshot<List<Category>?> snapshot) {
          if (snapshot.hasData) {
            final List<Category> categories = snapshot.data!;
            if (categories.isNotEmpty) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: MyColors.primaryColor,
                ),
              );
            }
          } else {
            return const NoDataWidget(
              text: "No hay categorías de productos",
            );
          }
        },
      ),
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
