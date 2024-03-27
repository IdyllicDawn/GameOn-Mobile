import 'package:flutter/material.dart';
import 'main_page.dart';

int _currentIndex = 0;

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
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
            MaterialPageRoute(builder: (context) => GameSelect()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.gamepad),
          label: 'Game',
          //set color of icon based on current index
          backgroundColor: _currentIndex == 0 ? Colors.blue : Colors.grey,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.leaderboard),
          label: 'Leaderboard',
          backgroundColor: _currentIndex == 1 ? Colors.blue : Colors.grey,
        ),
      ],
    );
  }
}