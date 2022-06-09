import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/screens/admin/orders/list/admin_orders_list_page.dart';
import 'package:simpplex_app/screens/admin/products/create/admin_products_create_page.dart';
import 'package:simpplex_app/screens/admin/products/list_products/list_products_controller.dart';
import 'package:simpplex_app/screens/admin/products/list_products_category.dart/list_products_category.dart';
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
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de productos"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () => Navigator.pushNamed(context, AdminOrdersListPage.routeName),
        ),
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
                    childAspectRatio: 0.77,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    return _CardCategory(
                      categoryData: categories[index],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AdminProductsCreatePage.routeName,
              arguments: ["agregar", null, null]);
        },
        child: const Icon(Icons.add),
        backgroundColor: MyColors.primaryColor,
      ),
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _CardCategory extends StatelessWidget {
  final Category categoryData;
  const _CardCategory({
    Key? key,
    required this.categoryData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            Text(categoryData.nombre!,
                style: TextStyle(
                  color: MyColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
            Text(
              categoryData.descripcion!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: MyColors.primaryColor, width: 0.8)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.remove_red_eye_outlined,
                      color: MyColors.primaryColor),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Productos",
                    style:
                        TextStyle(color: MyColors.primaryColor, fontSize: 15),
                  )
                ]),
                onPressed: () {
                  Navigator.pushNamed(
                      context, ListProductByCategoryScreen.routeName,
                      arguments: categoryData);
                },
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              //blur que tanto quiero que se expanda la sombra
              blurRadius: 15,
              //offset sirve para mover la sombra
              offset: const Offset(0, 2),
            )
          ],
        ),
      ),
    );
  }
}
