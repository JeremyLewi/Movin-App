import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_movie_app/core/constants/app_strings.dart';
import 'package:flutter_movie_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Kelas `AuthProvider` mengelola otentikasi pengguna dalam aplikasi.
/// Kelas ini berfungsi untuk membuat token permintaan (request token),
/// meluncurkan URL untuk otentikasi pengguna, dan membuat sesi pengguna.
/// Selain itu, kelas ini juga menyimpan sessionId dan accountId di SharedPreferences
/// untuk digunakan di aplikasi selanjutnya.
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  String? _sessionId;
  String? _accountId;

  /// Mendapatkan sessionId saat ini.
  String? get sessionId => _sessionId;

  /// Mendapatkan accountId saat ini.
  String? get accountId => _accountId;

  /// Membuat request token baru dan mengautentikasi pengguna.
  ///
  /// Fungsi ini memulai proses autentikasi dengan memanggil API untuk
  /// mendapatkan request token, kemudian meluncurkan URL untuk otentikasi
  /// pengguna di dalam aplikasi. Setelah itu, sesi pengguna dibuat dengan
  /// request token tersebut.
  ///
  /// Mengembalikan nilai `true` jika proses berhasil, atau `false` jika gagal.
  Future<bool> createRequestTokenAndAuthenticate() async {
    final tokenResponse = await _apiService.fetchRequestToken();

    if (tokenResponse.isEmpty || tokenResponse['request_token'] == null) {
      return false;
    }

    final String requestToken = tokenResponse['request_token'];
    final authUrl = "${AppStrings.authUrlBase}$requestToken";

    bool launched = false;
    try {
      launched =
          await launchUrl(Uri.parse(authUrl), mode: LaunchMode.inAppWebView);
      // ignore: empty_catches
    } catch (e) {}

    if (!launched) {
      return false;
    }

    return await _attemptCreateSession(requestToken).timeout(
      const Duration(minutes: 2),
      onTimeout: () => false,
    );
  }

  /// Mencoba untuk membuat sesi (session) dengan request token.
  ///
  /// Fungsi ini mencoba untuk membuat sesi beberapa kali (maksimal 10 kali),
  /// jika sesi berhasil dibuat maka sesi pengguna akan disimpan dan fungsi ini
  /// akan mengembalikan nilai `true`. Jika gagal, mengembalikan nilai `false`.
  ///
  /// [requestToken] adalah token yang digunakan untuk membuat sesi.
  Future<bool> _attemptCreateSession(String requestToken) async {
    const int maxRetries = 10;
    const Duration delay = Duration(seconds: 3);

    for (int i = 0; i < maxRetries; i++) {
      await Future.delayed(delay);

      final sessionResponse = await _apiService.createSession(requestToken);
      if (sessionResponse.isNotEmpty && sessionResponse['session_id'] != null) {
        _sessionId = sessionResponse['session_id'];
        return await _handleSuccessfulSession();
      }
    }

    return false;
  }

  /// Menangani sesi yang berhasil dibuat dan menyimpan sessionId serta accountId.
  ///
  /// Fungsi ini dipanggil setelah sesi berhasil dibuat, mengambil detail akun
  /// menggunakan sessionId, dan menyimpan sessionId serta accountId di SharedPreferences.
  /// Fungsi ini juga memberitahukan listener dengan `notifyListeners()` untuk memperbarui UI.
  Future<bool> _handleSuccessfulSession() async {
    final accountResponse = await _apiService.fetchAccountDetails(_sessionId!);

    if (accountResponse.isNotEmpty && accountResponse['id'] != null) {
      _accountId = accountResponse['id'].toString();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', _sessionId!);
    if (_accountId != null) {
      await prefs.setString('account_id', _accountId!);
    }

    notifyListeners();
    await _closeBrowser();

    return true;
  }

  /// Menutup browser yang digunakan untuk autentikasi pengguna.
  ///
  /// Fungsi ini dipanggil untuk menutup browser in-app setelah proses autentikasi
  /// selesai atau jika terjadi kegagalan.
  Future<void> _closeBrowser() async {
    await closeInAppWebView();
  }
}
