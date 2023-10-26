// import 'package:json_annotation/json_annotation.dart';

// part 'film.g.dart';
// @JsonSerializable()
class Film {
  final int id;
  final String title;

  const Film({required this.id, required this.title});

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Film && other.id == id;

  // factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
  // Map<String, dynamic> toJson() => _$FilmToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Film{id: $id, title: $title}';
  }
}