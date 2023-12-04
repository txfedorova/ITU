import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        if (!isRoundCompleted)
          Expanded(
            child: CardSwiper(
              controller: cardSwiperController,
              cardsCount: widget.films.length,
              cardBuilder: (BuildContext context, int index, __, ___) {
                Film currentFilm = widget.films[index];
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

                if (previousIndex == widget.films.length - 1) {
                  setState(() {
                    isRoundCompleted = true;
                  });

                  // Additional logic or message when the round is completed
                  print('Round completed!');

                  // You can add additional UI or show a button to restart
                }

                return true;
              },
              numberOfCardsDisplayed: 2,
              backCardOffset:
                  const Offset(-1000, 0), // Set a large negative offset
            ),
          ),
        if (isRoundCompleted)
          ElevatedButton(
            onPressed: () {
              setState(() {
                isRoundCompleted = false;
                cardSwiperController.undo();
              });
            },
            child: const Text('Start Again'),
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
