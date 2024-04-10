// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:GameOn/main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'typeracer_game.dart';

class TypingScoreScreen extends StatefulWidget {
  final String? loggedInUsername;
  final int? score;
  final double? wpm;
  final double? accuracy;

  const TypingScoreScreen(
      {super.key, this.loggedInUsername, this.score, this.wpm, this.accuracy});

  @override
  TypingScoreState createState() => TypingScoreState();
}

class TypingScoreState extends State<TypingScoreScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.loggedInUsername != null) {
      sendTypingScore(
          widget.loggedInUsername, widget.score, widget.wpm!.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Typing Test Score"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Score: ${widget.score.toString()}"),
            Text("WPM: ${widget.wpm}"),
            Text("Accuracy: ${widget.accuracy}"),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TypingTestScreen(
                      loggedInUsername: widget.loggedInUsername,
                    ),
                  ),
                );
              },
              child: const Text("Play Again"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      loggedInUsername: widget.loggedInUsername,
                    ),
                  ),
                );
              },
              child: const Text("Leaderboard"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendTypingScore(String? username, int? score, int? speed) async {
    final url = Uri.parse(
        'https://group8large-57cfa8808431.herokuapp.com/api/addTypingData');
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'score': score,
        'speed': speed,
        'date': DateTime.now().toString(),
        'device': 'Phone'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("Success");
    }
  }
}
