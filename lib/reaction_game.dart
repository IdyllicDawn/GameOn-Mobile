import 'package:flutter/material.dart';

class ReactionGame extends StatefulWidget {
  const ReactionGame({super.key});

  @override
  ReactionGameState createState() => ReactionGameState();
}

class ReactionGameState extends State<ReactionGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction Game'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Reaction Game!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}