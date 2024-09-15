import 'package:flutter/material.dart';
import 'package:crud_app/services/api_service.dart';
import 'package:crud_app/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<dynamic> data = await apiService.getProducts();
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addToCart(int productId) {
    apiService.addToCart({
      "userId": 1,
      "date": "2024-09-16",
      "products": [
        {"productId": productId, "quantity": 1}
      ]
    }).then((response) {
      if (response.statusCode == 200) {
        print("Product added to cart successfully");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD app with API integration'),  // Update AppBar title here
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Image.network(product.image, width: 50, height: 50),
            title: Text(product.title),
            subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () => _addToCart(product.id),
            ),
          );
        },
      ),
    );
  }
}
