import 'package:flutter/material.dart';

import 'package:itu_app/model/film_model.dart';
import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/common/utils.dart';

import 'package:provider/provider.dart';

import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter_svg/flutter_svg.dart';


class _FilmQueryData {
  String title = "<No title>";
  String overview = "<No overview>";
  String posterPath = "<No poster>";
  //String popularity = "<No popularity>";
  String actors = "<No actors>";
  String releaseDate = "<No release date>";
  String director = "<No director>";
  String duration = "<No duration>";

  //_FilmQueryData([this.title, this.overview, this.posterPath, this.popularity]);
  _FilmQueryData();
}


// https://stackoverflow.com/questions/38933801/calling-an-async-method-from-a-constructor-in-dart
class _FilmQueryResults {
  // Key and token copied from my TMDB profile
  final String apiKey = 'c1e3556e0182098dbaff3210c89a584e';
  final String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMWUzNTU2ZTAxODIwOThkYmFmZjMyMTBjODlhNTg0ZSIsInN1YiI6IjY1NjYxYzAwODlkOTdmMDBlMTcyZmUyMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Rk1-fBcVDmw5XDQ6ww7LHKkgidnmBMhPqiM6SZvZWO0';

  List<_FilmQueryData> films = [];

  late TMDB tmdb;

  _FilmQueryResults._create(String movieTitle) {
    tmdb = TMDB(
      ApiKeys(apiKey, readAccessToken), 
      logConfig: const ConfigLogger.showAll(),
      defaultLanguage:'en-US'
      
    );
  }

  /// Public factory
  static Future<_FilmQueryResults> create(String movieTitle) async {
    print("create() (public factory)");

    // Call the private constructor
    var fqr = _FilmQueryResults._create(movieTitle);

    // Do initialization that requires async
    String query = Uri.encodeComponent(movieTitle);
    Map response = await fqr.tmdb.v3.search.queryMovies(query, includeAdult: true);

    bool atLeastOneContainsPoster = false;

    for (var result in response['results']) {
      if (result['poster_path'] != null) {
        atLeastOneContainsPoster = true;
        break;
      }
    }


    for (var result in response['results']) {
      if (atLeastOneContainsPoster && result['poster_path'] == null) {
        continue;
      }

      _FilmQueryData fqd = _FilmQueryData();

      fqd.title = result['title'];
      fqd.overview = result['overview'];
      fqd.posterPath = result['poster_path'];
      fqd.releaseDate = result['release_date'];

      // Fetch year, duration, director and actors
      Map credits = await fqr.tmdb.v3.movies.getCredits(result['id']);
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

      // Fetch details
      Map details = await fqr.tmdb.v3.movies.getDetails(result['id']);

      fqd.duration = "${details['runtime']} min.";

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
              padding: const EdgeInsets.all(8.0), child: const Text('Film Query')
            )
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
                setState(() { // This is needed to update the widget
                  filmQueryResults = filmQueryResults;
                });
              },
              child: const Text('Search'),
            ),
            filmQueryResults == null
              ? const SizedBox(height: 5)
              : _QueryResultsList(filmQueryResults!),
          ],
        ),
      ),
    );
  }
}

class _QueryResultsList extends StatelessWidget {
  final _FilmQueryResults filmQueryResults;
  ScrollController _controller = ScrollController();

  _QueryResultsList(this.filmQueryResults, {Key? key} ) : super(key: key) {
    print("Query results: $filmQueryResults");
    _controller = ScrollController();
    _controller.addListener(_scrollListener);//the listener for up and down. 
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
      !_controller.position.outOfRange) {
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
      !_controller.position.outOfRange) {
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // final filmController = Provider.of<FilmController>(context);
    // final films = filmController.films; 

    return Expanded(
      child: ListView.builder(
        itemCount: filmQueryResults.films.length,
        itemBuilder: (BuildContext context, int index) {
          return _QueryResult(filmQueryResults.films[index]);
        }
      ),
    );
  }
}

class _QueryResult extends StatelessWidget {
  final _FilmQueryData filmQueryData;
  final double posterHeight = 200;
  final double rowSpace = 10;

  const _QueryResult(this.filmQueryData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return InkWell(
      onTap: () => {
        //print("Tapped on ${result['title']}")
      },
      child: SizedBox(
        child: Column(
          mainAxisAlignment : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filmQueryData.posterPath != "<No poster>" ?
              Container(
                height: posterHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500${filmQueryData.posterPath}"
                    ),
                    //fit: BoxFit.fill,
                  )
                )
              )
            : SizedBox(height: posterHeight, child: const Text("<No poster>")),
            const SizedBox(height: 5),
            Text(filmQueryData.title),
            const SizedBox(height: 5),
            Text("Overview: ${filmQueryData.overview}"),
            const SizedBox(height: 5),
            Text("Release date: ${filmQueryData.releaseDate}"),
            const SizedBox(height: 5),
            Text("Actors: ${filmQueryData.actors}"),
            const SizedBox(height: 5),
            Text("Director: ${filmQueryData.director}"),
            const SizedBox(height: 5),
            Text("Duration: ${filmQueryData.duration}"),
            const SizedBox(height: 30),
          ],
        ),
      ),
      
    );
  }
}