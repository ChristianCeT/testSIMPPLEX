import 'package:flutter_driver/driver_extension.dart';
import 'package:client_exhibideas/main.dart' as app;

void main() {
  // Esta línea permite la extensión
  enableFlutterDriverExtension();

  // Llama la función `main()` de nuestra app o llama a `runApp` con cualquier widget
  // en el que estés interesado en realizarle el test.
  app.main();
}
