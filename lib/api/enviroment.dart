import 'package:simpplex_app/models/mercado_pago/mercado_pago_credentials.dart';

class Enviroment {
  static const String apiDev = "192.168.1.64:3006";
  static const String API_DELIVERY = "exhibideas-flutter-v1.herokuapp.com";
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'APP_USR-758b210e-6663-4650-b0b0-c84d05eb0d30',
      accessToken:
          'APP_USR-2010426941624597-120421-4f7925daff5e1e0ffa736b91062078ec-1006781084');
}
