class MovieModel {
  final int id;
  final String title;
  final String genre;
  final String posterUrl;
  final String description;

  MovieModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.posterUrl,
    required this.description,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      genre: json['genre'],
      posterUrl: json['poster_url'],
      description: json['description'],
    );
  }
}
