import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simpplex_app/models/category.dart';
import 'package:simpplex_app/models/product.dart';
import 'package:simpplex_app/screens/admin/products/create/admin_products_create_page.dart';
import 'package:simpplex_app/screens/admin/products/list_products_category.dart/list_product_category_controller.dart';
import 'package:simpplex_app/utils/my_colors.dart';
import 'package:simpplex_app/widgets/no_data_widget.dart';

class ListProductByCategoryScreen extends StatefulWidget {
  const ListProductByCategoryScreen({Key? key}) : super(key: key);

  static String routeName = '/admin/list_products_category';

  @override
  State<ListProductByCategoryScreen> createState() =>
      _ListProductByCategoryScreenState();
}

class _ListProductByCategoryScreenState
    extends State<ListProductByCategoryScreen> {
  final ListProductCategoryController _con = ListProductCategoryController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Category category =
        ModalRoute.of(context)?.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      body: FutureBuilder(
        future: _con.getProductsByCategory(category.id!),
        builder: (context, AsyncSnapshot<List<Product>?> snapshot) {
          if (snapshot.hasData) {
            final List<Product> products = snapshot.data!;
            if (products.isNotEmpty) {
              return Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Productos de la categoría: ",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5), fontSize: 18),
                      ),
                      Text(
                        category.nombre!,
                        style: TextStyle(
                            color: MyColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: products.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final Product product = products[index];
                          return Slidable(
                            key: UniqueKey(),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                const Spacer(),
                                SlidableAction(
                                  flex: 1,
                                  onPressed: (_) {
                                    _con.deleteProduct(product.id!);
                                    setState(() {
                                      products.removeAt(index);
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
                                  _con.deleteProduct(product.id!);
                                },
                              ),
                            ),
                            child: ListTile(
                              title: Text(product.nombre!),
                              subtitle: Text(product.descripcion!),
                              trailing: Icon(Icons.keyboard_arrow_right,
                                  color: MyColors.primaryColor),
                              leading: _ProductImageContainer(product: product),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, AdminProductsCreatePage.routeName,
                                    arguments: ["editar", product, category]);
                              },
                            ),
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const NoDataWidget(
                text: "No hay productos",
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
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _ProductImageContainer extends StatelessWidget {
  const _ProductImageContainer({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: FadeInImage(
        image: product.image1 != null
            ? NetworkImage(product.image1!)
            : const AssetImage("assets/images/noImagen.png") as ImageProvider,
        fit: BoxFit.fill,
        fadeInDuration: const Duration(seconds: 1),
        placeholder: const AssetImage("assets/images/noImagen.png"),
      ),
    );
  }
}
