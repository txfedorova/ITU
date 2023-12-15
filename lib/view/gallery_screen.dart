import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:itu_app/controller/user_films_controller.dart';
import 'package:itu_app/model/user_films_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/model/film_model.dart';

import 'dart:io';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filmController = context.watch<FilmController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: FutureBuilder(
        future: filmController.films(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List<Film> films = snapshot.data as List<Film>;

            if (films.isEmpty) {
              return const Center(
                child: Text('No films available.'),
              );
            }

            return SafeArea(
              child: FilmSwiper(films: films),
            );
          }
        },
      ),
    );
  }
}

class FilmSwiper extends StatefulWidget {
  final List<Film> films;

  const FilmSwiper({Key? key, required this.films}) : super(key: key);

  @override
  _FilmSwiperState createState() => _FilmSwiperState();
}

class _FilmSwiperState extends State<FilmSwiper> {
  final CardSwiperController cardSwiperController = CardSwiperController();
  int currentIndex = 0;
  bool isRoundCompleted = false;
  List<int> viewedFilmIds = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of films that the user has already viewed
    fetchViewedFilms();
  }

  @override
  void didUpdateWidget(covariant FilmSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the film list has changed
    if (!listEquals(oldWidget.films, widget.films)) {
      // Reset the CardSwiperController and other variables
      cardSwiperController.dispose();
      currentIndex = 0;
      isRoundCompleted = false;

      // Fetch the list of films that the user has already viewed
      fetchViewedFilms();
    }
  }

  Future<void> fetchViewedFilms() async {
    List<UserFilms> viewedFilms = await Provider.of<UserFilmsController>(
            context,
            listen: false)
        .userFilms(
            1); // Assuming the user ID is 1, replace it with the actual user ID
    setState(() {
      viewedFilmIds = viewedFilms.map((film) => film.filmId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // Exclude films that the user has already viewed
    List<Film> filteredFilms =
        widget.films.where((film) => !viewedFilmIds.contains(film.id)).toList();

    return Column(
      children: [
        if (!isRoundCompleted && filteredFilms.isNotEmpty)
          Expanded(
            child: CardSwiper(
              controller: cardSwiperController,
              cardsCount: filteredFilms.length,
              cardBuilder: (BuildContext context, int index, __, ___) {
                Film currentFilm = filteredFilms[index];
                double posterHeight = screenSize.height * 0.4;

                return InkWell(
                  onTap: () {
                    int filmId = currentFilm.id!;
                    // Open the comments screen for the selected film
                    context.push('/listFilms/$filmId/comments');
                  },
                  child: Container(
                    color: Colors.orangeAccent[100],
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        currentFilm.posterPath != "<No poster>"
                            ? Container(
                                height: posterHeight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image:
                                        Image.file(File(currentFilm.posterPath))
                                            .image,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: posterHeight,
                                child: const Text("<No poster>"),
                              ),
                        const SizedBox(height: 5),
                        Text(currentFilm.title),
                        const SizedBox(height: 5),
                        Text("Overview: ${currentFilm.overview}"),
                        const SizedBox(height: 5),
                        Text("Release date: ${currentFilm.releaseDate}"),
                        const SizedBox(height: 5),
                        Text("Actors: ${currentFilm.actors}"),
                        const SizedBox(height: 5),
                        Text("Director: ${currentFilm.director}"),
                        const SizedBox(height: 5),
                        Text("Duration: ${currentFilm.duration}"),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              },
              onSwipe: (previousIndex, currentIndex, direction) {
                debugPrint(
                    'Card swiped from $previousIndex to $currentIndex in direction ${direction.name}');

                if (previousIndex == filteredFilms.length - 1) {
                  setState(() {
                    isRoundCompleted = true;
                  });

                  // Additional logic or message when the round is completed
                  print('Round completed!');

                  // You can add additional UI or show a button to restart
                }

                // Handle the swipe direction
                if (direction.name == 'right') {
                  // Swiped right (liked), add the film to user's likes
                  Provider.of<UserFilmsController>(context, listen: false)
                      .addUserFilm(1, filteredFilms[currentIndex!].id!, true);
                } else if (direction.name == 'left') {
                  // Swiped left (disliked), add the film to user's dislikes
                  Provider.of<UserFilmsController>(context, listen: false)
                      .addUserFilm(1, filteredFilms[currentIndex!].id!, false);
                }

                return true;
              },
              numberOfCardsDisplayed: 1,
              backCardOffset:
                  const Offset(-1000, 0), // Set a large negative offset
            ),
          ),
        if (isRoundCompleted || filteredFilms.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Delete all rows in user_films for the user
                  Provider.of<UserFilmsController>(context, listen: false)
                      .deleteAllUserFilms(
                          1); // Replace 1 with the actual user ID

                  // Reset viewedFilmIds
                  setState(() {
                    viewedFilmIds = [];
                    isRoundCompleted = false;
                  });
                },
                child: const Text('Swipe Again'),
              ),
            ],
          ),
      ],
    );
  }

  @override
  void dispose() {
    cardSwiperController.dispose();
    super.dispose();
  }
}
