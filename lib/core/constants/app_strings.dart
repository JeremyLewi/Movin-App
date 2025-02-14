/// Kelas `AppStrings` menyimpan semua string konstanta yang digunakan di seluruh aplikasi.
/// Kelas ini digunakan untuk mengelola teks-teks yang ditampilkan pada UI, pesan kesalahan,
/// dan string lainnya yang bersifat statis dan digunakan berulang-ulang.
class AppStrings {
  // General
  /// Nama aplikasi yang ditampilkan di UI.
  static const String appName = "MOVIN SHOW";

  /// Pesan sambutan yang ditampilkan pada layar utama aplikasi.
  static const String welcomeMessage = "Welcome to MOVIN SHOW";

  /// Deskripsi yang menjelaskan aplikasi saat pengguna pertama kali login.
  static const String loginDescription =
      "Discover movies, Popular movies, and more!\nLogin to continue your journey.";

  /// Teks yang ditampilkan pada tombol login.
  static const String loginButton = "Login with TMDB";

  /// Pesan yang ditampilkan jika proses otentikasi gagal.
  static const String authFailedMessage = "Authentication failed";

  /// Judul untuk daftar film yang sedang tayang.
  static const String nowPlaying = "Now Playing";

  /// Judul untuk daftar film populer.
  static const String popular = "Popular Movies";

  // Movie Details
  /// Pesan yang ditampilkan jika terjadi kesalahan saat mengambil detail film.
  static const String errorFetchingMovieDetail = "Error fetching movie detail";

  /// Pesan yang ditampilkan jika tidak ada overview yang tersedia untuk film.
  static const String noOverviewAvailable = "No overview available.";

  /// Pesan yang ditampilkan jika tidak ada film yang mirip ditemukan.
  static const String noSimilarMoviesFound = "No similar movies found";

  /// Teks yang ditampilkan pada tombol untuk menambahkan film ke daftar watchlist.
  static const String addToWatchlist = "Add to Watchlist";

  /// Teks yang ditampilkan pada tombol untuk melihat detail film.
  static const String viewDetails = "View Details";

  /// Pesan yang ditampilkan jika tanggal rilis film tidak diketahui.
  static const String unknownReleaseDate = "Unknown Release Date";

  /// Pesan yang ditampilkan jika rating film tidak tersedia.
  static const String unknownRating = "N/A";

  /// Pesan yang ditampilkan jika terjadi kesalahan saat mengambil daftar film.
  static const String errorFetchingMovies = "Error fetching movies";

  /// Pesan yang ditampilkan jika tidak ada film yang tersedia.
  static const String noMoviesAvailable = "No movies available";

  /// Pesan yang ditampilkan saat film sedang dimuat.
  static const String loadingMovies = "Loading movies...";

  /// Pesan yang ditampilkan jika film sudah ada di daftar watchlist.
  static const String alreadyInWatchlist = "Already in Watchlist";

  /// Teks yang ditampilkan pada tombol untuk menambahkan film ke daftar favorit.
  static const String addToFavorites = "Add to Favorites";

  /// Pesan yang ditampilkan jika film sudah ada di daftar favorit.
  static const String alreadyInFavorites = "Already in Favorites";

  /// Judul untuk tampilan profil pengguna.
  static const String profileTitle = "Profile";

  /// Pesan yang ditampilkan jika terjadi kesalahan saat mengambil data profil.
  static const String errorFetchingProfile = "Error mengambil data profil";

  /// Judul untuk daftar film favorit pengguna.
  static const String favoriteMoviesTitle = "Favorite Movies";

  /// Judul untuk daftar film yang ada di watchlist pengguna.
  static const String watchlistMoviesTitle = "Watchlist Movies";

  // Section Titles
  /// Judul untuk bagian sinopsis film.
  static const String synopsis = "Synopsis";

  /// Judul untuk bagian film yang mirip dengan film yang sedang ditonton.
  static const String similarMovies = "Similar Movies";

  // URLs
  /// URL dasar untuk autentikasi pengguna melalui TMDB.
  static const String authUrlBase = "https://www.themoviedb.org/authenticate/";

  // Routes
  /// Rute untuk layar login.
  static const String loginRoute = "/login";

  /// Rute untuk layar utama aplikasi.
  static const String mainScreenRoute = "/main";

  /// Rute untuk layar home.
  static const String homeRoute = "/home";

  /// Rute untuk layar profil pengguna.
  static const String profileRoute = "/profile";

  // Image assets
  /// Lokasi file logo aplikasi yang digunakan dalam aplikasi.
  static const String logo = 'assets/images/logo.png';

  // Image URLs
  /// URL gambar avatar default yang digunakan saat avatar pengguna tidak tersedia.
  static const String defaultAvatarUrl =
      "https://xsgames.co/randomusers/assets/avatars/male/2.jpg";
}
