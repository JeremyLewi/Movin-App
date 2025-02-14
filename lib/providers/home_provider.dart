import 'package:flutter/material.dart';
import 'package:flutter_movie_app/models/now_playing_model.dart';
import 'package:flutter_movie_app/models/popular_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

/// Kelas `HomeProvider` mengelola state untuk film-film yang sedang tayang (Now Playing),
/// film populer, serta daftar film favorit dan watchlist pengguna. Kelas ini juga mengelola status
/// pemuatan data dan melakukan pemanggilan API untuk memperbarui daftar film yang relevan.
class HomeProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<NowPlayingResult> _nowPlayingMovies = [];
  List<PopularResult> _popularMovies = [];
  List<dynamic> _favoriteMovies = [];
  List<dynamic> _watchlistMovies = [];
  bool _isLoading = false;

  /// Mendapatkan daftar film yang sedang tayang.
  ///
  /// Mengembalikan daftar film yang sedang tayang yang disimpan dalam [_nowPlayingMovies].
  List<NowPlayingResult> get nowPlayingMovies => _nowPlayingMovies;

  /// Mendapatkan daftar film populer.
  ///
  /// Mengembalikan daftar film populer yang disimpan dalam [_popularMovies].
  List<PopularResult> get popularMovies => _popularMovies;

  /// Mendapatkan daftar film favorit pengguna.
  ///
  /// Mengembalikan daftar film favorit yang disimpan dalam [_favoriteMovies].
  List<dynamic> get favoriteMovies => _favoriteMovies;

  /// Mendapatkan daftar film yang ada di watchlist pengguna.
  ///
  /// Mengembalikan daftar film dalam watchlist yang disimpan dalam [_watchlistMovies].
  List<dynamic> get watchlistMovies => _watchlistMovies;

  /// Mendapatkan status apakah data sedang dimuat.
  ///
  /// Mengembalikan nilai boolean yang menunjukkan apakah data sedang dimuat.
  bool get isLoading => _isLoading;

  /// Mengambil semua data film dan daftar pengguna sekaligus.
  ///
  /// Fungsi ini mengambil data film yang sedang tayang, film populer, serta daftar film favorit dan watchlist
  /// pengguna. Semua data akan diambil dalam satu operasi dan diperbarui di UI.
  Future<void> fetchAllMoviesAndLists() async {
    final prefs = await SharedPreferences.getInstance();

    final sessionId = prefs.getString('session_id');
    final accountId = prefs.getString('account_id');
    _isLoading = true;
    notifyListeners();

    try {
      final nowPlayingResponse = await _apiService.fetchNowPlaying();
      final popularResponse = await _apiService.fetchPopularMovies();
      final favoriteMoviesResponse =
          await _apiService.fetchFavoriteMovies(accountId!, sessionId!);
      final watchlistMoviesResponse =
          await _apiService.fetchWatchlistMovies(accountId, sessionId);

      _nowPlayingMovies = nowPlayingResponse
          .map((json) => NowPlayingResult.fromMap(json))
          .toList();
      _popularMovies =
          popularResponse.map((json) => PopularResult.fromMap(json)).toList();
      _favoriteMovies = favoriteMoviesResponse;
      _watchlistMovies = watchlistMoviesResponse;
      // ignore: empty_catches
    } catch (e) {}

    _isLoading = false;
    notifyListeners();
  }

  /// Menambahkan film ke daftar favorit.
  ///
  /// Fungsi ini menambahkan film ke daftar favorit pengguna. Jika film berhasil ditambahkan,
  /// maka daftar favorit akan diperbarui tanpa perlu memuat ulang seluruh data.
  ///
  /// [movieId] adalah ID film yang akan ditambahkan ke daftar favorit.
  Future<void> addToFavorite(int movieId) async {
    final success = await _apiService.addFavoriteMovie(movieId);
    if (success) {
      // Update status favorit tanpa re-fetch seluruh data
      if (!_favoriteMovies.any((movie) => movie['id'] == movieId)) {
        _favoriteMovies.add({'id': movieId}); // Menambahkan ke daftar favorit
      }
      notifyListeners(); // Memberitahukan UI agar diperbarui
    }
  }

  /// Menambahkan film ke daftar watchlist.
  ///
  /// Fungsi ini menambahkan film ke daftar watchlist pengguna. Jika film berhasil ditambahkan,
  /// maka daftar watchlist akan diperbarui tanpa perlu memuat ulang seluruh data.
  ///
  /// [movieId] adalah ID film yang akan ditambahkan ke daftar watchlist.
  Future<void> addToWatchlist(int movieId) async {
    final success = await _apiService.addWatchlistMovie(movieId);
    if (success) {
      // Update status watchlist tanpa re-fetch seluruh data
      if (!_watchlistMovies.any((movie) => movie['id'] == movieId)) {
        _watchlistMovies
            .add({'id': movieId}); // Menambahkan ke daftar watchlist
      }
      notifyListeners(); // Memberitahukan UI agar diperbarui
    }
  }
}
