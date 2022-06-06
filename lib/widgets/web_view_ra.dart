/* import 'dart:io';
import 'package:simpplex_app/utils/my_colors.dart';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRa extends StatefulWidget {
  const WebViewRa({Key? key}) : super(key: key);

  static String routeName = "/client/products/webar_view";

  @override
  State<WebViewRa> createState() => _WebViewRaState();
}

class _WebViewRaState extends State<WebViewRa> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebViewRa"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: WebView(
        initialUrl: args,
        javascriptMode: JavascriptMode.unrestricted,
        onProgress: (int number) {
          print("onProgress: $number");
        },
      ),
    );
  }
}
 */