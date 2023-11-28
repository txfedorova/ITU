import 'package:flutter/material.dart';

import 'package:itu_app/model/film_model.dart';
import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/common/utils.dart';

import 'package:provider/provider.dart';

import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilmQueryScreen extends StatefulWidget {
  const FilmQueryScreen({Key? key}) : super(key: key);
  final String title = "Film Query";

  @override
  State<FilmQueryScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FilmQueryScreen> {
  TextEditingController movieTitleController = TextEditingController();
  Map? movieData;

  // Key and token copied from my Flutter profile
  final String apiKey = 'c1e3556e0182098dbaff3210c89a584e';
  final String readAccessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjMWUzNTU2ZTAxODIwOThkYmFmZjMyMTBjODlhNTg0ZSIsInN1YiI6IjY1NjYxYzAwODlkOTdmMDBlMTcyZmUyMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Rk1-fBcVDmw5XDQ6ww7LHKkgidnmBMhPqiM6SZvZWO0';

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchMovieData() async {
    String movieTitle = movieTitleController.text;
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apiKey, readAccessToken), 
      logConfig: const ConfigLogger.showAll(),
      defaultLanguage:'en-US'
    );
    // URI encoded query
    String query = Uri.encodeComponent(movieTitle);
    Map response = await tmdbWithCustomLogs.v3.search.queryMovies(query);

    setState(() {
      movieData = response;
    });
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
              onPressed: fetchMovieData,
              child: const Text('Search'),
            ),
            movieData == null
              ? const SizedBox(height: 5)
              : _QueryResultsList(movieData!['results']),
          ],
        ),
      ),
    );
  }
}

class _QueryResultsList extends StatelessWidget {
  final List results;
  ScrollController _controller = ScrollController();

  _QueryResultsList(this.results, {Key? key} ) : super(key: key) {
    print("Query results: $results");
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
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          return _QueryResult(results[index]);
        }
      ),
    );
  }
}

class _QueryResult extends StatelessWidget {
  final Map result;
  final double posterHeight = 200;
  final double rowSpace = 10;

  const _QueryResult(this.result, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return InkWell(
      child: SizedBox(
        //width: 200,
        child: Column(
          mainAxisAlignment : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            result['poster_path'] != null ?
              Container(
                height: posterHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500${result['poster_path']}"
                    ),
                    //fit: BoxFit.fill,
                  )
                )
              )
            : SizedBox(height: posterHeight, child: const Text("<No poster>")),
            const SizedBox(height: 5),
            Text(
              result.containsKey('title') ? result['title'] : '<No title>',
            ),
            const SizedBox(height: 5),
            Text(
              "Overview: ${result.containsKey('overview') ? result['overview'] : '<No overview>'}",
            ),
            const SizedBox(height: 5),
            Text(
              "Popularity: ${result.containsKey('popularity') ? result['popularity'].toString() : '<No popularity>'}",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      onTap: () => {
        print("Tapped on ${result['title']}")
      },
    );
  }
}