import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TypingTestScreen extends StatefulWidget {
  const TypingTestScreen({super.key});

  @override
  State<TypingTestScreen> createState() => _TypingTestScreenState();
}

class _TypingTestScreenState extends State<TypingTestScreen> {
  final bool autofocus = true;
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadFlutterAsset('assets/web/typingTest.html')
    ..runJavaScript('document.getElementById("input").focus();');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TypeRacer'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
