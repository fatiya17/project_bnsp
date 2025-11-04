// import 'package:flutter/material.dart';
// import '../../core/routes/routes.dart';
// import '../../models/user_model.dart';
// import '../../services/api_service.dart';
// import '../../widgets/wisata_card.dart';
// import '../../widgets/home_header.dart';
// import '../../widgets/search_bar_widget.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final ApiService _apiService = ApiService();
//   final TextEditingController _searchController = TextEditingController();

//   List<ProductModel> _products = [];
//   List<ProductModel> _filteredProducts = [];
//   bool _isLoading = true;
//   String _error = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   Future<void> _loadProducts() async {
//     setState(() {
//       _isLoading = true;
//       _error = '';
//     });

//     try {
//       final products = await _apiService.getProducts();
//       setState(() {
//         _products = products;
//         _filteredProducts = products;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   void _filterProducts(String query) {
//     final filtered = _products
//         .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     setState(() {
//       _filteredProducts = filtered;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: _loadProducts,
//           child: Column(
//             children: [
//               // Header
//               HomeHeader(
//                 username: "Fatiya",
//                 onNotificationTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Belum ada notifikasi")),
//                   );
//                 },
//               ),

//               // Search Bar
//               SearchBarWidget(
//                 controller: _searchController,
//                 onChanged: _filterProducts,
//                 onFilterTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Fitur filter coming soon")),
//                   );
//                 },
//               ),

//               // Konten Produk
//               Expanded(child: _buildBody()),
//             ],
//           ),
//         ),
//       ),

//       // Tombol Tambah Data
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Fitur tambah data coming soon')),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_error.isNotEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
//             const SizedBox(height: 16),
//             Text('Error: $_error'),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _loadProducts,
//               child: const Text('Coba Lagi'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_filteredProducts.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade400),
//             const SizedBox(height: 16),
//             const Text('Produk tidak ditemukan'),
//           ],
//         ),
//       );
//     }

//     // Daftar produk
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _filteredProducts.length,
//       itemBuilder: (context, index) {
//         final product = _filteredProducts[index];
//         return ProductCard(
//           product: product,
//           onTap: () {
//             Navigator.pushNamed(
//               context,
//               AppRoutes.detail,
//               arguments: {
//                 'id': product.id,
//                 'name': product.name,
//                 'description': product.description,
//                 'price': product.price,
//                 'image': product.image,
//                 'stock': product.stock,
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
