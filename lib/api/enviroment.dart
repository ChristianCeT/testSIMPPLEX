import 'package:simpplex_app/models/mercado_pago/mercado_pago_credentials.dart';

class Enviroment {
  static const String apiDev = "192.168.1.7:3006";
  static const String API_DELIVERY = "exhibideas-flutter-v1.herokuapp.com";
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'TEST-f12c2b6b-6121-4949-a885-b90802152ebb',
      accessToken:
          'TEST-2010426941624597-120421-a6c97c99ae74d675dd7aa2c00e6482d3-1006781084');
}
