import 'package:flutter/material.dart';
import 'package:flutter_movie_app/services/api_service.dart';
import 'package:flutter_movie_app/models/detail_model.dart';
import 'package:flutter_movie_app/models/similar_model.dart';

/// Kelas `DetailProvider` mengelola state terkait dengan detail film yang ditampilkan dalam aplikasi.
/// Kelas ini bertugas untuk mengambil data detail film dan film yang mirip, serta mengelola status loading dan error.
class DetailProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Detail? _movieDetail;
  List<SimilarResult> _similarMovies = [];
  bool _isLoading = false;
  bool _hasError = false;

  /// Mendapatkan detail film yang telah diambil.
  ///
  /// Mengembalikan objek [Detail] yang berisi informasi lengkap tentang film.
  Detail? get movieDetail => _movieDetail;

  /// Mendapatkan daftar film yang mirip dengan film yang sedang ditampilkan.
  ///
  /// Mengembalikan daftar objek [SimilarResult] yang berisi daftar film mirip.
  List<SimilarResult> get similarMovies => _similarMovies;

  /// Mendapatkan status apakah data sedang dimuat.
  ///
  /// Mengembalikan nilai boolean yang menunjukkan apakah data sedang dimuat.
  bool get isLoading => _isLoading;

  /// Mendapatkan status apakah terjadi error saat mengambil data.
  ///
  /// Mengembalikan nilai boolean yang menunjukkan apakah terjadi error saat mengambil data.
  bool get hasError => _hasError;

  /// Mengambil detail film berdasarkan `movieId`.
  ///
  /// Fungsi ini memulai proses pengambilan detail film dengan menggunakan [movieId].
  /// Menyimpan hasilnya dalam [_movieDetail]. Jika terjadi error, status [_hasError] akan diset menjadi `true`.
  /// Status [_isLoading] akan diset menjadi `true` selama pengambilan data, dan `false` setelahnya.
  Future<void> fetchMovieDetail(int movieId) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _movieDetail = await _apiService.fetchMovieDetail(movieId);
    } catch (e) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Mengambil daftar film yang mirip berdasarkan `movieId`.
  ///
  /// Fungsi ini mengambil daftar film yang mirip dengan film berdasarkan [movieId].
  /// Menyimpan daftar film tersebut dalam [_similarMovies]. Jika terjadi error,
  /// [_similarMovies] akan diset menjadi list kosong.
  Future<void> fetchSimilarMovies(int movieId) async {
    try {
      List<SimilarResult> movies =
          await _apiService.fetchSimilarMovies(movieId);

      if (movies.isNotEmpty) {
        _similarMovies = movies;
      } else {}
    } catch (e) {
      _similarMovies = [];
    }
    notifyListeners(); // Pastikan notifyListeners() dipanggil untuk memperbarui UI
  }

  /// Mengambil semua data terkait detail film sekaligus.
  ///
  /// Fungsi ini memanggil [fetchMovieDetail] dan [fetchSimilarMovies] secara bersamaan
  /// menggunakan [Future.wait] untuk mengambil semua data sekaligus.
  Future<void> fetchAllDetails(int movieId) async {
    await Future.wait([
      fetchMovieDetail(movieId),
      fetchSimilarMovies(movieId),
    ]);
  }
}
