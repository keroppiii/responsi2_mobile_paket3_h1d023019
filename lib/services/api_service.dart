import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_2_mobile_paket_3_h1d023019/models/book_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.56.1:8080/api';
  // static const String baseUrl = 'http://localhost:8080/api'; // Untuk web
  // static const String baseUrl = 'http://192.168.x.x:8080/api'; // Untuk device fisik

  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<Book>> getBooks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/books'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] is List) {
        return (data['data'] as List)
            .map((item) => Book.fromJson(item))
            .toList();
      }
    }
    return [];
  }

  static Future<bool> addBook(String token, Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(book.toJson()),
    );

    return response.statusCode == 201;
  }

  static Future<bool> updateBook(String token, int id, Book book) async {
    final response = await http.put(
      Uri.parse('$baseUrl/books/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(book.toJson()),
    );

    return response.statusCode == 200;
  }

  static Future<bool> deleteBook(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/books/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}