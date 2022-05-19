import 'package:simpplex_app/models/response_api.dart';
import 'package:simpplex_app/provider/user_provider.dart';
import 'package:simpplex_app/screens/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /* test("GetErrorLogin", () async {
    UsersProvider usersProvider = UsersProvider();

    String email = "chris@hotmail.com";
    String password = "1234";

    Future<ResponseApi?> futureLogin = usersProvider.login(email, password);

    //return future;
    ResponseApi? responseApi = await futureLogin;

    //return user
    expect(responseApi?.success, true);
    expect(responseApi?.message, "Logeo con éxito");
  }); */

  testWidgets("ValidationInput", (tester) async {
    final fieldPassword = find.byKey(const ValueKey("password"));
    final addButton = find.byKey(const ValueKey("buttonRegister"));

    await tester.pumpWidget(const MaterialApp(
      home: RegisterPage(),
    ));

    await tester.enterText(fieldPassword, "1234");
    await tester.tap(addButton);
    await tester.pump();

    expect(find.text("1234"), findsOneWidget);
  });

  testWidgets("ValidationInputUser", (tester) async {
    final fieldPassword = find.byKey(const ValueKey("textFieldName"));
    final addButton = find.byKey(const ValueKey("buttonRegister"));

    await tester.pumpWidget(const MaterialApp(
      home: RegisterPage(),
    ));

    await tester.enterText(fieldPassword, "luis");
    await tester.tap(addButton);
    await tester.pump();

    expect(find.text("luis"), findsOneWidget);
  });
}
