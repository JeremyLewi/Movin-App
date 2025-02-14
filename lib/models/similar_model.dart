// To parse this JSON data, do
//
//     final similar = similarFromMap(jsonString);

import 'dart:convert';

Similar similarFromMap(String str) => Similar.fromMap(json.decode(str));

String similarToMap(Similar data) => json.encode(data.toMap());

class Similar {
  int? page;
  List<SimilarResult>? results;
  int? totalPages;
  int? totalResults;

  Similar({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  // Method for parsing the data from a Map (usually from API response)
  factory Similar.fromMap(Map<String, dynamic> json) {
    return Similar(
      page: json["page"],
      results: json["results"] == null
          ? []
          : List<SimilarResult>.from(
              json["results"]!.map((x) => SimilarResult.fromMap(x))),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
  }

  // Method to convert object back into a Map
  Map<String, dynamic> toMap() {
    return {
      "page": page,
      "results": results == null
          ? []
          : List<dynamic>.from(results!.map((x) => x.toMap())),
      "total_pages": totalPages,
      "total_results": totalResults,
    };
  }
}

class SimilarResult {
  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  DateTime? releaseDate;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  SimilarResult({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  // Method for parsing the data from a Map (usually from API response)
  factory SimilarResult.fromMap(Map<String, dynamic> json) {
    DateTime? parsedDate;
    try {
      if (json["release_date"] != null && json["release_date"].isNotEmpty) {
        parsedDate = DateTime.parse(json["release_date"]);
      }
    } catch (e) {
      parsedDate = null; // If invalid, we set the date to null
    }

    return SimilarResult(
      adult: json["adult"],
      backdropPath: json["backdrop_path"],
      genreIds: json["genre_ids"] == null
          ? []
          : List<int>.from(json["genre_ids"]!.map((x) => x)),
      id: json["id"],
      originalLanguage: json["original_language"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      popularity: json["popularity"]?.toDouble(),
      posterPath: json["poster_path"],
      releaseDate: parsedDate, // Ensure we safely handle the date
      title: json["title"],
      video: json["video"],
      voteAverage: json["vote_average"]?.toDouble(),
      voteCount: json["vote_count"],
    );
  }

  // Method to convert object back into a Map
  Map<String, dynamic> toMap() {
    return {
      "adult": adult,
      "backdrop_path": backdropPath,
      "genre_ids":
          genreIds == null ? [] : List<dynamic>.from(genreIds!.map((x) => x)),
      "id": id,
      "original_language": originalLanguage,
      "original_title": originalTitle,
      "overview": overview,
      "popularity": popularity,
      "poster_path": posterPath,
      "release_date": releaseDate != null
          ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}"
          : null,
      "title": title,
      "video": video,
      "vote_average": voteAverage,
      "vote_count": voteCount,
    };
  }
}
