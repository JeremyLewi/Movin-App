import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/config/app_config.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/providers/detail_provider.dart';
import 'package:flutter_movie_app/ui/widgets/movie_card.dart';
import 'package:provider/provider.dart';

/// Layar detail film yang menampilkan informasi lengkap mengenai film
/// termasuk poster, judul, rating, tanggal rilis, genre, sinopsis, dan film yang mirip.
/// Menggunakan [DetailProvider] untuk mengambil data film dan menampilkan UI yang sesuai.
class DetailScreen extends StatefulWidget {
  final int movieId;

  /// Konstruktor untuk [DetailScreen].
  ///
  /// [movieId] adalah ID film yang digunakan untuk mengambil detail film.
  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil fetchAllDetails untuk mengambil data detail film setelah layar di-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DetailProvider>(context, listen: false)
          .fetchAllDetails(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<DetailProvider>(context);

    return Scaffold(
      backgroundColor: ColorStyles.blackColors,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: detailProvider.isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Menampilkan indikator loading
          : detailProvider.hasError
              ? const Center(
                  child: Text(AppStrings.errorFetchingMovieDetail,
                      style: TextStyle(
                          color: Colors.white))) // Menampilkan pesan error
              : _buildMovieDetails(detailProvider), // Menampilkan detail film
    );
  }

  /// Membuat tampilan detail film.
  ///
  /// Fungsi ini menampilkan informasi lengkap mengenai film seperti poster,
  /// judul, rating, tanggal rilis, genre, dan sinopsis.
  Widget _buildMovieDetails(DetailProvider provider) {
    final movieDetail = provider.movieDetail!;
    final posterImage =
        "${AppConfig.imageBaseUrl}${AppConfig.imageSizeMedium}${movieDetail.posterPath}";
    final title = movieDetail.title ?? 'No Title';
    final rating = movieDetail.voteAverage?.toString() ?? '0';
    final releaseDate = movieDetail.releaseDate?.year.toString() ?? '';
    final genres = movieDetail.genres != null
        ? movieDetail.genres!.map((genre) => genre.name).join(', ')
        : 'Unknown';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: posterImage,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 120,
                      height: 180,
                      color: Colors.grey[800], // Placeholder warna abu-abu
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 120,
                      height: 180,
                      color: Colors.black,
                      child: const Icon(Icons.broken_image,
                          color: Colors.white, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('$releaseDate • $genres',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(AppStrings.synopsis),
            const SizedBox(height: 20),
            Text(
              movieDetail.overview ?? AppStrings.noOverviewAvailable,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle(AppStrings.similarMovies),
            const SizedBox(height: 20),
            _buildSimilarMovies(provider), // Menampilkan daftar film mirip
          ],
        ),
      ),
    );
  }

  /// Membuat tampilan judul untuk setiap bagian.
  ///
  /// [title] adalah teks yang digunakan sebagai judul bagian, seperti "Synopsis" atau "Similar Movies".
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Menampilkan daftar film yang mirip dengan film yang sedang ditampilkan.
  ///
  /// Fungsi ini menampilkan daftar film mirip dalam bentuk horizontal menggunakan
  /// [ListView.builder]. Jika tidak ada film mirip, menampilkan pesan "No similar movies found".
  Widget _buildSimilarMovies(DetailProvider provider) {
    if (provider.similarMovies.isEmpty) {
      return const Center(
        child: Text("No similar movies found",
            style: TextStyle(color: Colors.white)),
      );
    }

    return SizedBox(
      height: 340,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.similarMovies.length,
        itemBuilder: (context, index) {
          final movie = provider.similarMovies[index];

          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(movieId: movie.id!),
                  ),
                );
              },
              child: MovieCard(
                imageUrl:
                    "${AppConfig.imageBaseUrl}${AppConfig.imageSizeMedium}${movie.posterPath}",
                title: movie.title ?? "No Title",
                year: movie.releaseDate?.year.toString() ??
                    "Unknown", // Pastikan format tanggal sesuai
                rating: movie.voteAverage ?? 0.0,
                height: 220,
                width: 170,
                movieId: movie.id ?? 0,
              ),
            ),
          );
        },
      ),
    );
  }
}
