import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/config/app_config.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/core/utils/text_style.dart';
import 'package:flutter_movie_app/models/now_playing_model.dart';
import 'package:flutter_movie_app/providers/home_provider.dart';
import 'package:flutter_movie_app/ui/screens/detail_screen.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';

/// Widget `MovieCarousel` digunakan untuk menampilkan carousel film yang sedang tayang (now playing),
/// dengan kemampuan untuk otomatis berganti setiap beberapa detik dan memberikan informasi tambahan
/// tentang film seperti judul, rating, dan tahun rilis.
class MovieCarousel extends StatefulWidget {
  const MovieCarousel({super.key});

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  int _currentPage = 0; // Halaman saat ini dalam carousel
  int? _overlayIndex; // Indeks overlay aktif untuk menampilkan tombol tambahan
  late PageController _pageController; // Kontrol halaman carousel
  Timer? _autoSlideTimer; // Timer untuk otomatis berpindah halaman

  @override
  void initState() {
    super.initState();
    // Menginisialisasi PageController untuk carousel
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: _currentPage);

    // Timer untuk otomatis berpindah halaman setiap 5 detik
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final movieProvider = Provider.of<HomeProvider>(context, listen: false);
      if (movieProvider.nowPlayingMovies.isNotEmpty) {
        int nextPage = _currentPage + 1;
        if (nextPage >= movieProvider.nowPlayingMovies.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<HomeProvider>(context);
    final List<NowPlayingResult> nowPlayingMovies =
        movieProvider.nowPlayingMovies;
    final List<dynamic> favoriteMovies = movieProvider.favoriteMovies;
    final List<dynamic> watchlistMovies = movieProvider.watchlistMovies;

    return movieProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            alignment: Alignment.center,
            children: [
              // Menampilkan gambar poster film berdasarkan halaman yang aktif
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: nowPlayingMovies.isNotEmpty
                    ? Container(
                        key: ValueKey<String>(
                            nowPlayingMovies[_currentPage].posterPath!),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "${AppConfig.imageBaseUrl}${AppConfig.imageSizeMedium}${nowPlayingMovies[_currentPage].posterPath}",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[800],
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.black,
                                child: const Icon(Icons.broken_image,
                                    color: Colors.white, size: 50),
                              ),
                            ),
                            // Efek blur di belakang gambar untuk tampilan overlay
                            BackdropFilter(
                              filter: ImageFilter.blur(),
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              FractionallySizedBox(
                heightFactor: 0.85,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: nowPlayingMovies.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                      _overlayIndex =
                          null; // Menutup overlay saat berpindah halaman
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final movie = nowPlayingMovies[index];

                    final isFavorite = favoriteMovies
                        .any((favMovie) => favMovie['id'] == movie.id);
                    final isWatchlist = watchlistMovies.any(
                        (watchlistMovie) => watchlistMovie['id'] == movie.id);

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 350,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _overlayIndex =
                                      _overlayIndex == index ? null : index;
                                });
                              },
                              child: Stack(
                                children: [
                                  // Gambar poster film
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${AppConfig.imageBaseUrl}${AppConfig.imageSizeMedium}${movie.posterPath}"),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(32),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.3),
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Overlay yang muncul saat gambar di-tap
                                  if (_overlayIndex == index)
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Tombol untuk menambahkan ke watchlist
                                              ElevatedButton(
                                                onPressed: () {
                                                  isWatchlist
                                                      ? null
                                                      : movieProvider
                                                          .addToWatchlist(
                                                              movie.id!);
                                                },
                                                child: Text(
                                                  isWatchlist
                                                      ? AppStrings
                                                          .alreadyInWatchlist
                                                      : AppStrings
                                                          .addToWatchlist,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              // Tombol untuk melihat detail film
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailScreen(
                                                              movieId:
                                                                  movie.id!),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                    AppStrings.viewDetails),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Menampilkan judul film
                                    Text(
                                      movie.title!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.titleTextMedium
                                          .copyWith(
                                              color: ColorStyles.whiteColors),
                                    ),
                                    const SizedBox(height: 8),
                                    // Menampilkan informasi tahun dan rating
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            movie.releaseDate != null
                                                ? movie.releaseDate!.year
                                                    .toString()
                                                : AppStrings.unknownReleaseDate,
                                            style: TextStyles.subTitleText),
                                        const SizedBox(width: 8),
                                        Text('•',
                                            style: TextStyles.subTitleText),
                                        const SizedBox(width: 8),
                                        const Icon(TablerIcons.star_filled,
                                            color: ColorStyles.warning400,
                                            size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                            movie.voteAverage?.toString() ??
                                                AppStrings.unknownRating,
                                            style: TextStyles.regularText),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Tombol favorit
                              IconButton(
                                onPressed: () {
                                  if (!isFavorite) {
                                    movieProvider.addToFavorite(movie.id!);
                                  }
                                },
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : ColorStyles.whiteColors,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
  }
}
