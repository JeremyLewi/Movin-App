/// Kelas `AppConfig` menyimpan konfigurasi aplikasi terkait dengan API TMDB,
/// seperti URL dasar API, ukuran gambar, serta API key untuk autentikasi.
class AppConfig {
  /// Base URL untuk API TMDB
  ///
  /// URL dasar yang digunakan untuk mengakses endpoint-endpoint API TMDB.
  /// Semua request API akan menggunakan base URL ini sebagai awalan.
  static const String baseUrl = "https://api.themoviedb.org/3";

  /// Base URL untuk gambar dari TMDB
  ///
  /// URL dasar untuk mengakses gambar-gambar dari TMDB, digunakan untuk
  /// menampilkan poster film, gambar profil, dan lainnya.
  static const String imageBaseUrl = "https://image.tmdb.org/t/p/";

  /// Ukuran gambar medium yang digunakan untuk poster film
  ///
  /// Menentukan ukuran gambar yang akan digunakan untuk menampilkan poster
  /// film dalam ukuran medium.
  static const String imageSizeMedium = "w500";

  /// Ukuran gambar kecil yang digunakan untuk poster film
  ///
  /// Menentukan ukuran gambar yang akan digunakan untuk menampilkan poster
  /// film dalam ukuran kecil.
  static const String imageSizeSmall = "w200";

  /// URL gambar poster film default
  ///
  /// Digunakan sebagai fallback atau gambar pengganti ketika poster film
  /// tidak tersedia.
  static const String defaultMoviePoster = "https://via.placeholder.com/150";

  /// URL gambar avatar default
  ///
  /// Digunakan sebagai fallback atau gambar pengganti ketika avatar pengguna
  /// tidak tersedia.
  static const String defaultAvatarUrl = "https://via.placeholder.com/200";

  /// API Key yang didapat dari akun TMDB Developer
  ///
  /// Digunakan untuk autentikasi saat melakukan permintaan ke API TMDB.
  /// Token ini diberikan oleh TMDB setelah registrasi di akun Developer mereka.
  static const String token =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhM2I1ZjUwYTE5NjRiMjBhZjcyNTQxYWM0Y2Y3ZjBmMCIsIm5iZiI6MTY2NzUwMDA0MC43OTAwMDAyLCJzdWIiOiI2MzY0MDgwODBjM2VjODAwOTBiNjg4MWQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.UNDeT6fT-MEgv1BG3DqMFPEHQtMfZtoFFpAOWkXmKTY";

  /// Timeout untuk request API (dalam milidetik)
  ///
  /// Menentukan batas waktu (timeout) untuk setiap request API ke TMDB.
  /// Jika permintaan API tidak mendapatkan respon dalam waktu yang ditentukan,
  /// maka permintaan tersebut akan gagal.
  static const int apiTimeout = 15000; // 15 detik
}
