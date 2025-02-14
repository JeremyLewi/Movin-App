import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_movie_app/config/app_config.dart';
import 'package:flutter_movie_app/models/detail_model.dart';
import 'package:flutter_movie_app/models/similar_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ApiService adalah kelas yang digunakan untuk berkomunikasi dengan TMDB API menggunakan Dio.
/// Kelas ini menyediakan metode-metode untuk mengambil data film, detail akun, dan melakukan operasi lain
/// terkait dengan data akun seperti daftar film favorit dan watchlist.
class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: Duration(milliseconds: AppConfig.apiTimeout),
    receiveTimeout: Duration(milliseconds: AppConfig.apiTimeout),
    headers: {
      'Authorization': 'Bearer ${AppConfig.token}',
      'Content-Type': 'application/json',
    },
  ));

  /// Helper method untuk menangani request API dengan error handling.
  ///
  /// Metode ini menerima fungsi yang mengembalikan objek [Future<Response>],
  /// melakukan request dan menangani kemungkinan error.
  ///
  /// [apiCall] adalah fungsi yang akan dipanggil untuk melakukan request API.
  /// Mengembalikan data hasil request dalam tipe [T] jika sukses, atau null jika terjadi error.
  Future<T?> _handleApiCall<T>(Future<Response> Function() apiCall) async {
    try {
      final response = await apiCall();
      return response.data as T;
    } on DioException catch (e) {
      if (kDebugMode) {
        print("API Error: ${e.message}");
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected Error: $e");
      }
      return null;
    }
  }

  /// Membuat request token baru untuk otentikasi.
  ///
  /// Fungsi ini mengirimkan permintaan untuk mendapatkan token baru yang
  /// diperlukan untuk autentikasi dan sesi API lebih lanjut.
  /// Mengembalikan data berupa map atau objek kosong jika gagal.
  Future<Map<String, dynamic>> fetchRequestToken() async {
    return await _handleApiCall<Map<String, dynamic>>(
            () => _dio.get('/authentication/token/new')) ??
        {};
  }

  /// Membuat session id dengan request token yang sudah di-authorize.
  ///
  /// Fungsi ini digunakan untuk membuat sesi yang valid dengan menggunakan
  /// token yang diterima sebelumnya. Sesi ini digunakan untuk operasi lebih lanjut
  /// yang memerlukan otentikasi.
  ///
  /// [requestToken] adalah token yang digunakan untuk membuat session id.
  /// Mengembalikan data sesi dalam bentuk map atau objek kosong jika gagal.
  Future<Map<String, dynamic>> createSession(String requestToken) async {
    return await _handleApiCall<Map<String, dynamic>>(
            () => _dio.post('/authentication/session/new', data: {
                  'request_token': requestToken,
                })) ??
        {};
  }

  /// Mengambil detail akun berdasarkan session id.
  ///
  /// Fungsi ini digunakan untuk mengambil detail akun terkait dengan session id
  /// yang aktif. Digunakan untuk memeriksa informasi akun pengguna.
  ///
  /// [sessionId] adalah ID sesi yang valid untuk mendapatkan informasi akun.
  /// Mengembalikan data akun dalam bentuk map atau objek kosong jika gagal.
  Future<Map<String, dynamic>> fetchAccountDetails(String sessionId) async {
    return await _handleApiCall<Map<String, dynamic>>(
            () => _dio.get('/account', queryParameters: {
                  'session_id': sessionId,
                })) ??
        {};
  }

  /// Mengambil detail akun berdasarkan account id.
  ///
  /// Fungsi ini mengambil informasi akun berdasarkan ID akun spesifik.
  /// Dapat digunakan untuk memverifikasi atau mengakses informasi pengguna.
  ///
  /// [accountId] adalah ID akun yang akan dicari.
  /// [sessionId] adalah ID sesi yang valid.
  Future<Map<String, dynamic>> fetchAccountDetailsById(
      String accountId, String sessionId) async {
    return await _handleApiCall<Map<String, dynamic>>(
            () => _dio.get('/account/$accountId', queryParameters: {
                  'session_id': sessionId,
                })) ??
        {};
  }

  /// Mengambil daftar film yang sedang tayang (Now Playing).
  ///
  /// Fungsi ini mengambil daftar film yang saat ini sedang tayang di bioskop.
  ///
  /// [limit] menentukan jumlah film yang akan diambil (default: 6).
  Future<List<dynamic>> fetchNowPlaying({int limit = 6}) async {
    final data = await _handleApiCall<Map<String, dynamic>>(
        () => _dio.get('/movie/now_playing'));
    return data?['results']?.take(limit).toList() ?? [];
  }

  /// Mengambil daftar film populer.
  ///
  /// Fungsi ini digunakan untuk mengambil daftar film yang populer berdasarkan
  /// data yang tersedia di API.
  ///
  /// [limit] menentukan jumlah film yang akan diambil (default: 20).
  Future<List<dynamic>> fetchPopularMovies({int limit = 20}) async {
    final data = await _handleApiCall<Map<String, dynamic>>(
        () => _dio.get('/movie/popular'));
    return data?['results']?.take(limit).toList() ?? [];
  }

  /// Mengambil detail film berdasarkan movieId dan mengonversinya ke model `Detail`.
  ///
  /// Fungsi ini digunakan untuk mengambil detail tentang film spesifik dengan ID
  /// yang diberikan dan mengonversinya ke dalam bentuk model [Detail].
  ///
  /// [movieId] adalah ID film yang akan diambil detailnya.
  Future<Detail?> fetchMovieDetail(int movieId) async {
    final data = await _handleApiCall<Map<String, dynamic>>(
        () => _dio.get('/movie/$movieId'));
    return data != null ? Detail.fromMap(data) : null;
  }

  /// Mengambil daftar film yang mirip dengan film berdasarkan movieId dan mengonversinya ke model `Similar`.
  ///
  /// Fungsi ini digunakan untuk mengambil film-film yang mirip berdasarkan ID film yang diberikan.
  /// Data yang diterima akan dipetakan ke dalam bentuk model [SimilarResult].
  ///
  /// [movieId] adalah ID film yang akan digunakan untuk mencari film yang mirip.
  Future<List<SimilarResult>> fetchSimilarMovies(int movieId) async {
    final data = await _handleApiCall<Map<String, dynamic>>(
        () => _dio.get('/movie/$movieId/similar'));

    if (data != null && data['results'] != null) {
      return List<SimilarResult>.from(
          data['results'].map((json) => SimilarResult.fromMap(json)));
    }
    return [];
  }

  /// Mengambil daftar film favorit untuk akun tertentu.
  ///
  /// Fungsi ini digunakan untuk mengambil daftar film yang ada dalam daftar favorit
  /// dari akun pengguna berdasarkan accountId dan sessionId yang valid.
  ///
  /// [accountId] adalah ID akun pengguna dan [sessionId] adalah ID sesi yang valid.
  Future<List<dynamic>> fetchFavoriteMovies(
      String accountId, String sessionId) async {
    final data = await _handleApiCall<Map<String, dynamic>>(
        () => _dio.get('/account/$accountId/favorite/movies', queryParameters: {
              'session_id': sessionId,
            }));
    return data?['results'] ?? [];
  }

  /// Mengambil daftar film dalam watchlist untuk akun tertentu.
  ///
  /// Fungsi ini digunakan untuk mengambil daftar film yang ada dalam watchlist
  /// akun pengguna berdasarkan accountId dan sessionId yang valid.
  ///
  /// [accountId] adalah ID akun pengguna dan [sessionId] adalah ID sesi yang valid.
  Future<List<dynamic>> fetchWatchlistMovies(
      String accountId, String sessionId) async {
    final data = await _handleApiCall<Map<String, dynamic>>(() =>
        _dio.get('/account/$accountId/watchlist/movies', queryParameters: {
          'session_id': sessionId,
        }));
    return data?['results'] ?? [];
  }

  /// Mengambil `sessionId` dari SharedPreferences.
  ///
  /// Fungsi ini mengambil session ID yang tersimpan dalam SharedPreferences
  /// untuk keperluan otentikasi.
  Future<String?> _getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_id');
  }

  /// Mengambil `accountId` dari SharedPreferences.
  ///
  /// Fungsi ini mengambil account ID yang tersimpan dalam SharedPreferences.
  Future<String?> _getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('account_id');
  }

  /// Menambahkan film ke daftar favorit.
  ///
  /// Fungsi ini digunakan untuk menambahkan film ke dalam daftar favorit akun
  /// pengguna berdasarkan sessionId dan accountId.
  ///
  /// [movieId] adalah ID film yang akan ditambahkan ke favorit.
  Future<bool> addFavoriteMovie(int movieId) async {
    final sessionId = await _getSessionId();
    final accountId = await _getAccountId();

    if (sessionId == null || accountId == null) {
      return false;
    }

    final data = await _handleApiCall<Map<String, dynamic>>(
      () => _dio.post(
        '/account/$accountId/favorite',
        queryParameters: {'session_id': sessionId},
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      ),
    );

    return data != null && data['status_code'] == 1;
  }

  /// Menambahkan film ke daftar Watchlist.
  ///
  /// Fungsi ini digunakan untuk menambahkan film ke dalam watchlist akun pengguna
  /// berdasarkan sessionId dan accountId.
  ///
  /// [movieId] adalah ID film yang akan ditambahkan ke watchlist.
  Future<bool> addWatchlistMovie(int movieId) async {
    final sessionId = await _getSessionId();
    final accountId = await _getAccountId();

    if (sessionId == null || accountId == null) {
      return false;
    }

    final data = await _handleApiCall<Map<String, dynamic>>(
      () => _dio.post(
        '/account/$accountId/watchlist',
        queryParameters: {'session_id': sessionId},
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'watchlist': true,
        },
      ),
    );

    return data != null && data['status_code'] == 1;
  }

  /// Mengecek apakah film ada di daftar Favorit.
  ///
  /// Fungsi ini digunakan untuk mengecek apakah film dengan ID yang diberikan ada
  /// dalam daftar film favorit pengguna berdasarkan sessionId dan accountId.
  ///
  /// [movieId] adalah ID film yang akan diperiksa apakah ada di daftar favorit.
  Future<bool> isFavoriteMovie(int movieId) async {
    final sessionId = await _getSessionId();
    final accountId = await _getAccountId();

    if (sessionId == null || accountId == null) {
      return false;
    }

    final data = await _handleApiCall<Map<String, dynamic>>(
      () => _dio.get(
        '/account/$accountId/favorite/movies',
        queryParameters: {'session_id': sessionId},
      ),
    );

    if (data != null && data['results'] != null) {
      return data['results'].any((movie) => movie['id'] == movieId);
    }

    return false;
  }

  /// Mengecek apakah film ada di daftar Watchlist.
  ///
  /// Fungsi ini digunakan untuk mengecek apakah film dengan ID yang diberikan ada
  /// dalam daftar watchlist pengguna berdasarkan sessionId dan accountId.
  ///
  /// [movieId] adalah ID film yang akan diperiksa apakah ada di daftar watchlist.
  Future<bool> isWatchlistMovie(int movieId) async {
    final sessionId = await _getSessionId();
    final accountId = await _getAccountId();

    if (sessionId == null || accountId == null) {
      return false;
    }

    final data = await _handleApiCall<Map<String, dynamic>>(
      () => _dio.get(
        '/account/$accountId/watchlist/movies',
        queryParameters: {'session_id': sessionId},
      ),
    );

    if (data != null && data['results'] != null) {
      return data['results'].any((movie) => movie['id'] == movieId);
    }

    return false;
  }
}
