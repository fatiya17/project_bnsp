import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  static const String _tokenKey = 'authToken';

  // Helper untuk menyimpan token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Helper untuk mengambil token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Helper untuk menghapus token
  Future<void> _deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Helper untuk mendapatkan header otentikasi
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8', 
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Fungsi Register (Sesuai API: /register)
  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // 'data' berisi {'token': ..., 'user': ...}
        await _saveToken(data['data']['token']);
        return {'success': true, 'data': UserModel.fromJson(data['data']['user'])};
      } else {
        // 'data' berisi {'message': ..., 'data': {errors...}}
        return {'success': false, 'message': data['message'] ?? 'Registrasi gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Fungsi Login (Sesuai API: /login)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveToken(data['data']['token']);
        return {'success': true, 'data': UserModel.fromJson(data['data']['user'])};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Fungsi Logout (Sesuai API: /logout)
  Future<void> logout() async {
    try {
      final headers = await getAuthHeaders();
      await http.post(
        Uri.parse('$_baseUrl/logout'),
        headers: headers,
      );
    } catch (e) {
      // Logout di client
    } finally {
      await _deleteToken();
    }
  }

  // Fungsi Get User (Sesuai API: /user)
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final headers = await getAuthHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/user'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // API /user Laravel mengembalikan data user langsung
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}