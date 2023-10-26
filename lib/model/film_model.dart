import 'package:itu_app/common/utils.dart';

class Film {
  // The id is set by the database automatically when inserting a new film.
  final int? id;

  final String title;
  final int year;
  Duration duration;
  final String director;
  final String description;
  final String actors;
  final String image;

  // Id must be set by the database automatically when inserting a new film.
  Film(
      {required this.title,
      required this.year,
      this.duration = const Duration(),
      this.director = '',
      this.description = '',
      this.actors = '',
      this.image = ''})
      : id = null;

  // @override
  // int get hashCode => id;

  // @override
  // bool operator ==(Object other) => other is Film && other.id == id;

  Film.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        title = map['title'] as String,
        year = map['year'] as int,
        duration = timeStringToDuration(map['duration'] as String),
        director = map['director'] as String,
        description = map['description'] as String,
        actors = map['actors'] as String,
        image = map['image'] as String;

  // When inserting a new film, the id must not be supplied.
  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'year': year,
      'duration': durationToTimeString(duration),
      'director': director,
      'description': description,
      'actors': actors,
      'image': image
    };

    // In case we update an existing film, we need to supply the id.
    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  @override
  String toString() {
    return 'Film{id: $id, title: $title}';
  }
}
