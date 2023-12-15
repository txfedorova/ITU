import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/controller/user_controller.dart';
import 'package:itu_app/model/db_helper.dart';
import 'package:itu_app/model/film_model.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: ListView(
        // Wrap with ListView
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'The best match is:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                BestMatchCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BestMatchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Film?>(
      future: getBestMatchFilm(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No user films available.');
        }

        final bestMatchFilm = snapshot.data!;
        // Additional logic here...

        return bestMatchFilm != null
            ? Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bestMatchFilm.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Add more details as needed (overview, release date, etc.)
                    ],
                  ),
                ),
              )
            : Text('No films with likes found.');
      },
    );
  }

  Future<Film?> getBestMatchFilm(BuildContext context) async {
    final db = await context.read<DatabaseHelper>().database;
    final films = await context.read<FilmController>().films();
    final users =
        await context.read<UserController>().getUsers(); // Await users

    // Calculate the percentage of likes for each film
    final percentageLikes = Map<int, double>();

    for (final film in films) {
      final totalLikes = Sqflite.firstIntValue(await db.rawQuery('''
        SELECT COUNT(*) FROM user_films
        WHERE film_id = ? AND choice = 1
      ''', [film.id])) ?? 0;

      final totalDislikes = Sqflite.firstIntValue(await db.rawQuery('''
        SELECT COUNT(*) FROM user_films
        WHERE film_id = ? AND choice = 0
      ''', [film.id])) ?? 0;

      final totalUsers = users.length;

      final totalVotes = totalLikes + totalDislikes;
      final percentage = totalVotes > 0 ? totalLikes / totalVotes * 100.0 : 0.0;

      percentageLikes[film.id!] = percentage;
    }

    // Find the film with the highest percentage of likes
    final bestMatchFilmId =
        percentageLikes.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Retrieve the best match film or return null if no match
    final bestMatchFilm = films.firstWhere((film) => film.id == bestMatchFilmId
        //orElse: () => null,
        );

    return bestMatchFilm;
  }
}
