import 'package:flutter/material.dart';
import '../layout/bottom_nav_bar.dart';
import 'app_drawer.dart';
import '../pages/home/home_page.dart';
import '../pages/cart/cart_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/product/add_product_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    AddProductPage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      drawer: AppDrawer(
        currentIndex: _currentIndex,
        onItemTapped: _onTabTapped, // Gunakan fungsi yang sama dengan BottomNavBar
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
