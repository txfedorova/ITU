import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/controller/user_controller.dart';
import 'package:itu_app/model/db_helper.dart';
import 'package:itu_app/model/film_model.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: const Color.fromARGB(255, 68, 70, 115),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'The best match is:',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BestMatchCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class BestMatchCard extends StatelessWidget {
  double _percentageLikes = 0.0;

  BestMatchCard({super.key}); // Local variable to store the percentage

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Film?>(
      future: getBestMatchFilm(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No user films available.');
        }

        final bestMatchFilm = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Text(
              'Percentage of Likes: ${_percentageLikes.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                int filmId = bestMatchFilm.id!;
                // Open the comments screen for the selected film
                context.push('/listFilms/$filmId/comments');
              },
              child: SizedBox(
                height: 490, // Adjust the height as needed
                width: 300, // Adjust the width as needed
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bestMatchFilm.posterPath != "<No poster>"
                          ? Container(
                              height: 400, // Adjust the height as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: Image.file(
                                    File(bestMatchFilm.posterPath),
                                  ).image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 200, // Adjust the height as needed
                              child: Center(
                                child: Text("<No poster>"),
                              ),
                            ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          bestMatchFilm.title,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Overview: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: bestMatchFilm.overview,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Release date: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: bestMatchFilm.releaseDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Actors: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: bestMatchFilm.actors,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Director: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: bestMatchFilm.director,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Duration: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: bestMatchFilm.duration,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Film?> getBestMatchFilm(BuildContext context) async {
    final db = await context.read<DatabaseHelper>().database;
    final films = await context.read<FilmController>().films();
    final users =
        await context.read<UserController>().getUsers(); // Await users

    // Calculate the percentage of likes for each film
    final percentageLikes = <int, double>{};

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
    final bestMatchFilm = films.firstWhere(
      (film) => film.id == bestMatchFilmId,
      //orElse: () => null,
    );

    // Store the percentage of likes in the local variable
    _percentageLikes = percentageLikes[bestMatchFilmId] ?? 0.0;

    return bestMatchFilm;
  }
}
