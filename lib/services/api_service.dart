import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://fakestoreapi.com";

  // Get list of products
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Get cart details by cart ID
  Future<dynamic> getCart(int cartId) async {
    final response = await http.get(Uri.parse('$baseUrl/carts/$cartId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // Add a product to the cart
  Future<http.Response> addToCart(Map<String, dynamic> cartData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cartData),
    );
    return response;
  }
}
