import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/posts";

  // Create a new post (POST request)
  Future<http.Response> createItem(Map<String, dynamic> itemData) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(itemData),
    );
    return response;
  }

  // Read all posts (GET request)
  Future<List<dynamic>> getItems() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  // Update a post (PUT request)
  Future<http.Response> updateItem(int id, Map<String, dynamic> itemData) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(itemData),
    );
    return response;
  }

  // Delete a post (DELETE request)
  Future<void> deleteItem(int id) async {
    await http.delete(Uri.parse('$apiUrl/$id'));
  }
}
