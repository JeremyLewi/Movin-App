import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/config/app_config.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/core/utils/text_style.dart';
import 'package:flutter_movie_app/providers/home_provider.dart';
import 'package:flutter_movie_app/ui/screens/detail_screen.dart';
import 'package:flutter_movie_app/ui/widgets/movie_card.dart';
import 'package:flutter_movie_app/ui/widgets/movie_carousel.dart';
import 'package:provider/provider.dart';

/// Layar utama aplikasi yang menampilkan daftar film yang sedang tayang, film populer, dan avatar pengguna.
/// Menggunakan [HomeProvider] untuk mengambil dan menampilkan data film.
/// Layar ini juga memiliki navigasi ke detail film saat film dipilih.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil fetchAllMoviesAndLists untuk mengambil data film setelah layar di-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false)
          .fetchAllMoviesAndLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyles.blackColors,
        leading: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        title: Image.asset(
          AppStrings.logo,
          height: 40,
        ),
        centerTitle: true,
        actions: [
          // Avatar pengguna yang ditampilkan di sebelah kanan AppBar
          CircleAvatar(
            radius: 20, // Atur ukuran sesuai kebutuhan
            backgroundColor: Colors.grey[800], // Background saat loading
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: AppConfig.defaultAvatarUrl,
                width: 40, // Sesuaikan dengan ukuran avatar
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.grey[700], // Placeholder warna abu-abu
                  child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 40,
                  height: 40,
                  color: Colors.black,
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan film yang sedang tayang (Now Playing)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(AppStrings.nowPlaying,
                      style: TextStyles.titleTextMedium),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 550, child: MovieCarousel()),

                // Menampilkan film populer
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.popular,
                          style: TextStyles.titleTextMedium),
                      const SizedBox(height: 28),
                      SizedBox(
                        height: 340,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.popularMovies.length,
                          itemBuilder: (context, index) {
                            final movie = provider.popularMovies[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(movieId: movie.id!),
                                    ),
                                  );
                                },
                                child: MovieCard(
                                  imageUrl:
                                      "${AppConfig.imageBaseUrl}${AppConfig.imageSizeMedium}${movie.posterPath}",
                                  title: movie.title!,
                                  year: movie.releaseDate!.year.toString(),
                                  rating: movie.voteAverage!,
                                  height: 220,
                                  width: 170,
                                  movieId: movie.id!,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
