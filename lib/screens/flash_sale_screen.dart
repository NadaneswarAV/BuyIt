import 'package:flutter/material.dart';

class FlashSaleScreen extends StatelessWidget {
  final List<Map<String, String>> flashItems = [
    {"image": "assets/images/dress1.png", "title": "Dress 1", "price": "₹1,299"},
    {"image": "assets/images/dress2.png", "title": "Dress 2", "price": "₹999"},
    {"image": "assets/images/watch.png", "title": "Smart Watch", "price": "₹2,499"},
    {"image": "assets/images/bike.png", "title": "Royal Enfield", "price": "₹78,000"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flash Sale")),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: flashItems.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(flashItems[index]["image"]!, fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(flashItems[index]["title"]!, maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(flashItems[index]["price"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
              ],
            ),
          );
        },
      ),
    );
  }
}
