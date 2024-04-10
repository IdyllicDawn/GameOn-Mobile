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
          print("Message from the web view=\"${javaScriptMessage.message}\"");
          //if the message is WhatUsername, pass the username to the HTML
          //if logged in username is not null, pass it to the HTML
          if (javaScriptMessage.message == "WhatUsername?" &&
              widget.loggedInUsername != null) {
            passUsernameToHTML();
          } else {
            setState(() {
              message = javaScriptMessage.message;
            });
            //if the message containes "score" parse the data into respective variables
            //example message :"Score,WPM,Accuracy: score,wpm,accuracy"
            if (message.contains("Score,WPM,Accuracy:")) {
              print("Score received");
              List<String> scoreData = message.split(":")[1].split(",");
              int score = int.parse(scoreData[0]);
              print("Score: $score");
              double wpm = double.parse(scoreData[1]);
              print("WPM: $wpm");
              double accuracy = double.parse(scoreData[2]);
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
