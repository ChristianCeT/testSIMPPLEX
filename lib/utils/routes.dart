import 'package:simpplex_app/screens/Login/login_page.dart';
import 'package:simpplex_app/screens/admin/categories/create_update/admin_categories_create_page.dart';
import 'package:simpplex_app/screens/admin/categories/list_categories/list_categories.dart';
import 'package:simpplex_app/screens/admin/orders/list/admin_orders_list_page.dart';
import 'package:simpplex_app/screens/admin/products/create/admin_products_create_page.dart';
import 'package:simpplex_app/screens/admin/products/list_products/list_products.dart';
import 'package:simpplex_app/screens/admin/products/list_products_category.dart/list_products_category.dart';
import 'package:simpplex_app/screens/admin/users/list_users.dart';
import 'package:simpplex_app/screens/admin/users/menu_users/menu_users_screen.dart';
import 'package:simpplex_app/screens/admin/users/user_details_screen.dart';
import 'package:simpplex_app/screens/client/Account/client_account_page.dart';
import 'package:simpplex_app/screens/client/address/create/client_address_create_page.dart';
import 'package:simpplex_app/screens/client/address/list/client_address_list_page.dart';
import 'package:simpplex_app/screens/client/address/map/client_address_map_page.dart';
import 'package:simpplex_app/screens/client/orders/create/client_orders_create_page.dart';
import 'package:simpplex_app/screens/client/orders/list/client_orders_list_page.dart';
import 'package:simpplex_app/screens/client/orders/map/client_orders_map_page.dart';
import 'package:simpplex_app/screens/client/payments/create/client_payments_create_page.dart';
import 'package:simpplex_app/screens/client/payments/installments/client_payments_installments_page.dart';
import 'package:simpplex_app/screens/client/payments/status/client_status_installments_page.dart';
import 'package:simpplex_app/screens/client/products/client_products_menu/client_products_menu.dart';
import 'package:simpplex_app/screens/client/products/list/client_products_list_page.dart';
import 'package:simpplex_app/screens/client/update/client_update_page.dart';
import 'package:simpplex_app/screens/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:simpplex_app/screens/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:simpplex_app/screens/register/register_page.dart';
import 'package:simpplex_app/screens/roles/roles_page.dart';
import 'package:simpplex_app/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

// Rutas
final Map<String, WidgetBuilder> routes = {
  SplashScreen1.routeName: (context) => SplashScreen1(),
  LoginPage.routeName: (context) => LoginPage(),
  RegisterPage.routeName: (context) => RegisterPage(),
  ClientProductsListPage.routeName: (context) => ClientProductsListPage(),
  DeliveryOrdersListPage.routeName: (context) => DeliveryOrdersListPage(),
  RolesPage.routeName: (context) => RolesPage(),
  ClienteProductsMenu.routeName: (context) => ClienteProductsMenu(),
  ClientOrderCreatePage.routeName: (context) => ClientOrderCreatePage(),
  ClientUpdatePage.routeName: (context) => ClientUpdatePage(),
  ClientAcountPage.routeName: (context) => ClientAcountPage(),
  ClientAddressCreatePage.routeName: (context) => ClientAddressCreatePage(),
  ClientAddressListPage.routeName: (context) => ClientAddressListPage(),
  ClientAddressMapPage.routeName: (context) => ClientAddressMapPage(),
  ClientOrdersMapPage.routeName: (context) => ClientOrdersMapPage(),
  ClientOrdersListPage.routeName: (context) => ClientOrdersListPage(),
  AdminCategoriesCreateUpdatePage.routeName: (context) => const AdminCategoriesCreateUpdatePage(),
  AdminOrdersListPage.routeName: (context) => AdminOrdersListPage(),
  AdminProductsCreatePage.routeName: (context) => AdminProductsCreatePage(),
  DeliveryOrdersMapPage.routeName: (context) => DeliveryOrdersMapPage(),
  ClientPaymentsCreatePage.routeName: (context) => ClientPaymentsCreatePage(),
  ClientPaymentsInstallmentsPage.routeName: (context) =>
      const ClientPaymentsInstallmentsPage(),
  ClientPaymentsStatusPage.routeName: (context) =>
      const ClientPaymentsStatusPage(),
  UserScreen.routeName: (context) => const UserScreen(),
  MenuUsersScreen.routeName: (context) => const MenuUsersScreen(),
  AdminUserDetailsScreen.routeName: (context) => const AdminUserDetailsScreen(),
  CategoriesScreen.routeName: (context) => const CategoriesScreen(),
  ListProductsScreen.routeName: (context) => const ListProductsScreen(),
  ListProductByCategoryScreen.routeName: (context) => const ListProductByCategoryScreen(),
};
