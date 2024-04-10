import 'dart:convert';

import 'package:GameOn/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';

class ReactionGame extends StatefulWidget {
  final String? loggedInUsername;

  const ReactionGame({super.key, this.loggedInUsername});

  @override
  ReactionGameState createState() => ReactionGameState();
}

class ReactionGameState extends State<ReactionGame> {
  Color _currentColor = Colors.blue;
  DateTime? _startTime;
  DateTime? _endTime;
  final Random _random = Random();
  int _attempts = 0;
  int _totalReactionTime = 0;
  bool _isActive = false;
  String _displayText = 'Tap the screen to start';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentColor,
      body: InkWell(
        onTap: () {
          if (!_isActive && _currentColor == Colors.blue) {
            _startTimer();
          } else if (_currentColor == Colors.green) {
            _endTime = DateTime.now();
            int reactionTime = _endTime!.difference(_startTime!).inMilliseconds;
            setState(() {
              _currentColor = Colors.blue;
              _isActive = false;
              _totalReactionTime += reactionTime;
              _attempts++;
              if (_attempts == 5) {
                _displayText =
                    'Finished\nYour reaction time: $reactionTime ms\n\nAverage reaction time: ${_totalReactionTime ~/ 5} ms\nClick to play again';
                if (widget.loggedInUsername != null) {
                  sendReactionScore(
                      widget.loggedInUsername, _totalReactionTime ~/ 5);
                }
                _attempts = 0;
                _totalReactionTime = 0;
              } else {
                _displayText =
                    'Attempt $_attempts/5:\nYour reaction time: $reactionTime ms\nTap the screen to continue';
              }
            });
          } else {
            setState(() {
              _isActive = false;
              _currentColor = Colors.blue;
              _displayText =
                  'Too soon!\n Wait for the screen to turn green.\nClick to continue.';
            });
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _displayText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24.0, color: Colors.white),
              ),
              if (_displayText.contains('Finished'))
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                              loggedInUsername: widget.loggedInUsername)),
                    );
                  },
                  child: const Text('Go to leaderboard'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    setState(() {
      _displayText = 'Wait for the green screen to appear...';
      _currentColor = Colors.red;
      _isActive = true;
    });
    Future.delayed(Duration(milliseconds: _random.nextInt(5000) + 1000), () {
      if (mounted && _isActive) {
        setState(() {
          _currentColor = Colors.green;
          _displayText = 'Tap!';
          _isActive = true;
          _startTime = DateTime.now();
        });
      }
    });
  }

  Future<void> sendReactionScore(String? username, int time) async {
    final url = Uri.parse(
        'https://group8large-57cfa8808431.herokuapp.com/api/addReactionData');
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'time': time,
        'date': DateFormat('MM-dd-yyyy').format(DateTime.now()).toString(),
        'device': 'Phone'
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("Success");
    }
  }
}
