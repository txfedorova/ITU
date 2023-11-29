import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/model/film_model.dart';

import 'dart:io';

class GalleryScreen extends StatelessWidget {
  //final CardSwiperController cardSwiperController = CardSwiperController();
  
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var futureFilms = context.watch<FilmController>().films();

    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: FutureBuilder(
        future: futureFilms,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            List<Film> films = snapshot.data ?? [];
            //List<String> imageNames = films.map((film) => film.title).toList();
            return SafeArea(
              child: _CardSwiper(films)
            );
          }
        }
      ),
    );
  }


}


class _CardSwiper extends StatefulWidget {
  final List<Film> films;

  const _CardSwiper(this.films, {super.key});

  @override
  State<_CardSwiper> createState() => _CardSwiperWidgetState();
}

class _CardSwiperWidgetState extends State<_CardSwiper> {
  final CardSwiperController cardSwiperController = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return CardSwiper(
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
              mainAxisAlignment : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                currentFilm.posterPath != "<No poster>" ?
                Container(
                  //width: screenSize.width,
                  height: posterHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: Image.file(File(currentFilm.posterPath)).image,
                      //fit: BoxFit.cover,
                    ),
                  ),
                )
                : SizedBox(height: posterHeight, child: const Text("<No poster>")),
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
        return true;
      },
      numberOfCardsDisplayed: 2,
      backCardOffset: const Offset(-30, 0),
      //padding: EdgeInsets.only(bottom: screenSize.height * 0.05), // Отступ снизу, чтобы вторая карточка была видна
    );
  }

  @override
  void dispose() {
    cardSwiperController.dispose();
    super.dispose();
  }
}

