class KategoriModel {
  final int id;
  final String namaKategori;

  KategoriModel({
    required this.id,
    required this.namaKategori,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'] ?? 0,
      namaKategori: json['nama_kategori'] ?? '',
    );
  }
}