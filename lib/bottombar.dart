import 'package:GameOn/gameselect_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main_page.dart';

int _currentIndex = 0;

class BottomBar extends StatefulWidget {
  final String? loggedInUsername;
  const BottomBar({super.key, required this.loggedInUsername});

  @override
  BottomBarState createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (_currentIndex == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GameSelect(loggedInUsername: widget.loggedInUsername)),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(loggedInUsername: widget.loggedInUsername)),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.gamepad),
              label: 'Game',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.rankingStar),
              label: 'Leaderboard',
            ),
          ],
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
        ),
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width * (_currentIndex / 2),
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: 2,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
