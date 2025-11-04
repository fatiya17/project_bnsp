import 'package:flutter/material.dart';
import '../../core/routes/routes.dart';
import '../../services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus(); // Ganti fungsi navigasi
  }

  Future<void> _checkAuthStatus() async {
    // Tunggu 2 detik untuk efek splash
    await Future.delayed(const Duration(seconds: 2));

    final authService = AuthService();
    final token = await authService.getToken();

    if (mounted) {
      if (token != null) {
        // Jika ada token, coba ambil data user
        final user = await authService.getCurrentUser();
        if (user != null) {
          // Token valid, user ada, masuk ke menu utama
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        } else {
          // Token mungkin kadaluarsa, ke login
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      } else {
        // Tidak ada token, ke login
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI bisa tetap sama, tapi ganti icon dan teks
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withAlpha(179),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined, // Ganti Icon
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Info Wisata', // Ganti Teks
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tugas Praktik JMP', // Ganti Teks
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}