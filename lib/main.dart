import 'package:flutter/material.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/providers/auth_provider.dart';
import 'package:flutter_movie_app/providers/detail_provider.dart';
import 'package:flutter_movie_app/providers/home_provider.dart';
import 'package:flutter_movie_app/ui/screens/home_screen.dart';
import 'package:flutter_movie_app/ui/screens/login_screen.dart';
import 'package:flutter_movie_app/ui/screens/main_screen.dart';
import 'package:flutter_movie_app/ui/screens/profile_screen.dart';
import 'package:provider/provider.dart';

/// Fungsi utama aplikasi yang menjalankan widget `MyApp`
/// dan mengatur penyediaan state dengan menggunakan `MultiProvider`
/// yang menyediakan beberapa provider untuk aplikasi.
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                AuthProvider()), // Menyediakan provider untuk autentikasi
        ChangeNotifierProvider(
            create: (_) =>
                HomeProvider()), // Menyediakan provider untuk data utama (film)
        ChangeNotifierProvider(
            create: (_) =>
                DetailProvider()), // Menyediakan provider untuk detail film
      ],
      child: const MyApp(),
    ),
  );
}

/// Kelas `MyApp` adalah widget utama aplikasi yang mengonfigurasi
/// tema dan rute aplikasi serta menampilkan layar pertama.
/// Aplikasi ini menggunakan `MaterialApp` dengan tema dan rute terstruktur.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'Flutter Movie App', // Judul aplikasi yang ditampilkan di bar aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple), // Menentukan tema warna aplikasi
        useMaterial3: true, // Mengaktifkan Material 3
        scaffoldBackgroundColor: ColorStyles
            .blackColors, // Mengatur latar belakang scaffold dengan warna gelap
      ),
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
      initialRoute: '/login', // Menentukan rute awal aplikasi
      routes: {
        AppStrings.loginRoute: (context) =>
            const LoginScreen(), // Rute menuju halaman login
        AppStrings.mainScreenRoute: (context) =>
            const MainScreen(), // Rute menuju halaman utama
        AppStrings.homeRoute: (context) =>
            const HomeScreen(), // Rute menuju halaman beranda
        AppStrings.profileRoute: (context) =>
            const ProfileScreen(), // Rute menuju halaman profil
      },
    );
  }
}
