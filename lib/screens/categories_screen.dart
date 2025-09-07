import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"icon": "🚗", "label": "Cars"},
    {"icon": "🏢", "label": "Real Estate"},
    {"icon": "👕", "label": "Clothes"},
    {"icon": "🏃", "label": "Sports"},
    {"icon": "🎨", "label": "Art"},
    {"icon": "📱", "label": "Electronics"},
    {"icon": "🍔", "label": "Food"},
    {"icon": "🎮", "label": "Games"},
    {"icon": "📚", "label": "Books"},
    {"icon": "🐶", "label": "Pets"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Categories"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Later: go to filtered product list page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Tapped ${categories[index]['label']}")),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(categories[index]["icon"]!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 8),
                  Text(categories[index]["label"]!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
