import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:itu_app/model/film_model.dart';
import 'package:itu_app/controller/film_controller.dart';

class FilmsList extends StatelessWidget {
  const FilmsList({super.key});

  @override
  Widget build(BuildContext context) {
    //var films = context.select((FilmsModel model) => model.films());
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
          decoration: const BoxDecoration(
            color: Colors.amber,
          ),
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
                      var film0 = Film(title: "The Sherlock", year: 2021, 
                        duration: const Duration(hours: 1, minutes: 34), 
                        director: "Arnold Arnoldson", 
                        description: "Sherlock Holmes and Dr. Watson find themselves in 1890s London in this Christmas special.",
                        actors: "Benedict Cummerbatch, Martin Freeman");
                      var film1 = Film(title: "The Holmes", year: 2020, 
                        duration: const Duration(hours: 1, minutes: 54), 
                        director: "Robert Robertsson", 
                        description: "Sherlock Holmes and Dr. Watson find themselves in 1890s London in this Christmas special.  Again",
                        actors: "Benedict Cummerbatch, Robert Downey Jr.");
                      var controller = context.read<FilmController>();
                      controller.insertFilm(film0);
                      controller.insertFilm(film1);
                    },
                  ),
                  // ElevatedButton(
                  //   child: const Text('Delete all films'),
                  //   onPressed: () {
                  //     var controller = context.read<FilmController>();
                  //     controller.clearFilms();
                  //   },
                  // ),
                  ElevatedButton(
                    child: const Text('Clear database'),
                    onPressed: () {
                      var controller = context.read<FilmController>();
                      controller.clearDatabase();
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
    //var item = context.select((FilmsModel model) => model.getByPosition(index));
    //var item = context.watch<FilmsModel>().film(index);

    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            //const SizedBox(width: 24),
            Expanded(
              //child: Text(snapshot.data.title, style: textTheme),
              child: Text(item.title, style: textTheme),
            ),
            //const SizedBox(width: 24),
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