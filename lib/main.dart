// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const GameOn());
}

class GameOn extends StatelessWidget {
  const GameOn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameOn!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

