import 'package:flutter/material.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kelas `TextStyles` menyimpan berbagai gaya teks (text styles) yang digunakan di seluruh aplikasi.
/// Kelas ini bertujuan untuk mengelola gaya teks secara konsisten dan memudahkan pengelolaan berbagai
/// jenis teks dalam aplikasi, seperti judul, subjudul, dan teks biasa.
class TextStyles {
  /// Gaya teks untuk judul dengan ukuran medium.
  ///
  /// Gaya ini digunakan untuk menampilkan teks judul dengan ukuran 20 piksel, font-weight sedang (600),
  /// dan warna putih. Menggunakan font dari Google Fonts dengan font keluarga Poppins.
  static TextStyle titleTextMedium = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: ColorStyles.whiteColors,
      fontFamily: GoogleFonts.poppins().fontFamily);

  /// Gaya teks untuk judul dengan ukuran kecil.
  ///
  /// Gaya ini digunakan untuk menampilkan teks judul dengan ukuran 15 piksel, font-weight sedang (600),
  /// dan warna putih. Menggunakan font dari Google Fonts dengan font keluarga Poppins.
  static TextStyle titleTextSmall = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: ColorStyles.whiteColors,
      fontFamily: GoogleFonts.poppins().fontFamily);

  /// Gaya teks untuk subjudul.
  ///
  /// Gaya ini digunakan untuk menampilkan teks subjudul dengan ukuran 15 piksel, font-weight ringan (400),
  /// dan warna netral yang sedikit lebih gelap. Menggunakan font dari Google Fonts dengan font keluarga Poppins.
  static TextStyle subTitleText = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: ColorStyles.neutral600,
      fontFamily: GoogleFonts.poppins().fontFamily);

  /// Gaya teks untuk teks reguler.
  ///
  /// Gaya ini digunakan untuk menampilkan teks biasa dengan ukuran 14 piksel, font-weight sangat ringan (300),
  /// dan warna netral yang lebih pucat. Menggunakan font dari Google Fonts dengan font keluarga Poppins.
  static TextStyle regularText = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: ColorStyles.neutral500,
      fontFamily: GoogleFonts.poppins().fontFamily);
}
