import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/kota_model.dart';
import '../models/wisata_model.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  final AuthService _authService = AuthService();

  // GET: /kota
  Future<List<KotaModel>> getKota() async {
    final headers = await _authService.getAuthHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/kota'), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => KotaModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data kota');
    }
  }

  // GET: /wisata
  Future<List<TempatWisataModel>> getWisata({int? kotaId}) async {
    final headers = await _authService.getAuthHeaders();
    String url = '$_baseUrl/wisata';
    if (kotaId != null) {
      url += '?kota_id=$kotaId'; // Filter berdasarkan kota
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      return data.map((json) => TempatWisataModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data wisata');
    }
  }

  // --- API FAVORIT ---

  // GET: /favorit
  Future<List<TempatWisataModel>> getFavorit() async {
    final headers = await _authService.getAuthHeaders();
    final response = await http.get(Uri.parse('$_baseUrl/favorit'), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'] as List;
      // Data favorit adalah list TempatWisataModel
      return data.map((json) => TempatWisataModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data favorit');
    }
  }

  // POST: /favorit
  Future<bool> addFavorit(int wisataId) async {
    final headers = await _authService.getAuthHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/favorit'),
      headers: headers,
      body: jsonEncode({'tempat_wisata_id': wisataId}),
    );
    return response.statusCode == 201;
  }

  // DELETE: /favorit/{id_wisata}
  Future<bool> removeFavorit(int wisataId) async {
    final headers = await _authService.getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/favorit/$wisataId'),
      headers: headers,
    );
    return response.statusCode == 200;
  }
}