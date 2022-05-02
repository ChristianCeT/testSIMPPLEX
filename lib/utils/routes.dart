import 'package:client_exhibideas/screens/Login/login_page.dart';
import 'package:client_exhibideas/screens/admin/categories/create/admin_categories_create_page.dart';
import 'package:client_exhibideas/screens/admin/orders/list/admin_orders_list_page.dart';
import 'package:client_exhibideas/screens/admin/products/create/admin_products_create_page.dart';
import 'package:client_exhibideas/screens/client/Account/client_account_page.dart';
import 'package:client_exhibideas/screens/client/address/create/client_address_create_page.dart';
import 'package:client_exhibideas/screens/client/address/list/client_address_list_page.dart';
import 'package:client_exhibideas/screens/client/address/map/client_address_map_page.dart';
import 'package:client_exhibideas/screens/client/orders/create/client_orders_create_page.dart';
import 'package:client_exhibideas/screens/client/orders/list/client_orders_list_page.dart';
import 'package:client_exhibideas/screens/client/orders/map/client_orders_map_page.dart';
import 'package:client_exhibideas/screens/client/payments/create/client_payments_create_page.dart';
import 'package:client_exhibideas/screens/client/payments/installments/client_payments_installments_page.dart';
import 'package:client_exhibideas/screens/client/payments/status/client_status_installments_page.dart';
import 'package:client_exhibideas/screens/client/products/client_products_menu/client_products_menu.dart';
import 'package:client_exhibideas/screens/client/products/list/client_products_list_page.dart';
import 'package:client_exhibideas/screens/client/update/client_update_page.dart';
import 'package:client_exhibideas/screens/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:client_exhibideas/screens/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:client_exhibideas/screens/register/register_page.dart';
import 'package:client_exhibideas/screens/roles/roles_page.dart';
import 'package:client_exhibideas/screens/splash/splash_screen.dart';
import 'package:client_exhibideas/widgets/web_view_ra.dart';
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
  AdminCategoriesCreatePage.routeName: (context) => AdminCategoriesCreatePage(),
  AdminOrdersListPage.routeName: (context) => AdminOrdersListPage(),
  AdminProductsCreatePage.routeName: (context) => AdminProductsCreatePage(),
  DeliveryOrdersMapPage.routeName: (context) => DeliveryOrdersMapPage(),
  ClientPaymentsCreatePage.routeName: (context) => ClientPaymentsCreatePage(),
  ClientPaymentsInstallmentsPage.routeName: (context) =>
      ClientPaymentsInstallmentsPage(),
  ClientPaymentsStatusPage.routeName: (context) => ClientPaymentsStatusPage(),
  WebViewRa.routeName: (context) => const WebViewRa(),
};
