import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"image": "assets/images/dress1.png", "label": "Dresses"},
    {"image": "assets/images/dress2.png", "label": "Tops"},
    {"image": "assets/images/watch.png", "label": "Accessories"},
    {"image": "assets/images/bag.png", "label": "Bags"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Column(
        children: [
          ToggleButtons(
            isSelected: const [true, false, false],
            children: const [
              Padding(padding: EdgeInsets.all(8), child: Text("All")),
              Padding(padding: EdgeInsets.all(8), child: Text("Female")),
              Padding(padding: EdgeInsets.all(8), child: Text("Male")),
            ],
            onPressed: (index) {},
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(categories[index]["image"]!),
                    ),
                    const SizedBox(height: 6),
                    Text(categories[index]["label"]!),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
