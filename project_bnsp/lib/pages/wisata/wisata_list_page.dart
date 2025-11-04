// lib/pages/wisata/wisata_list_page.dart
// (VERSI PERBAIKAN)

import 'package:flutter/material.dart';
import '../../models/kota_model.dart';
import '../../models/wisata_model.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/wisata_card.dart';

class WisataListPage extends StatefulWidget {
  final KotaModel? kota;

  const WisataListPage({super.key, this.kota});

  @override
  State<WisataListPage> createState() => _WisataListPageState();
}

class _WisataListPageState extends State<WisataListPage> {
  // 'late' dihapus, kita inisialisasi di initState
  Future<List<TempatWisataModel>>? _futureWisata;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Panggil fungsi _loadData dan langsung assign Future-nya
    _futureWisata = _loadData();
  }

  Future<List<TempatWisataModel>> _loadData() async {
    // 1. Ambil data favorit dulu untuk tahu mana yang sudah disukai
    List<int> favoritIds = [];
    try {
      final favoritList = await _apiService.getFavorit();
      favoritIds = favoritList.map((w) => w.id).toList();
    } catch (e) {
      // Gagal ambil favorit tidak masalah, anggap saja belum ada
      favoritIds = [];
    }

    // 2. Ambil data wisata
    final wisataList =
        await _apiService.getWisata(kotaId: widget.kota?.id);

    // 3. Sinkronkan status favorit
    for (var wisata in wisataList) {
      wisata.isFavorit = favoritIds.contains(wisata.id);
    }

    // 4. Kembalikan list yang sudah lengkap
    return wisataList;
  }

  // (PERBAIKAN) _onRetry harus me-reset Future
  void _onRetry() {
    setState(() {
      _futureWisata = _loadData();
    });
  }

  // (PERBAIKAN) _onFavoritChanged juga harus me-reset Future
  void _onFavoritChanged() {
    setState(() {
      _futureWisata = _loadData();
    });
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

            // Data sudah aman di sini
            final wisataList = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wisataList.length,
              itemBuilder: (context, index) {
                final wisata = wisataList[index];
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