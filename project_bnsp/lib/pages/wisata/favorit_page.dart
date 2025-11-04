import 'package:flutter/material.dart';
import '../../models/wisata_model.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/wisata_card.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

// Gunakan 'AutomaticKeepAliveClientMixin' agar state tidak hilang saat ganti tab
class _FavoritPageState extends State<FavoritPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<TempatWisataModel>> _futureFavorit;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadFavorit();
  }

  void _loadFavorit() {
    _futureFavorit = _apiService.getFavorit();
  }

  void _onRetry() {
    setState(() {
      _loadFavorit();
    });
  }

  // Jika status favorit berubah (misal di-unfavorite dari halaman ini)
  void _onFavoritChanged() {
    _onRetry(); // Muat ulang daftar favorit
  }

  @override
  bool get wantKeepAlive => true; // Penting untuk keep state

  @override
  Widget build(BuildContext context) {
    super.build(context); // Penting untuk AutomaticKeepAliveClientMixin
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wisata Favorit Saya'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _onRetry(),
        child: FutureBuilder<List<TempatWisataModel>>(
          future: _futureFavorit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget(message: 'Memuat data favorit...');
            } else if (snapshot.hasError) {
              return CustomErrorWidget(
                message: 'Gagal memuat: ${snapshot.error}',
                onRetry: _onRetry,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const EmptyWidget(
                message: 'Anda belum punya favorit',
                icon: Icons.favorite_border,
              );
            }

            final favoritList = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoritList.length,
              itemBuilder: (context, index) {
                final wisata = favoritList[index];
                // Semua yang di sini otomatis adalah favorit
                wisata.isFavorit = true; 
                return WisataCard(
                  wisata: wisata,
                  onFavoritChanged: _onFavoritChanged,
                );
              },
            );
          },
        ),
      ),
    );
  }
}