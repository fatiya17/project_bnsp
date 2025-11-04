class KotaModel {
  final int id;
  final String namaKota;

  KotaModel({
    required this.id,
    required this.namaKota,
  });

  factory KotaModel.fromJson(Map<String, dynamic> json) {
    return KotaModel(
      id: json['id'] ?? 0,
      namaKota: json['nama_kota'] ?? '',
    );
  }
}