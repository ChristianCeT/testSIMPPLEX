import 'package:simpplex_app/screens/Login/login_page.dart';
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
import 'package:simpplex_app/screens/delivery/orders/assets_signature_evidence/assets_signature_evidence_screen.dart';
import 'package:simpplex_app/screens/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:simpplex_app/screens/delivery/orders/map/delivery_orders_map_page.dart';
import 'package:simpplex_app/screens/register/register_page.dart';
import 'package:simpplex_app/screens/roles/roles_page.dart';

import 'package:simpplex_app/screens/admin/admin_screens.dart';

import 'package:flutter/material.dart';
import 'package:simpplex_app/screens/splash2.0/splash.dart';

// Rutas
final Map<String, WidgetBuilder> routes = {
  LoginPage.routeName: (context) => const LoginPage(),
  RegisterPage.routeName: (context) => const RegisterPage(),
  ClientProductsListPage.routeName: (context) => const ClientProductsListPage(),
  DeliveryOrdersListPage.routeName: (context) => const DeliveryOrdersListPage(),
  RolesPage.routeName: (context) => const RolesPage(),
  ClienteProductsMenu.routeName: (context) => const ClienteProductsMenu(),
  ClientOrderCreatePage.routeName: (context) => const ClientOrderCreatePage(),
  ClientUpdatePage.routeName: (context) => const ClientUpdatePage(),
  ClientAcountPage.routeName: (context) => const ClientAcountPage(),
  ClientAddressCreatePage.routeName: (context) =>
      const ClientAddressCreatePage(),
  ClientAddressListPage.routeName: (context) => const ClientAddressListPage(),
  ClientAddressMapPage.routeName: (context) => const ClientAddressMapPage(),
  ClientOrdersMapPage.routeName: (context) => const ClientOrdersMapPage(),
  ClientOrdersListPage.routeName: (context) => const ClientOrdersListPage(),
  AdminCategoriesCreateUpdatePage.routeName: (context) =>
      const AdminCategoriesCreateUpdatePage(),
  AdminOrdersListPage.routeName: (context) => const AdminOrdersListPage(),
  AdminProductsCreatePage.routeName: (context) =>
      const AdminProductsCreatePage(),
  DeliveryOrdersMapPage.routeName: (context) => const DeliveryOrdersMapPage(),
  ClientPaymentsCreatePage.routeName: (context) =>
      const ClientPaymentsCreatePage(),
  ClientPaymentsInstallmentsPage.routeName: (context) =>
      const ClientPaymentsInstallmentsPage(),
  ClientPaymentsStatusPage.routeName: (context) =>
      const ClientPaymentsStatusPage(),
  UserScreen.routeName: (context) => const UserScreen(),
  MenuUsersScreen.routeName: (context) => const MenuUsersScreen(),
  AdminUserDetailsScreen.routeName: (context) => const AdminUserDetailsScreen(),
  CategoriesScreen.routeName: (context) => const CategoriesScreen(),
  ListProductsScreen.routeName: (context) => const ListProductsScreen(),
  ListProductByCategoryScreen.routeName: (context) =>
      const ListProductByCategoryScreen(),
  SplashScreenV2.routName: (context) => const SplashScreenV2(),
  SignatureEvidenceScreen.routeName: (context) =>
      const SignatureEvidenceScreen(),
};
