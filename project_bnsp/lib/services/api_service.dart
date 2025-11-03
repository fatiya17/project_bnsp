// import 'dart:convert';
// import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  // Ganti dengan URL API Anda
  static const String baseUrl = 'https://your-api.com/api';
  
  // GET: Fetch products
  Future<List<ProductModel>> getProducts() async {
    try {
      // Simulasi delay
      await Future.delayed(const Duration(seconds: 1));
      
      // CONTOH: Ganti dengan API call sebenarnya
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }
      throw Exception('Failed to load products');
      */
      
      // Data dummy untuk testing
      return [
        ProductModel(
          id: '1',
          name: 'Product 1',
          description: 'Deskripsi product 1 yang sangat menarik',
          price: 100000,
          stock: 10,
          image: 'https://via.placeholder.com/300',
        ),
        ProductModel(
          id: '2',
          name: 'Product 2',
          description: 'Deskripsi product 2 yang berkualitas',
          price: 200000,
          stock: 5,
          image: 'https://via.placeholder.com/300',
        ),
        ProductModel(
          id: '3',
          name: 'Product 3',
          description: 'Deskripsi product 3 yang terbaik',
          price: 150000,
          stock: 8,
          image: 'https://via.placeholder.com/300',
        ),
      ];
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // GET: Fetch single product
  Future<ProductModel> getProduct(String id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to load product');
      */
      
      return ProductModel(
        id: id,
        name: 'Product $id',
        description: 'Detailed description',
        price: 100000,
        stock: 10,
      );
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // POST: Create product
  Future<bool> addProduct(ProductModel product) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      return response.statusCode == 201;
      */
      print('Produk ditambahkan: ${product.name}');
      return true;
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  // PUT: Update product
  Future<bool> updateProduct(String id, ProductModel product) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      /*
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );

      return response.statusCode == 200;
      */
      
      return true;
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  // DELETE: Delete product
  Future<bool> deleteProduct(String id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      /*
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
      */
      
      return true;
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}