import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TypingTestScreen extends StatefulWidget {
  const TypingTestScreen({super.key});

  @override
  State<TypingTestScreen> createState() => _TypingTestScreenState();
}

class _TypingTestScreenState extends State<TypingTestScreen> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..enableZoom(false)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadFlutterAsset('assets/web/typingTest.html');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeRacer'),
      ),
      body: GestureDetector(
        onTap: () {
          controller.runJavaScript('focusHiddenInput();');
        },
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
