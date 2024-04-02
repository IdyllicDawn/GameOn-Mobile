import 'package:flutter/material.dart';
import 'main_page.dart';

int _currentIndex = 0;

class BottomBar extends StatefulWidget {
  final String loggedInUsername;
  const BottomBar({super.key, required this.loggedInUsername});

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (_currentIndex == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GameSelect(loggedInUsername: widget.loggedInUsername)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(loggedInUsername: widget.loggedInUsername)),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.gamepad),
          label: 'Game',
          //set color of icon based on current index
          backgroundColor: _currentIndex == 0 ? Colors.blue : Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.leaderboard),
          label: 'Leaderboard',
          backgroundColor: _currentIndex == 1 ? Colors.blue : Colors.grey,
        ),
      ],
    );
  }
}