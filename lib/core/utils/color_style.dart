import 'package:flutter/material.dart';

/// Kelas `ColorStyles` menyimpan berbagai konstanta warna yang digunakan di seluruh aplikasi.
/// Kelas ini bertujuan untuk mengelola dan menyatukan semua warna yang digunakan agar lebih konsisten
/// dan mudah dikelola. Semua warna yang digunakan pada UI aplikasi didefinisikan di sini.
class ColorStyles {
  /// Warna putih yang digunakan dalam aplikasi.
  ///
  /// Warna ini dapat digunakan untuk latar belakang atau elemen-elemen UI yang membutuhkan
  /// warna terang atau netral.
  static const Color whiteColors = Color(0xFFEFECEC);

  /// Warna hitam yang digunakan dalam aplikasi.
  ///
  /// Warna ini digunakan untuk teks atau elemen-elemen UI yang membutuhkan warna gelap atau kontras.
  static const Color blackColors = Color(0xFF1B1919);

  /// Warna netral terang (putih murni) yang digunakan untuk latar belakang atau elemen UI lainnya.
  static const Color neutral50 = Color(0xFFFFFFFF);

  /// Warna netral dengan sedikit abu-abu yang bisa digunakan untuk teks atau elemen UI dengan kontras rendah.
  static const Color neutral500 = Color(0xFF94A2B8);

  /// Warna netral dengan sedikit biru yang bisa digunakan untuk elemen UI sekunder atau teks.
  static const Color neutral600 = Color(0xFF64738B);

  /// Warna biru tua yang digunakan sebagai warna utama aplikasi.
  ///
  /// Warna ini digunakan untuk elemen-elemen utama seperti tombol, header, dan ikon-ikon penting.
  static const Color primaryColors = Color(0xFF084E85);

  /// Warna oranye yang digunakan untuk menandakan peringatan atau status yang perlu perhatian lebih.
  static const Color warning400 = Color(0xFFF1A62D);
}
