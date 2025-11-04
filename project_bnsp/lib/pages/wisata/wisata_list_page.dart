import 'package:flutter/material.dart';
import '../../models/kota_model.dart';
import '../../models/wisata_model.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/wisata_card.dart'; 

class WisataListPage extends StatefulWidget {
  final KotaModel? kota; // Opsional, jika difilter berdasarkan kota

  const WisataListPage({super.key, this.kota});

  @override
  State<WisataListPage> createState() => _WisataListPageState();
}

class _WisataListPageState extends State<WisataListPage> {
  late Future<List<TempatWisataModel>> _futureWisata;
  final ApiService _apiService = ApiService();
  List<int> _favoritIds = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Memuat data wisata dan data favorit untuk sinkronisasi tombol
  Future<void> _loadData() async {
    // 1. Ambil data favorit dulu untuk tahu mana yang sudah disukai
    try {
      final favoritList = await _apiService.getFavorit();
      _favoritIds = favoritList.map((w) => w.id).toList();
    } catch (e) {
      // Gagal ambil favorit tidak masalah, anggap saja belum ada
      _favoritIds = [];
    }
    
    // 2. Ambil data wisata
    _futureWisata = _apiService.getWisata(kotaId: widget.kota?.id);

    // 3. Update state
    if (mounted) {
      setState(() {});
    }
  }

  void _onRetry() {
    setState(() {
      _loadData();
    });
  }
  
  // Fungsi untuk refresh (dipanggil oleh WisataCard)
  void _onFavoritChanged() {
    // Muat ulang data favorit untuk update status UI
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kota?.namaKota ?? 'Semua Tempat Wisata'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _onRetry(),
        child: FutureBuilder<List<TempatWisataModel>>(
          future: _futureWisata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingWidget(message: 'Memuat data wisata...');
            } else if (snapshot.hasError) {
              return CustomErrorWidget(
                message: 'Gagal memuat: ${snapshot.error}',
                onRetry: _onRetry,
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const EmptyWidget(message: 'Tidak ada tempat wisata');
            }

            final wisataList = snapshot.data!;
            
            // Sinkronkan status favorit
            for (var wisata in wisataList) {
              wisata.isFavorit = _favoritIds.contains(wisata.id);
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wisataList.length,
              itemBuilder: (context, index) {
                final wisata = wisataList[index];
                return WisataCard(
                  wisata: wisata,
                  onFavoritChanged: _onFavoritChanged, // Kirim callback
                );
              },
            );
          },
        ),
      ),
    );
  }
}