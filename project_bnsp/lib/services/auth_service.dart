// import 'dart:convert';
// import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // Ganti dengan URL API Anda
  static const String baseUrl = 'https://your-api.com/api';
  
  // Simulasi login (ganti dengan API call)
  Future<bool> login(String email, String password) async {
    try {
      // Simulasi delay network
      await Future.delayed(const Duration(seconds: 2));
      
      // CONTOH: Ganti dengan API call sebenarnya
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Simpan token atau user data
        return true;
      }
      return false;
      */
      
      // Simulasi: login berhasil jika email dan password tidak kosong
      return email.isNotEmpty && password.isNotEmpty;
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Simulasi register (ganti dengan API call)
  Future<bool> register(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      // CONTOH: Ganti dengan API call sebenarnya
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      return response.statusCode == 201;
      */
      
      return name.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
    } catch (e) {
      throw Exception('Register error: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Hapus token atau user data
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      // Ambil user dari storage atau API
      // Untuk sementara, kembalikan dummy user
      return UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '081234567890',
      );
    } catch (e) {
      throw Exception('Get user error: $e');
    }
  }
}
