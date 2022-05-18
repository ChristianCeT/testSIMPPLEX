import 'package:flutter_driver/flutter_driver.dart' as flutterd;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter App', () {
    final buttonSplash = flutterd.find.byValueKey("buttonSplash");
    final inputEmail = flutterd.find.byValueKey('inputEmail');
    final inputPassword = flutterd.find.byValueKey('inputPassword');
    final buttonLogin = flutterd.find.byValueKey('buttonLogin');

    flutterd.FlutterDriver? driver;

    Future<bool> isPresent(flutterd.SerializableFinder byValueKey,
        {Duration timeout = const Duration(seconds: 1)}) async {
      try {
        await driver?.waitFor(byValueKey, timeout: timeout);
        return true;
      } catch (e) {
        return false;
      }
    }

    // Conéctate al driver de Flutter antes de ejecutar cualquier test
    setUpAll(() async {
      driver = await flutterd.FlutterDriver.connect();
    });

    // Cierra la conexión con el driver después de que se hayan completado los tests
    tearDownAll(() async {
      if (driver != null) {
        driver?.close();
      }
    });

    test("Login", () async {
      if (await isPresent(inputEmail)) {
        await driver?.tap(inputEmail);
      }
      await driver?.enterText("chris@hotmail.com");

      await driver?.tap(inputPassword);
      await driver?.enterText("1234");

      await driver?.tap(buttonLogin);
    });
  });
}
