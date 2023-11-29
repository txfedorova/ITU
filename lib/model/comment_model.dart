class Comment {
  final int? id;
  final int filmId;
  final String text;
  final String timestamp;

  // Id must be set by the database automatically when inserting a new comment.
  Comment({
    this.id,
    required this.filmId,
    required this.text,
    required this.timestamp,
  });

  Comment.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int?,
        filmId = map['film_id'] as int,
        text = map['text'] as String,
        timestamp = map['timestamp'] as String;

  // When inserting a new comment, the id must not be supplied.
  Map<String, dynamic> toMap() {
    final map = {
      'film_id': filmId,
      'text': text,
      'timestamp': timestamp,
    };

    // In case we update an existing comment, we need to supply the id.
    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }

  @override
  String toString() {
    return 'Comment{id: $id, filmId: $filmId, text: $text}';
  }
}
