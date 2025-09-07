import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, String>> cartItems = [
    {"image": "assets/images/dress1.png", "title": "Yellow Dress", "price": "₹1299"},
    {"image": "assets/images/watch.png", "title": "Smart Watch", "price": "₹2499"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Image.asset(cartItems[index]["image"]!, width: 50, fit: BoxFit.cover),
              title: Text(cartItems[index]["title"]!),
              subtitle: Text(cartItems[index]["price"]!),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {}, // remove item logic here
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            // checkout logic
          },
          child: const Text("Proceed to Checkout"),
        ),
      ),
    );
  }
}
