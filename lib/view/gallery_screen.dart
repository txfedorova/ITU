import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:itu_app/controller/user_controller.dart';
import 'package:itu_app/controller/user_films_controller.dart';
import 'package:itu_app/model/user_films_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/model/film_model.dart';

import 'dart:io';

class GalleryScreen extends StatelessWidget {
  final int userId;
  const GalleryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var filmController = context.watch<FilmController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Film selection'),
        backgroundColor: const Color.fromARGB(255, 68, 70, 115),
        foregroundColor: Colors.white,
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
              child: FilmSwiper(films: films, userId: userId),
            );
          }
        },
      ),
    );
  }
}


class CommentsWidget extends StatelessWidget {
  final int filmId;

  const CommentsWidget({Key? key, required this.filmId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Adjust the height as needed
      child: TextButton(
        onPressed: () {
          // Open the comments screen for the selected film
          context.push('/listFilms/$filmId/comments');
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.comment),
            SizedBox(width: 8),
            Text('View Comments'),
          ],
        ),
      ),
    );
  }
}

class FilmAttribute extends StatelessWidget {
  final String attribName;
  final String attribValue;

  const FilmAttribute({Key? key, required this.attribName, required this.attribValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: attribName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: attribValue,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class FilmPoster extends StatelessWidget {
  final String posterPath;

  const FilmPoster({Key? key, required this.posterPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      posterPath != "<No poster>"
      ? Container(
          height: 500,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(20),
            image: DecorationImage(
              image: Image.file(File(posterPath)).image,
              fit: BoxFit.fill,
            ),
          ),
        )
      : const SizedBox(
          height: 200,
          child: Text("<No poster>"),
        )
    );
  }
}

class FilmSwiper extends StatefulWidget {
  final List<Film> films;
  final int userId;

  const FilmSwiper({Key? key, required this.films, required this.userId})
      : super(key: key);

  @override
  _FilmSwiperState createState() => _FilmSwiperState();
}

class _FilmSwiperState extends State<FilmSwiper> {
  final CardSwiperController cardSwiperController = CardSwiperController();
  int currentIndex = 0;
  bool isRoundCompleted = false;
  List<int> viewedFilmIds = [];
  String feedbackMessage = '';
  Color feedbackColor = Colors.black;
  String name = '';

  @override
  void initState() {
    super.initState();
    // Fetch the list of films that the user has already viewed
    fetchViewedFilms();
    fetchUserName();
  }

  Future<void> fetchViewedFilms() async {
    List<UserFilms> viewedFilms =
        await Provider.of<UserFilmsController>(context, listen: false)
            .userFilms(widget.userId);
    setState(() {
      viewedFilmIds = viewedFilms.map((film) => film.filmId).toList();
    });
  }

  Future<void> fetchUserName() async {
    String userName = await Provider.of<UserController>(
      context,
      listen: false,
    ).getUserName(widget.userId);

    name = userName;
  }

  @override
  Widget build(BuildContext context) {
    // Exclude films that the user has already viewed
    List<Film> filteredFilms =
        widget.films.where((film) => !viewedFilmIds.contains(film.id)).toList();

    return Stack(
      alignment: Alignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isRoundCompleted && filteredFilms.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 10),
              Text(
                '$name\'s turn!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 700,
                  width: 350,
                  child: CardSwiper(
                    controller: cardSwiperController,
                    cardsCount: filteredFilms.length,
                    cardBuilder: (BuildContext context, int index, __, ___) {
                      Film currentFilm = filteredFilms[index];

                      return InkWell(
                        onTap: () {
                          int filmId = currentFilm.id!;
                          // Open the comments screen for the selected film
                          context.push('/listFilms/$filmId/comments');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: SizedBox(
                                height: 600,
                                width: 350,
                                child: SingleChildScrollView(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FilmPoster(posterPath: currentFilm.posterPath),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: Text(
                                          currentFilm.title,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      FilmAttribute(attribName: "Overview: ", attribValue: currentFilm.overview),
                                      const SizedBox(height: 5),
                                      FilmAttribute(attribName: "Release Date: ", attribValue: currentFilm.releaseDate),
                                      const SizedBox(height: 5),
                                      FilmAttribute(attribName: "Actors: ", attribValue: currentFilm.actors),
                                      const SizedBox(height: 5),
                                      FilmAttribute(attribName: "Director: ", attribValue: currentFilm.director),
                                      const SizedBox(height: 5),
                                      FilmAttribute(attribName: "Duration: ", attribValue: currentFilm.duration),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                  // ),
                                ),
                              ),
                            ),
                            Center(
                              child: CommentsWidget(filmId: currentFilm.id!,)
                            ),
                          ],
                        ),
                      );
                    },
                    onSwipe: (previousIndex, currentIndex, direction) {
                      debugPrint(
                          'Card swiped from $previousIndex to $currentIndex in direction ${direction.name}'
                      );

                      if (previousIndex == filteredFilms.length - 1) {
                        setState(() {
                          isRoundCompleted = true;
                        });

                        // Additional logic or message when the round is completed
                        print('Round completed!');

                        // You can add additional UI or show a button to restart
                      }

                      // Handle the swipe direction
                      if (direction.name == 'right' ||
                          direction.name == 'top') {
                        // Swiped right (liked), add the film to user's likes
                        Provider.of<UserFilmsController>(context, listen: false)
                            .addUserFilm(widget.userId,
                                filteredFilms[previousIndex].id!, true);
                        setState(() {
                          feedbackMessage = 'Liked!';
                          feedbackColor =
                              const Color.fromARGB(255, 46, 125, 48);
                        });
                      } else if (direction.name == 'left' ||
                          direction.name == 'bottom') {
                        // Swiped left (disliked), add the film to user's dislikes
                        Provider.of<UserFilmsController>(context, listen: false)
                            .addUserFilm(widget.userId,
                                filteredFilms[previousIndex].id!, false);
                        setState(() {
                          feedbackMessage = 'Disliked!';
                          feedbackColor = Colors.red;
                        });
                      }

                      // Reset feedback message after a second
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          feedbackMessage = '';
                        });
                      });

                      return true;
                    },
                    numberOfCardsDisplayed: 1,
                    backCardOffset:
                        const Offset(-1000, 0), // Set a large negative offset
                  ),
                ),
              ),
            ],
          ),
        if (isRoundCompleted || filteredFilms.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 180,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      // Delete all rows in user_films for the user
                      Provider.of<UserFilmsController>(context, listen: false)
                          .deleteAllUserFilms(widget.userId);

                      // Reset viewedFilmIds
                      setState(() {
                        viewedFilmIds = [];
                        isRoundCompleted = false;
                      });
                    },
                    child: const Text(
                      'Swipe Again',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 180,
                  height: 60,
                  child: ElevatedButton(
                    child: const Text(
                      'View results',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      context.push('/statsScreen');
                    },
                  ),
                ),
              ),
            ],
          ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: feedbackColor,
              ),
            ),
          ),
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
