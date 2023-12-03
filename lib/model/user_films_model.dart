class UserFilms {
  final int? id;
  final int userId;
  final int filmId;
  final int choise;

  UserFilms(
      {this.id,
      required this.userId,
      required this.filmId,
      required this.choise});

  UserFilms.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int?,
        userId = map['userId'] as int,
        filmId = map['filmId'] as int,
        choise = map['choise'] as int;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'filmId': filmId,
      'choise': choise,
    };
  }

  @override
  String toString() {
    return 'UserFilms{id: $id, userId: $userId, filmId: $filmId, choise: $choise}';
  }
}
