import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureEvidenceScreen extends StatelessWidget {
  const SignatureEvidenceScreen({Key? key}) : super(key: key);

  static String routeName = "/delivery/signature";

  @override
  Widget build(BuildContext context) {
    final SignatureController _controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      exportPenColor: Colors.black,
      onDrawStart: () => print('onDrawStart called!'),
      onDrawEnd: () => print('onDrawEnd called!'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Evidencias"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Ingrese la firma"),
            Signature(
              controller: _controller,
              height: 250,
              width: 300,
              backgroundColor: Colors.grey[200]!,
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //SHOW EXPORTED IMAGE IN NEW ROUTE
                  IconButton(
                    icon: const Icon(Icons.check),
                    color: Colors.blue,
                    onPressed: () async {
                      if (_controller.isNotEmpty) {
                        final Uint8List? data = await _controller.toPngBytes();
                        if (data != null) {
                          await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                                return Scaffold(
                                  appBar: AppBar(),
                                  body: Center(
                                    child: Container(
                                      color: Colors.grey[300],
                                      child: Image.memory(data),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.undo),
                    color: Colors.blue,
                    onPressed: () {
                      _controller.undo();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo),
                    color: Colors.blue,
                    onPressed: () {
                      _controller.redo();
                    },
                  ),
                  //CLEAR CANVAS
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.blue,
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
