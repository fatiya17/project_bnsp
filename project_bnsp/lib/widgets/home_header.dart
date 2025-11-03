import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String username;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    required this.username,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: tombol drawer + teks sapaan
          Row(
            children: [
              // Tombol menu drawer
              // Builder(
              //   builder: (context) => IconButton(
              //     icon: const Icon(Icons.menu, color: Colors.white),
              //     onPressed: () => Scaffold.of(context).openDrawer(),
              //   ),
              // ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hai, $username 👋',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Selamat datang kembali!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha:0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tombol notifikasi kanan
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: onNotificationTap,
          ),
        ],
      ),
    );
  }
}
