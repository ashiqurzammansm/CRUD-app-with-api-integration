import 'package:flutter/material.dart';
import 'package:crud_app/services/api_service.dart';
import 'package:crud_app/models/item_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Item> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> data = await apiService.getItems();
      setState(() {
        items = data.map((json) => Item.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteItem(int id) async {
    await apiService.deleteItem(id);
    _loadItems(); // Refresh the list after deleting
  }

  void _addItem() {
    // For simplicity, just add a hardcoded item.
    apiService.createItem({
      'title': 'New Post',
      'body': 'This is a new post',
    }).then((response) {
      if (response.statusCode == 201) {
        print("Post created successfully");
        _loadItems(); // Refresh the list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD App with JSONPlaceholder API'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addItem,  // Trigger to add a new item
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.body),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteItem(item.id),  // Delete action
            ),
          );
        },
      ),
    );
  }
}
