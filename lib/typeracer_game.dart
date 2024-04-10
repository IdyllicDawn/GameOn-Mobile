// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'typeracer_score.dart';

class TypingTestScreen extends StatefulWidget {
  final String? loggedInUsername;

  const TypingTestScreen({super.key, this.loggedInUsername});

  @override
  _TypingTestScreenState createState() => _TypingTestScreenState();
}

class _TypingTestScreenState extends State<TypingTestScreen> {
  WebViewController? _webViewController;
  String message = "";

  @override
  void initState() {
    // WebView controller initialization and setup
    _webViewController = WebViewController()
      ..loadFlutterAsset("assets/web/typingTest.html")
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..runJavaScript('document.querySelector("input").focus();')
      ..addJavaScriptChannel(
        "messageHandler",
        onMessageReceived: (JavaScriptMessage javaScriptMessage) {
          message = javaScriptMessage.message;
          print("Message from the web view=\"${message}\"");
          //if the message is WhatUsername, pass the username to the HTML
          //if logged in username is not null, pass it to the HTML
          if (message == "WhatUsername?" && widget.loggedInUsername != null) {
            print("Passing username to HTML");
            passUsernameToHTML();
          }
          print("checking for score");
          if (message.contains("SCORE:")) {
            print("i got the score${message}\"");
            //data example SCORE:27 WPM:14.80 ACCURACY:61.16"
            List<String> data = javaScriptMessage.message.split(" ");
            double score = double.parse(data[0].split(":")[1]);
            double wpm = double.parse(data[1].split(":")[1]);
            double accuracy = double.parse(data[2].split(":")[1]);
            print("score: $score, wpm: $wpm, accuracy: $accuracy");
            //switch to the TypingScoreScreen with the score data
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TypingScoreScreen(
                  loggedInUsername: widget.loggedInUsername,
                  score: score.toInt(),
                  wpm: wpm.toDouble(),
                  accuracy: accuracy.toDouble(),
                ),
              ),
            );
          }
        },
      );
    super.initState();
  }

  Widget buildWebView() {
    return WebViewWidget(
      controller: _webViewController!,
    );
  }

  void passUsernameToHTML() {
    _webViewController?.runJavaScript(
        'receiveMessageFromFlutter("${widget.loggedInUsername}");');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typing Test"),
      ),
      body: Column(
        children: [
          Expanded(child: buildWebView()),
        ],
      ),
    );
  }
}
