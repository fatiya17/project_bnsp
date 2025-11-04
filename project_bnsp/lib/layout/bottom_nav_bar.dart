import 'package:flutter/material.dart';
import '../core/theme/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 70,
      elevation: 8,
      backgroundColor: Theme.of(context).colorScheme.surface,
      indicatorColor: AppTheme.primaryColor.withAlpha((255 * 0.15).round()),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      
      // (PDF) Ganti destinasi
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.location_city_outlined),
          selectedIcon: Icon(Icons.location_city, color: AppTheme.primaryColor),
          label: 'Kota', // Halaman Pilih Kota
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore, color: AppTheme.primaryColor),
          label: 'Wisata', // Halaman Daftar Wisata
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite, color: AppTheme.primaryColor),
          label: 'Favorit', // Halaman Daftar Favorite
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: AppTheme.primaryColor),
          label: 'Profil',
        ),
      ],
    );
  }
}