import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: const Color.fromARGB(255, 87, 179, 255),
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
          const Expanded(
            child: Leaderboard(),
          ),
        ],
      ),
    );
  }
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LeaderboardEntry> leaderboardScores = [
      LeaderboardEntry(rank: 5, name: 'You', device: 'Your Device', score: 50),
      LeaderboardEntry(rank: 1, name: 'User1', device: 'Device1', score: 90),
      LeaderboardEntry(rank: 2, name: 'User2', device: 'Device2', score: 80),
      LeaderboardEntry(rank: 3, name: 'User3', device: 'Device3', score: 70),
      LeaderboardEntry(rank: 4, name: 'User4', device: 'Device4', score: 60),
    ];

    return SingleChildScrollView(
      child: Center(
        child: DataTable(
          border: TableBorder.symmetric(
            outside: const BorderSide(color: Colors.black, width: 1.0),
          ),
          dataRowMinHeight: 40,
          headingRowHeight: 60,
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
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                    : backgroundColor;
              }),
              cells: [
                DataCell(Text(leaderboard.rank.toString())),
                DataCell(Text(
                  leaderboard.name,
                  style: TextStyle(
                    color: leaderboard.name == 'You' ? Colors.blue : Colors.black,
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