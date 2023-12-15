import 'package:flutter/material.dart';

import 'package:itu_app/model/film_model.dart';
import 'package:itu_app/controller/film_controller.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';

// https://stackoverflow.com/questions/38933801/calling-an-async-method-from-a-constructor-in-dart
class _FilmQueryResults {
  // Key and token copied from my TMDB profile
  final String apiKey = 'c1e3556e0182098dbaff3210c89a584e';
  final String readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMWUzNTU2ZTAxODIwOThkYmFmZjMyMTBjODlhNTg0ZSIsInN1YiI6IjY1NjYxYzAwODlkOTdmMDBlMTcyZmUyMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Rk1-fBcVDmw5XDQ6ww7LHKkgidnmBMhPqiM6SZvZWO0';

  final int maxResults = 10;

  List<Film> films = [];

  late TMDB tmdb;

  _FilmQueryResults._create(String movieTitle) {
    tmdb = TMDB(
      ApiKeys(apiKey, readAccessToken),
      logConfig: const ConfigLogger.showAll(),
      //defaultLanguage:'en-US'
    );
  }

  /// Public factory
  static Future<_FilmQueryResults> create(String movieTitle) async {
    print("create() (public factory)");

    // Call the private constructor
    var fqr = _FilmQueryResults._create(movieTitle);

    // Do initialization that requires async
    String query = Uri.encodeComponent(movieTitle);
    Map response =
        await fqr.tmdb.v3.search.queryMovies(query, includeAdult: true);

    // Check movieTitle format (not empty, not only spaces, cannot contain only numbers)
    if (movieTitle.isEmpty || movieTitle.trim().isEmpty) {
      print('******Empty movie title');
      return fqr;
    }

    if (response['results'] == null || response['results'].isEmpty) {
      print("******No results");
      return fqr;
    }

    // Filter out null results
    List<Map<String, dynamic>> validResults = response['results']
        .where((result) => result != null)
        .cast<Map<String, dynamic>>()
        .toList();

    // Case-insensitive comparison
    String lowerCaseTitle = movieTitle.toLowerCase();

    // Limit the number of results
    if (validResults.length > fqr.maxResults) {
      validResults.length = fqr.maxResults;
    }

    bool atLeastOneContainsPoster =
        validResults.any((result) => result['poster_path'] != null);

    for (var result in validResults) {
      if (atLeastOneContainsPoster && result['poster_path'] == null) {
        continue;
      }

      Film fqd = Film();

      fqd.title = result['title'];
      fqd.overview = result['overview'];
      fqd.posterPath = result['poster_path'];
      fqd.releaseDate = result['release_date'];

      // Fetch year, duration, director, and actors
      await fqr.tmdb.v3.movies.getCredits(result['id']).then((credits) {
        int maxActors = 3;
        String actors = "";
        int actorCount = 0;

        for (var actor in credits['cast']) {
          actors += "${actor['name']}, ";
          actorCount++;
          if (actorCount >= maxActors) {
            break;
          }
        }

        // Remove the last ", "
        if (actors.isNotEmpty) {
          actors = actors.substring(0, actors.length - 2);
          fqd.actors = actors;
        }

        fqd.director = credits['crew'][0]['name'];
      }).catchError((e) {
        print("Error fetching credits: $e");
      });

      // Fetch details
      await fqr.tmdb.v3.movies.getDetails(result['id']).then((details) {
        if (details != null) {
          fqd.duration = "${details['runtime']} min.";
        } else {
          fqd.duration =
              "N/A"; // Handle the case where details are not available
        }
      }).catchError((e) {
        print("Error fetching details: $e");
      });
      fqr.films.add(fqd);
    }

    // Return the fully initialized object
    return fqr;
  }
}

class FilmQueryScreen extends StatefulWidget {
  const FilmQueryScreen({Key? key}) : super(key: key);
  final String title = "Film Query";

  @override
  State<FilmQueryScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FilmQueryScreen> {
  TextEditingController movieTitleController = TextEditingController();

  // Needs to be a class attribute for setState() to update the widget
  _FilmQueryResults? filmQueryResults;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/TMDB_logo_0.svg',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text('Film Query'))
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: movieTitleController,
              decoration: const InputDecoration(
                labelText: 'Enter movie title',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String movieTitle = movieTitleController.text;
                filmQueryResults = await _FilmQueryResults.create(movieTitle);
                setState(() {
                  // This is needed to update the widget
                  filmQueryResults = filmQueryResults;
                });
              },
              child: const Text('Search'),
            ),
            (() {
              if (filmQueryResults == null) {
                return const SizedBox.shrink();
              } else if (filmQueryResults!.films.isEmpty) {
                return const Text("No films found with such parameters :(");
              } else {
                return _QueryResultsList(filmQueryResults!);
              }
            })()
          ],
        ),
      ),
    );
  }
}

class _QueryResultsList extends StatelessWidget {
  final _FilmQueryResults filmQueryResults;

  _QueryResultsList(this.filmQueryResults, {Key? key}) : super(key: key) {
    print("*****Query results: $filmQueryResults");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: filmQueryResults.films.length,
          itemBuilder: (BuildContext context, int index) {
            return _QueryResult(filmQueryResults.films[index]);
          }),
    );
  }
}

class _QueryResult extends StatelessWidget {
  final Film queriedFilm;
  final double posterHeight = 200;
  final double rowSpace = 10;

  final String tmdbImageBaseUrl = "https://image.tmdb.org/t/p/w500";

  const _QueryResult(this.queriedFilm, {Key? key}) : super(key: key);

  Future<String> downloadPoster() async {
    String url = "${tmdbImageBaseUrl}${queriedFilm.posterPath}";
    final imageName = "${queriedFilm.title}.jpg";

    // Check if the image is already downloaded

    // Get the image name
    // Get the document directory path
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    // This is the saved image path
    final localPath = path.join(appDir.path, imageName);

    // Print out all image paths in documents directory
    final savedImages = appDir.listSync();

    int i = 0;
    for (var image in savedImages) {
      if (image.path.contains(".jpg") || image.path.contains(".png")) {
        print("********Saved image[${i.toString()}]: ${image.path}");
      }
      i++;
    }

    print("********Downloading $url");

    final response = await http.get(Uri.parse(url));

    // Download the image
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);

    return localPath;
  }

  void addFilmToDatabase(FilmController controller) async {
    // Download image from posterPath and save it locally
    String savedPosterLocalPath = await downloadPoster();

    Film film = queriedFilm;
    film.posterPath = savedPosterLocalPath;

    controller.insertFilm(film);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        print("********Tapped on ${queriedFilm.title}"),
        addFilmToDatabase(context.read<FilmController>()),
        context.pop() // Go back to the previous screen
      },
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            queriedFilm.posterPath != "<No poster>"
                ? Container(
                    height: posterHeight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500${queriedFilm.posterPath}"),
                    )))
                : SizedBox(
                    height: posterHeight, child: const Text("<No poster>")),
            const SizedBox(height: 5),
            Text(queriedFilm.title),
            const SizedBox(height: 5),
            Text("Overview: ${queriedFilm.overview}"),
            const SizedBox(height: 5),
            Text("Release date: ${queriedFilm.releaseDate}"),
            const SizedBox(height: 5),
            Text("Actors: ${queriedFilm.actors}"),
            const SizedBox(height: 5),
            Text("Director: ${queriedFilm.director}"),
            const SizedBox(height: 5),
            Text("Duration: ${queriedFilm.duration}"),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
