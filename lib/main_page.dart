import 'package:GameOn/login_page.dart';
import 'package:flutter/material.dart';
import 'bottombar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'typeracer_game.dart'; // Import the TyperacerGame file

class HomePage extends StatelessWidget {
  final String? loggedInUsername;

  HomePage({super.key, required this.loggedInUsername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: const Color.fromARGB(255, 87, 179, 255),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Leaderboard',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: Leaderboard(loggedInUsername: loggedInUsername),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(loggedInUsername: loggedInUsername),
    );
  }
}

class Leaderboard extends StatelessWidget {
  final String? loggedInUsername;

  const Leaderboard({super.key, required this.loggedInUsername});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeaderboardEntry>>(
      future: fetchLeaderboardData(loggedInUsername),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final leaderboardScores = snapshot.data!;
          return SingleChildScrollView(
            child: Center(
              child: DataTable(
                border: TableBorder.symmetric(
                  outside: const BorderSide(color: Colors.black, width: 1.0),
                ),
                dataRowMinHeight: 40,
                headingRowHeight: 60,
                columnSpacing: 30.0,
                headingRowColor: MaterialStateProperty.all(Colors.blue),
                columns: const [
                  DataColumn(
                    label: Text('Rank'),
                  ),
                  DataColumn(
                    label: Text('User'),
                  ),
                  DataColumn(
                    label: Text('Device'),
                  ),
                  DataColumn(
                    label: Text('Score'),
                  ),
                ],
                rows: leaderboardScores.asMap().entries.map((entry) {
                  final index = entry.key;
                  final leaderboard = entry.value;
                  final backgroundColor =
                      index.isEven ? Colors.grey.shade200 : Colors.white;

                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      return states.contains(MaterialState.selected)
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08)
                          : backgroundColor;
                    }),
                    cells: [
                      DataCell(Text(leaderboard.rank.toString())),
                      DataCell(Text(
                        leaderboard.name,
                        style: TextStyle(
                          color: leaderboard.name == 'You'
                              ? Colors.blue
                              : Colors.black,
                        ),
                      )),
                      DataCell(Text(leaderboard.device)),
                      DataCell(Text(leaderboard.score.toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

Future<List<LeaderboardEntry>> fetchLeaderboardData(String? loggedInUsername) async {
  final response = await http.post(Uri.parse('https://group8large-57cfa8808431.herokuapp.com/api/leaderboard'));

  print(response.body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['results'] as List<dynamic>;

    LeaderboardEntry? loggedInUserEntry;
    for (var result in results) {
      final name = result['Username'] ?? '';
      final device = result['Device'] ?? '';
      final score = result['Score'] ?? 0;
      final rank = results.indexOf(result) + 1;

      if (name == loggedInUsername) {
        loggedInUserEntry = LeaderboardEntry(
          rank: rank,
          name: name,
          device: device,
          score: score,
        );
        break;
      }
    }

    if (loggedInUserEntry != null) {
      results.removeWhere((result) => result['Username'] == loggedInUsername);
    }

    final List<LeaderboardEntry> leaderboardEntries = [];
    if (loggedInUserEntry != null) {
      leaderboardEntries.add(loggedInUserEntry);
    }

    leaderboardEntries.addAll(results.map((result) {
      // Check if the rank we remove is lower than the rank of the logged in user to prevent duplicate ranks
      int rank = results.indexOf(result) + 1;
      if (loggedInUserEntry != null && loggedInUserEntry!.rank <= results.indexOf(result) + 1) {
        rank = results.indexOf(result) + 2;
      }
      final name = result['Username'] ?? '';
      final device = result['Device'] ?? '';
      final score = result['Score'] ?? 0;

      return LeaderboardEntry(
        rank: rank,
        name: name,
        device: device,
        score: score,
      );
    }));

    return leaderboardEntries;
  } else {
    throw Exception('Failed to load leaderboard data');
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final String device;
  final int score;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.device,
    required this.score,
  });
}

class TyperacerGame extends StatelessWidget {
  const TyperacerGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Typeracer Game"),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text("Start Typing Test"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TypingTestScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TypingButton extends StatelessWidget {
  const TypingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const TyperacerGame()), // Navigate to the TyperacerGame page
        );
      },
      child: Ink.image(
        image: const NetworkImage(
            'https://w7.pngwing.com/pngs/284/875/png-transparent-racing-flags-typeracer-drapeau-a-damier-flag-miscellaneous-flag-racing-thumbnail.png'),
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}

class GameSelect extends StatelessWidget {
  final String? loggedInUsername;

  const GameSelect({super.key, required this.loggedInUsername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Select'),
        backgroundColor: const Color.fromARGB(255, 87, 179, 255),
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const TypingButton(),
          ])),
      bottomNavigationBar: BottomBar(loggedInUsername: loggedInUsername),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Type Racer'),
      ),
      body: const Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
