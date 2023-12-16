
class Film {
  // The id is set by the database automatically when inserting a new film.
  final int? id;

  String title = "<No title>";
  String overview = "<No overview>";
  String posterPath = "<No poster>";
  String actors = "<No actors>";
  String releaseDate = "<No release date>";
  String director = "<No director>";
  String duration = "<No duration>";
  // Id must be set by the database automatically when inserting a new film.
  Film() : id = null;

  Film.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int,
        title = map['title'] as String,

        releaseDate = map['releaseDate'] as String,
        duration = map['duration'] as String,
        posterPath = map['posterPath'] as String,
        director = map['director'] as String,
        overview = map['overview'] as String,
        actors = map['actors'] as String
  ;

  // When inserting a new film, the id must not be supplied.
  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'releaseDate': releaseDate,
      'duration': duration,
      'posterPath': posterPath,
      'director': director,
      'overview': overview,
      'actors': actors
    };

    // In case we update an existing film, we need to supply the id.
    if (id != null) {
      map['id'] = id!.toString();
    }

    return map;
  }

  @override
  String toString() {
    return 'Film{id: $id, title: $title}';
  }
}
