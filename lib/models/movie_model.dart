/// Model untuk merepresentasikan data Movie dari TMDB API
class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  /// Factory method untuk mengonversi JSON ke objek `Movie`
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? 'Unknown',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  /// Konversi List JSON menjadi List `Movie`
  static List<Movie> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Movie.fromJson(json)).toList();
  }

  /// Konversi objek `Movie` menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "poster_path": posterPath,
      "release_date": releaseDate,
      "vote_average": voteAverage,
    };
  }
}
