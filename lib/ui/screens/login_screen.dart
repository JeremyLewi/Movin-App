import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/core/utils/color_style.dart';
import 'package:flutter_movie_app/core/utils/text_style.dart';
import 'package:flutter_movie_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

/// Layar login untuk aplikasi yang memungkinkan pengguna untuk login menggunakan
/// TMDB API. Layar ini menampilkan pesan sambutan, deskripsi login, dan tombol
/// untuk melakukan autentikasi melalui TMDB.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: ColorStyles.blackColors,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menampilkan logo aplikasi
              Image.asset(
                AppStrings.logo,
                height: 80,
              ),
              const SizedBox(height: 20),

              // Menampilkan pesan sambutan
              const Text(
                AppStrings.welcomeMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Menampilkan deskripsi login
              const Text(
                AppStrings.loginDescription,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Menampilkan indikator loading atau tombol login
              _isLoading
                  ? const CircularProgressIndicator(
                      color:
                          Colors.deepPurple) // Jika loading, tampilkan spinner
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        // Mengubah status loading saat tombol ditekan
                        setState(() {
                          _isLoading = true;
                        });

                        // Memanggil fungsi autentikasi
                        bool success = await authProvider
                            .createRequestTokenAndAuthenticate();

                        // Setelah proses autentikasi selesai, periksa hasilnya
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          if (success) {
                            // Jika berhasil, arahkan pengguna ke halaman utama
                            Navigator.pushReplacementNamed(
                                context, AppStrings.mainScreenRoute);
                          } else {
                            // Jika gagal, tampilkan pesan kesalahan
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppStrings.authFailedMessage),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        });

                        // Mengubah status loading setelah autentikasi selesai
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Text(
                        AppStrings.loginButton,
                        style: TextStyles.titleTextSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
