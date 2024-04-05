import 'package:flutter/material.dart';

class AccuracyGame extends StatefulWidget {
  @override
  AccuracyGameState createState() => AccuracyGameState();
}

class AccuracyGameState extends State<AccuracyGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accuracy Game'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Accuracy Game!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}