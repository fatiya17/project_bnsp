import 'package:flutter/material.dart';
import '../layout/bottom_nav_bar.dart';
// Halaman baru
import '../pages/kota/pilih_kota_page.dart';
import '../pages/wisata/wisata_list_page.dart';
import '../pages/wisata/favorit_page.dart';
import '../pages/profile/profile_page.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // (PDF) Ganti daftar halaman
  final List<Widget> _pages = [
    const PilihKotaPage(), // Index 0: Halaman Pilih Kota
    const WisataListPage(), // Index 1: Halaman Daftar Wisata (Semua)
    const FavoritPage(), // Index 2: Halaman Daftar Favorite
    const ProfilePage(), // Index 3: Profil (dengan info PDF)
  ];

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // Drawer bisa dihapus jika tidak diperlukan,
      // tapi file 'app_drawer.dart' tidak perlu diubah jika masih ingin dipakai.
      // drawer: AppDrawer(
      //   currentIndex: _currentIndex,
      //   onItemTapped: _onTabTapped,
      // ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}