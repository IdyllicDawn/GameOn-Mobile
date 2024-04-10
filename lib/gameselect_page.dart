import 'package:GameOn/login_page.dart';
import 'package:flutter/material.dart';
import 'bottombar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'typeracer_game.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:flutter/src/painting/gradient.dart' as flutter;
import 'package:GameOn/reaction_game.dart';

class GameSelect extends StatelessWidget {
  final String? loggedInUsername;

  const GameSelect({super.key, required this.loggedInUsername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gam  e Select', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Select a Game',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: 400,
                enableInfiniteScroll: true,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: [
                'images/ReactionSpeedIcon.png',
                'images/TypingGameIcon.png',
              ].map((String imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    Widget gameScreen =
                        TypingTestScreen(loggedInUsername: loggedInUsername);
                    String gameName = '';
                    String gameDescription = '';
                    String gamePreviewGifUrl = '';
                    if (imageUrl == 'images/ReactionSpeedIcon.png') {
                      gameName = 'Reaction Speed Test';
                      gameDescription =
                          'A green screen will appear. When it turns red, click the screen as fast as you can!';
                      gamePreviewGifUrl = 'images/ReactionGame.gif';
                      gameScreen =
                          ReactionGame(loggedInUsername: loggedInUsername);
                    } else if (imageUrl == 'images/TypingGameIcon.png') {
                      gameName = 'Typing Speed Test';
                      gameDescription =
                          'A random paragraph will appear on the screen. Type the words while trying to be as fast and accurate as possible!';
                      gamePreviewGifUrl = 'images/TypingGame.gif';
                      gameScreen =
                          TypingTestScreen(loggedInUsername: loggedInUsername);
                    }

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return GiffyDialog.image(
                              Image.asset(gamePreviewGifUrl,
                                  fit: BoxFit.cover, height: 200),
                              title:
                                  Text(gameName, textAlign: TextAlign.center),
                              content: Text(
                                gameDescription,
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => gameScreen),
                                  ),
                                  child: const Text('Play'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Center(
                                child: Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: flutter.LinearGradient(
                                    colors: [
                                      Color.fromARGB(125, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                                child: Text(
                                  gameName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(loggedInUsername: loggedInUsername),
    );
  }
}
