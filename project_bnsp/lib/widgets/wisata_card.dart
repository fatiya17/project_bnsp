import 'package:flutter/material.dart';
import '../models/wisata_model.dart';
import '../services/api_service.dart';

class WisataCard extends StatefulWidget {
  final TempatWisataModel wisata;
  final VoidCallback? onFavoritChanged; // Callback untuk refresh

  const WisataCard({
    super.key,
    required this.wisata,
    this.onFavoritChanged,
  });

  @override
  State<WisataCard> createState() => _WisataCardState();
}

class _WisataCardState extends State<WisataCard> {
  late bool _isFavorit;
  bool _isLoading = false; // Untuk loading saat klik favorit
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _isFavorit = widget.wisata.isFavorit;
  }

  // (Sesuai PDF) "Buat fitur Simpan ke Favorit"
  Future<void> _toggleFavorit() async {
    setState(() => _isLoading = true);

    try {
      bool success;
      if (_isFavorit) {
        // Hapus dari favorit
        success = await _apiService.removeFavorit(widget.wisata.id);
      } else {
        // Tambah ke favorit
        success = await _apiService.addFavorit(widget.wisata.id);
      }

      if (success) {
        setState(() {
          _isFavorit = !_isFavorit;
          widget.wisata.isFavorit = _isFavorit; // Update model lokal
        });
        // Panggil callback jika ada
        widget.onFavoritChanged?.call();
      } else {
        // Tampilkan error jika gagal
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengubah status favorit')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _isFavorit = widget.wisata.isFavorit;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(widget.wisata.namaWisata),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Deskripsi:\n${widget.wisata.deskripsi ?? 'Tidak ada deskripsi'}\n"),
                    Text("Alamat:\n${widget.wisata.alamat ?? 'Tidak ada alamat'}"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 180,
                color: Colors.grey.shade200,
                child: widget.wisata.urlGambar != null
                    ? Image.network(
                        widget.wisata.urlGambar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported, size: 50);
                        },
                      )
                    : const Icon(Icons.image, size: 50),
              ),
            ),

            // Konten Teks
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Expanded(
                        child: Text(
                          widget.wisata.namaWisata,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tombol Favorit
                      _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: Icon(
                                _isFavorit ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorit ? Colors.red : Colors.grey,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: _toggleFavorit,
                            ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Kota (jika ada)
                  if (widget.wisata.kota != null)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          widget.wisata.kota!.namaKota,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  
                  // Deskripsi Singkat
                  Text(
                    widget.wisata.deskripsi ?? 'Tidak ada deskripsi',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}