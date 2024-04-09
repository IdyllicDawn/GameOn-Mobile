import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TypingTestScreen extends StatelessWidget {
  final String? loggedInUsername;

  const TypingTestScreen({super.key, required this.loggedInUsername});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadFlutterAsset('assets/web/typingTest.html');

    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeRacer'),
      ),
      body: GestureDetector(
        onTap: () {
          controller.runJavaScript(
              'var inputElement = document.getElementById("user-input");inputElement.focus();');
          //set username to LoggedInUsername using javascript updateUsername('CoolName?');
          controller.runJavaScript('updateUsername("$loggedInUsername");');
        },
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
