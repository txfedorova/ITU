import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:itu_app/model/film.dart';
import 'package:itu_app/model/films.dart';

class ListFilms extends StatelessWidget {
  const ListFilms({super.key});

  @override
  Widget build(BuildContext context) {
    var films = context.select((FilmsModel model) => model.films());
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
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
                      var film0 = const Film(id: 0, title: "Film0");
                      var film1 = const Film(id: 1, title: "Film1");
                      var model = context.read<FilmsModel>();
                      model.insertFilm(film0);
                      model.insertFilm(film1);
                    },
                  ),
                ],
              ),
              FutureBuilder(
                  future: films,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: ListView.separated(
                          itemBuilder: (_, index) =>
                              _MyListItem(snapshot.data![index]),
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

  // void _gotoHomeScreen() {
  //   _films.then((films) {
  //     if (films.isEmpty) {
  //       setState(() {
  //         _body = const Text('No films');
  //       });
  //     } else {
  //       setState(() {
  //         _body = ListFilmsContent(filmCount: films.length);
  //       });
  //     }
  //   });
  // }
}

// class ListFilmsContent extends StatelessWidget {
//   //const ListFilmsContent({Key? key}) : super(key: key);

//   int filmCount = 0;

//   ListFilmsContent({required this.filmCount, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.separated(
//         itemBuilder: (_, index) => _MyListItem(index),
//         separatorBuilder: (_, __) => const Divider(),
//         itemCount: filmCount,
//       ),
//     );
//   }
// }

class _MyListItem extends StatelessWidget {
  final Film item;

  const _MyListItem(this.item);

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
            const SizedBox(width: 24),
            Expanded(
              //child: Text(snapshot.data.title, style: textTheme),
              child: Text(item.title, style: textTheme),
            ),
            const SizedBox(width: 24),
            _DeleteButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final Film item;

  const _DeleteButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        var model = context.read<FilmsModel>();
        model.deleteFilm(item.id);
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