import 'package:flutter/material.dart';

class AccuracyGame extends StatefulWidget {
  const AccuracyGame({super.key});

  @override
  AccuracyGameState createState() => AccuracyGameState();
}

class AccuracyGameState extends State<AccuracyGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accuracy Game'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Accuracy Game!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}