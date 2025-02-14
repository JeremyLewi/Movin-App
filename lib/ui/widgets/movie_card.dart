import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/services/api_service.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/core/utils/text_style.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Widget `MovieCard` digunakan untuk menampilkan informasi tentang sebuah film,
/// termasuk gambar poster, judul, tahun rilis, rating, dan menyediakan opsi
/// untuk menambahkan film ke daftar favorit atau watchlist.
class MovieCard extends StatefulWidget {
  final int movieId; // ID film untuk keperluan navigasi dan pengelolaan data
  final String imageUrl; // URL gambar poster film
  final String title; // Judul film
  final String year; // Tahun rilis film
  final double rating; // Rating film
  final double? height; // Tinggi dari widget, jika diperlukan
  final double? width; // Lebar dari widget, jika diperlukan

  const MovieCard({
    super.key,
    required this.movieId,
    required this.imageUrl,
    required this.title,
    required this.year,
    required this.rating,
    this.height,
    this.width,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isFavorite = false; // Status apakah film ini ada di daftar favorit
  bool _isWatchlist = false; // Status apakah film ini ada di daftar watchlist

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();

    // Mengecek apakah film sudah ada di daftar favorit
    apiService.isFavoriteMovie(widget.movieId).then((isFavorite) {
      setState(() {
        _isFavorite = isFavorite;
      });
    });

    // Mengecek apakah film sudah ada di daftar watchlist
    apiService.isWatchlistMovie(widget.movieId).then((isWatchlist) {
      setState(() {
        _isWatchlist = isWatchlist;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 200, // Lebar container film, bisa disesuaikan
      decoration: BoxDecoration(
        color: ColorStyles.blackColors,
        borderRadius: BorderRadius.circular(12), // Membuat sudut melengkung
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menampilkan gambar poster film menggunakan CachedNetworkImage
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              width: widget.width ?? 200, // Ukuran gambar poster
              height: widget.height ?? 300,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: widget.height ?? 300,
                width: widget.width ?? 200,
                color: Colors.grey[800], // Placeholder warna abu-abu
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Menampilkan informasi film seperti judul, tahun, dan rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: widget.width ?? 200,
                      child: Text(
                        widget.title,
                        style: TextStyles.titleTextSmall.copyWith(
                          color: ColorStyles.whiteColors,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Menghindari overflow
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.year,
                          style: TextStyles.subTitleText.copyWith(fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Text('•', style: TextStyles.subTitleText),
                        const SizedBox(width: 8),
                        const Icon(
                          TablerIcons.star_filled,
                          color: ColorStyles.warning400,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating.toString(),
                          style: TextStyles.regularText.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Menu untuk menambah film ke watchlist atau favorit
              PopupMenuButton<int>(
                onSelected: (value) async {
                  final apiService = ApiService();
                  if (value == 0) {
                    // Jika opsi watchlist dipilih
                    if (!_isWatchlist) {
                      await apiService.addWatchlistMovie(widget.movieId);
                      setState(() {
                        _isWatchlist = true;
                      });
                    }
                  } else if (value == 1) {
                    // Jika opsi favorit dipilih
                    if (!_isFavorite) {
                      await apiService.addFavoriteMovie(widget.movieId);
                      setState(() {
                        _isFavorite = true;
                      });
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      _isWatchlist
                          ? AppStrings.alreadyInWatchlist
                          : AppStrings.addToWatchlist,
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      _isFavorite
                          ? AppStrings.alreadyInFavorites
                          : AppStrings.addToFavorites,
                    ),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: ColorStyles.whiteColors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
