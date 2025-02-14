import 'package:flutter/material.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/ui/screens/home_screen.dart';
import 'package:flutter_movie_app/ui/screens/profile_screen.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Layar utama aplikasi yang menampilkan dua tab utama: Beranda dan Profil.
/// Tab ini dapat dipilih melalui [BottomNavigationBar] untuk menavigasi antara layar beranda dan profil.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Inisialisasi index awal untuk tab yang aktif

  // Daftar halaman yang ditampilkan sesuai dengan tab yang dipilih
  final List<Widget> _pages = [
    const HomeScreen(), // Layar Beranda
    const ProfileScreen(), // Layar Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai dengan tab yang aktif
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Menampilkan bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Menentukan tab yang aktif
        onTap: (int index) {
          // Mengubah tab yang aktif berdasarkan input pengguna
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor:
            ColorStyles.blackColors, // Warna latar belakang BottomNavigationBar
        selectedItemColor: ColorStyles.whiteColors, // Warna item yang dipilih
        unselectedItemColor:
            ColorStyles.neutral600, // Warna item yang tidak dipilih
        showUnselectedLabels:
            true, // Menampilkan label pada item yang tidak dipilih
        type: BottomNavigationBarType
            .fixed, // Menggunakan tipe fixed agar semua item terlihat
        items: const [
          // Item pertama (Beranda)
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 28,
            ),
            label: 'Beranda',
          ),
          // Item kedua (Profil)
          BottomNavigationBarItem(
            icon: Icon(
              TablerIcons.user,
              size: 28,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
