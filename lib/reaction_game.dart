import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ReactionGame extends StatefulWidget {
  const ReactionGame({Key? key}) : super(key: key);

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
          } else if (_currentColor == Colors.green){
            _endTime = DateTime.now();
            int reactionTime = _endTime!.difference(_startTime!).inMilliseconds;
            setState(() {
              _currentColor = Colors.blue;
              _isActive = false;
              _totalReactionTime += reactionTime;
              _attempts++;
              if (_attempts == 5) {
                _displayText = 'Finished\nYour reaction time: $reactionTime ms\n\nAverage reaction time: ${_totalReactionTime ~/ 5} ms\nClick to play again';
                _attempts = 0;
                _totalReactionTime = 0;
              } else {
                _displayText = 'Attempt ${_attempts}/5:\nYour reaction time: $reactionTime ms\nTap the screen to continue';
              }
            });
          } else {
            setState(() {
              _isActive = false;
              _currentColor = Colors.blue;
              _displayText = 'Too soon!\n Wait for the screen to turn green.\nClick to continue.';
            });
          }
        },
        child: Center(
          child: Text(
            _displayText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24.0, color: Colors.white),
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
}
