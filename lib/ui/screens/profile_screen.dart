import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/config/app_config.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/services/api_service.dart';
import 'package:flutter_movie_app/ui/widgets/movie_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Layar profil pengguna yang menampilkan informasi pengguna,
/// daftar film favorit, dan daftar film yang ada di watchlist.
/// Menggunakan [ApiService] untuk mengambil data terkait akun dan film.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Future<Map<String, dynamic>>? _profileDataFuture;

  @override
  void initState() {
    super.initState();
    // Mengambil data profil pengguna setelah widget diinisialisasi
    _profileDataFuture = _fetchProfileData();
  }

  /// Mengambil data profil pengguna, termasuk detail akun, film favorit, dan film dalam watchlist.
  Future<Map<String, dynamic>> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    final accountId = prefs.getString('account_id');

    if (sessionId == null || accountId == null) {
      return {};
    }

    // Mengambil detail akun, film favorit, dan film dalam watchlist
    final accountDetails =
        await _apiService.fetchAccountDetailsById(accountId, sessionId);
    final favoriteMovies =
        await _apiService.fetchFavoriteMovies(accountId, sessionId);
    final watchlistMovies =
        await _apiService.fetchWatchlistMovies(accountId, sessionId);

    return {
      'accountDetails': accountDetails,
      'favoriteMovies': favoriteMovies,
      'watchlistMovies': watchlistMovies,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.blackColors,
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                AppStrings.errorFetchingProfile,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!;
          final accountData =
              data['accountDetails'] as Map<String, dynamic>? ?? {};
          final favoriteMovies = data['favoriteMovies'] as List<dynamic>? ?? [];
          final watchlistMovies =
              data['watchlistMovies'] as List<dynamic>? ?? [];

          // Ambil username dan avatar URL
          final String username = accountData['username'] ?? "N/A";
          String avatarUrl = AppConfig.defaultAvatarUrl;

          // Periksa apakah profile_path tersedia untuk avatar
          if (accountData['avatar_path'] != null) {
            avatarUrl =
                '${AppConfig.imageBaseUrl}${AppConfig.imageSizeSmall}${accountData['avatar_path']}';
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profil Section
                  CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        Colors.grey[800], // Warna latar belakang saat loading
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width:
                            120, // Sesuaikan dengan diameter avatar (radius * 2)
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey[700], // Placeholder warna abu-abu
                          child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.black,
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Favorite Movies Section
                  _buildSectionTitle(AppStrings.favoriteMoviesTitle),
                  _buildMovieList(favoriteMovies),

                  // Watchlist Movies Section
                  _buildSectionTitle(AppStrings.watchlistMoviesTitle),
                  _buildMovieList(watchlistMovies),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Membuat judul untuk setiap bagian (misalnya: "Film Favorit", "Watchlist").
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Membuat tampilan daftar film (favorit atau watchlist).
  ///
  /// Jika daftar film kosong, menampilkan pesan "No Movies Available".
  /// Jika ada film, menampilkan daftar film menggunakan [MovieCard].
  Widget _buildMovieList(List<dynamic> movies) {
    return movies.isEmpty
        ? const Center(
            child: Text(
              AppStrings.noMoviesAvailable,
              style: TextStyle(color: Colors.white),
            ),
          )
        : SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final movieId = movie['id'];
                final title = movie['title'] ?? "No Title";
                final year = (movie['release_date'] ?? "N/A").substring(0, 4);
                final posterPath = movie['poster_path'];
                final posterUrl = posterPath != null
                    ? "${AppConfig.imageBaseUrl}${AppConfig.imageSizeSmall}$posterPath"
                    : AppConfig.defaultMoviePoster;
                final rating =
                    (movie['vote_average'] as num?)?.toDouble() ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MovieCard(
                    movieId: movieId, // ✅ Movie ID dikirim ke MovieCard
                    imageUrl: posterUrl,
                    title: title,
                    year: year,
                    rating: rating,
                    width: 150,
                    height: 225,
                  ),
                );
              },
            ),
          );
  }
}
