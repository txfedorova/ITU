import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:itu_app/model/film_model.dart';
import 'package:itu_app/controller/film_controller.dart';

class FilmsList extends StatelessWidget {
  const FilmsList({super.key});

  @override
  Widget build(BuildContext context) {
    var films = context.watch<FilmController>().films();

    print("\n\nBUILDING LIST FILMS\n\n");
    films.then((films) {
      for (var film in films) {
        print(film.title);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Films'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: const Text('Add film'),
                    onPressed: () {
                      context.push('/editScreen');
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Add test films'),
                    onPressed: () {
                      var film0 = Film(
                          title: "Elementary Investigations",
                          year: 2018,
                          duration: const Duration(hours: 1, minutes: 50),
                          director: "Sarah Smith",
                          description: "Follow the adventures of Sherlock Holmes and Dr. Watson as they tackle puzzling cases and outsmart criminals in this thrilling detective series.",
                          actors: "Jonny Lee Miller, Aidan Quinn");
                      var film1 = Film(
                          title: "The Mystery of Baker Street",
                          year: 2019,
                          duration: const Duration(hours: 2, minutes: 5),
                          director: "Amanda Anderson",
                          description: "A modern adaptation of Sherlock Holmes, featuring the brilliant detective and his partner, Dr. Watson, as they solve intricate crimes in contemporary London.",
                          actors: "Jonny Lee Miller, Lucy Liu");
                      var film2 = Film(
                          title: "The Mysterious Heist",
                          year: 2019,
                          duration: const Duration(hours: 2, minutes: 10),
                          director: "Olivia Owens",
                          description: "A group of skilled thieves plan and execute a daring heist to steal priceless artifacts from a high-security museum, leading to a thrilling cat-and-mouse game with the authorities.",
                          actors: "Emma Watson, Tom Hardy"
                      );
                      var film3 = Film(
                          title: "Inception",
                          year: 2010,
                          duration: const Duration(hours: 2, minutes: 28),
                          director: "Christopher Nolan",
                          description: "A skilled thief, Cobb, is able to enter people's dreams and steal their secrets. Now he is given a task of planting an idea into someone's mind, a concept that is considered impossible.",
                          actors: "Leonardo DiCaprio, Joseph Gordon-Levitt"
                      );
                      var film4 = Film(
                          title: "The Martian",
                          year: 2015,
                          duration: const Duration(hours: 2, minutes: 24),
                          director: "Ridley Scott",
                          description: "Astronaut Mark Watney is presumed dead after a fierce storm and left behind on Mars by his crew. With limited supplies, he must find a way to survive and signal to Earth that he is still alive.",
                          actors: "Matt Damon, Jessica Chastain"
                      );
                      var film5 = Film(
                          title: "The Grand Budapest Hotel",
                          year: 2014,
                          duration: const Duration(hours: 1, minutes: 39),
                          director: "Wes Anderson",
                          description: "The adventures of Gustave H, a legendary concierge at a famous European hotel, and Zero Moustafa, the lobby boy who becomes his most trusted friend.",
                          actors: "Ralph Fiennes, Tony Revolori"
                      );

                      var controller = context.read<FilmController>();
                      controller.insertFilm(film0);
                      controller.insertFilm(film1);
                      controller.insertFilm(film2);
                      controller.insertFilm(film3);
                      controller.insertFilm(film4);
                      controller.insertFilm(film5);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Delete all films'),
                    onPressed: () {
                      var controller = context.read<FilmController>();
                      controller.clearFilms();
                    },
                  ),
             
                ],
              ),
              // Wait until database returns the list of films
              FutureBuilder(
                  future: films,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Display the list of films
                      return Expanded(
                        child: ListView.separated(
                          itemBuilder: (_, index) =>
                              _ListEntry(snapshot.data![index]),
                          separatorBuilder: (_, __) => const Divider(),
                          itemCount: snapshot.data!.length,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return const CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListEntry extends StatelessWidget {
  final Film item;

  const _ListEntry(this.item);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(item.title, style: textTheme),
            ),
            _ListEntryDeleteButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _ListEntryDeleteButton extends StatelessWidget {
  final Film item;

  const _ListEntryDeleteButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        var model = context.read<FilmController>();
        model.deleteFilm(item.id!);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          return null; // Defer to the widget's default.
        }),
      ),
      child: const Icon(Icons.recycling, semanticLabel: 'DELETE'),
    );
  }
}

// https://docs.flutter.dev/data-and-backend/state-mgmt/simple
// https://pub.dev/packages/provider