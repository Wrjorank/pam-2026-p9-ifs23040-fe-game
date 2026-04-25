class Game {
  final int id;
  final String title;
  final String genre;
  final String description;
  final String popularityReason;
  final String createdAt;

  Game({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.popularityReason,
    required this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      genre: json['genre'],
      description: json['description'],
      popularityReason: json['popularity_reason'],
      createdAt: json['created_at'],
    );
  }
}
