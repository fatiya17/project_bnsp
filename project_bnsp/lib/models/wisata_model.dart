import 'kategori_model.dart';
import 'kota_model.dart';

class TempatWisataModel {
  final int id;
  final String namaWisata;
  final String? deskripsi;
  final String? alamat;
  final String? urlGambar;
  final int kotaId;
  final int kategoriId;
  final KotaModel? kota; // Relasi (jika di-load oleh API)
  final KategoriModel? kategori; // Relasi (jika di-load oleh API)

  // Status favorit (dikelola di client untuk UI)
  bool isFavorit;

  TempatWisataModel({
    required this.id,
    required this.namaWisata,
    this.deskripsi,
    this.alamat,
    this.urlGambar,
    required this.kotaId,
    required this.kategoriId,
    this.kota,
    this.kategori,
    this.isFavorit = false, // Default
  });

  factory TempatWisataModel.fromJson(Map<String, dynamic> json) {
    return TempatWisataModel(
      id: json['id'] ?? 0,
      namaWisata: json['nama_wisata'] ?? '',
      deskripsi: json['deskripsi'],
      alamat: json['alamat'],
      urlGambar: json['url_gambar'],
      kotaId: json['kota_id'] ?? 0,
      kategoriId: json['kategori_id'] ?? 0,
      kota: json['kota'] != null ? KotaModel.fromJson(json['kota']) : null,
      kategori: json['kategori'] != null
          ? KategoriModel.fromJson(json['kategori'])
          : null,
      // isFavorit akan di-set oleh service setelah data favorit diambil
    );
  }
}