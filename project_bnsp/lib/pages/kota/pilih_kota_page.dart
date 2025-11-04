import 'package:flutter/material.dart';
import '../../models/kota_model.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart'; 
import '../wisata/wisata_list_page.dart'; 

class PilihKotaPage extends StatefulWidget {
  const PilihKotaPage({super.key});

  @override
  State<PilihKotaPage> createState() => _PilihKotaPageState();
}

class _PilihKotaPageState extends State<PilihKotaPage> {
  late Future<List<KotaModel>> _futureKota;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadKota();
  }

  void _loadKota() {
    _futureKota = _apiService.getKota();
  }

  void _onRetry() {
    setState(() {
      _loadKota();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kota'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<KotaModel>>(
        future: _futureKota,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Memuat data kota...');
          } else if (snapshot.hasError) {
            return CustomErrorWidget(
              message: 'Gagal memuat: ${snapshot.error}',
              onRetry: _onRetry,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyWidget(message: 'Tidak ada data kota');
          }

          final kotaList = snapshot.data!;

          return ListView.builder(
            itemCount: kotaList.length,
            itemBuilder: (context, index) {
              final kota = kotaList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.location_city, color: Theme.of(context).primaryColor),
                  title: Text(
                    kota.namaKota,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // (Sesuai PDF) Tampilkan data wisata berdasarkan kota
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WisataListPage(kota: kota),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}