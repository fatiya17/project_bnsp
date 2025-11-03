import 'package:flutter/material.dart';
import '../../pages/splash/splash_page.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/register_page.dart';
import '../../pages/home/home_page.dart';
import '../../pages/product/detail_page.dart';
import '../../layout/main_layout.dart';
import '../../pages/product/add_product_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String main = '/main';
  static const String addProduct = '/add-product';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case main:
        return MaterialPageRoute(builder: (_) => MainLayout());

      case AppRoutes.addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductPage());

      case detail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => DetailPage(data: args));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} tidak ditemukan')),
          ),
        );
    }
  }
}
