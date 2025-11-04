// // Lokasi: lib/widgets/app_drawer.dart
// // (FILE BARU)

// import 'package:flutter/material.dart';
// import '../models/user_model.dart';
// import '../services/auth_service.dart';
// import '../core/routes/routes.dart';

// class AppDrawer extends StatefulWidget {
//   final int currentIndex;
//   final Function(int) onItemTapped;

//   const AppDrawer({
//     super.key,
//     required this.currentIndex,
//     required this.onItemTapped,
//   });

//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer> {
//   UserModel? _user;
//   final AuthService _authService = AuthService();

//   @override
//   void initState() {
//     super.initState();
//     _loadUser();
//   }

//   // Mengambil data pengguna untuk ditampilkan di header
//   Future<void> _loadUser() async {
//     final user = await _authService.getCurrentUser();
//     if (mounted) {
//       setState(() {
//         _user = user;
//       });
//     }
//   }

//   // Menampilkan dialog konfirmasi logout (mirip di ProfilePage)
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Apakah kamu yakin ingin keluar dari akun ini?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Tutup dialog
//               // Lakukan logout dan arahkan ke halaman login
//               _authService.logout();
//               Navigator.pushReplacementNamed(context, AppRoutes.login);
//             },
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           _buildHeader(context, theme),
//           _buildMenuItem(
//             context: context,
//             icon: Icons.home_outlined,
//             text: 'Home',
//             index: 0,
//           ),
//           _buildMenuItem(
//             context: context,
//             icon: Icons.add_circle_outline_rounded,
//             text: 'Tambah Produk',
//             index: 1,
//           ),
//           _buildMenuItem(
//             context: context,
//             icon: Icons.shopping_cart_outlined,
//             text: 'Keranjang',
//             index: 2,
//           ),
//           _buildMenuItem(
//             context: context,
//             icon: Icons.person_outline,
//             text: 'Profil',
//             index: 3,
//           ),
//           const Divider(),
//           ListTile(
//             leading: Icon(Icons.logout, color: theme.colorScheme.error),
//             title: const Text('Logout'),
//             onTap: () {
//               Navigator.pop(context); // Tutup drawer
//               _showLogoutDialog(context); // Tampilkan konfirmasi
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget untuk header drawer (menampilkan info user)
//   Widget _buildHeader(BuildContext context, ThemeData theme) {
//     if (_user == null) {
//       // Tampilan loading selagi mengambil data user
//       return DrawerHeader(
//         decoration: BoxDecoration(color: theme.primaryColor),
//         child: const Center(
//           child: CircularProgressIndicator(color: Colors.white),
//         ),
//       );
//     }
//     return UserAccountsDrawerHeader(
//       accountName: Text(
//         _user!.name,
//         style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
//       ),
//       accountEmail: Text(
//         _user!.email,
//         style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
//       ),
//       currentAccountPicture: CircleAvatar(
//         backgroundColor: theme.colorScheme.secondary,
//         backgroundImage:
//             _user!.avatar != null ? NetworkImage(_user!.avatar!) : null,
//         child: _user!.avatar == null
//             ? Text(
//                 _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : 'U',
//                 style: const TextStyle(fontSize: 40.0, color: Colors.white),
//               )
//             : null,
//       ),
//       decoration: BoxDecoration(
//         color: theme.primaryColor,
//       ),
//     );
//   }

//   // Widget untuk item menu
//   Widget _buildMenuItem({
//     required BuildContext context,
//     required IconData icon,
//     required String text,
//     required int index,
//   }) {
//     final bool isSelected = widget.currentIndex == index;
//     final color = isSelected ? Theme.of(context).primaryColor : null;

//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(text, style: TextStyle(color: color)),
//       selected: isSelected,
//       onTap: () {
//         Navigator.pop(context); // Tutup drawer
//         widget.onItemTapped(index); // Panggil fungsi ganti halaman
//       },
//     );
//   }
// }