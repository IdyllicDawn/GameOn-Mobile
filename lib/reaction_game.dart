import 'package:flutter/material.dart';

class ReactionGame extends StatefulWidget {
  @override
  ReactionGameState createState() => ReactionGameState();
}

class ReactionGameState extends State<ReactionGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reaction Game'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Reaction Game!',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}