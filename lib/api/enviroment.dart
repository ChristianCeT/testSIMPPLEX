import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simpplex_app/models/models.dart';

class Enviroment {
  static String apiDev = dotenv.get('API_LOCAL_URL');
  static String apiProduction = dotenv.get('API_HOST_URL');
  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: dotenv.get('PUBLIC_KEY_MERCADOPAGO'),
      accessToken: dotenv.get('ACCES_TOKEN_MERCADOPAGO'));
}
