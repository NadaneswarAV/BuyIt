import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _selectedIndex = 2; // 2 = Favourites tab

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Map<String, dynamic>> favourites = [
    {
      'store': 'Jeswin’s Mart',
      'rating': 4.8,
      'distance': '2.3 km',
      'product': 'Fresh Apples',
      'subtitle': 'Red Delicious',
      'price': 3.99,
      'unit': 'kg',
      'quantity': 3,
      'isLiked': true,
      'color': Colors.red,
    },
    {
      'store': 'WeMart',
      'rating': 4.8,
      'distance': '2.3 km',
      'product': 'Fresh carrot',
      'subtitle': 'freshly taken',
      'price': 7.19,
      'unit': 'kg',
      'quantity': 1,
      'isLiked': true,
      'color': Colors.orange,
    },
    {
      'store': 'Green Basket',
      'rating': 4.7,
      'distance': '1.8 km',
      'product': 'Organic Tomatoes',
      'subtitle': 'farm fresh',
      'price': 5.25,
      'unit': 'kg',
      'quantity': 2,
      'isLiked': true,
      'color': Colors.redAccent,
    },
  ];

  void _toggleLike(Map<String, dynamic> item) {
    setState(() {
      item['isLiked'] = !item['isLiked'];
      if (!item['isLiked']) {
        favourites.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your favourites",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body:
          favourites.isEmpty
              ? const Center(
                child: Text(
                  "No favourites yet!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    ...favourites.map(
                      (item) => FavouriteCard(
                        data: item,
                        onLikeToggle: () => _toggleLike(item),
                        onIncrement: () {
                          setState(() {
                            item['quantity']++;
                          });
                        },
                        onDecrement: () {
                          setState(() {
                            if (item['quantity'] > 1) item['quantity']--;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

class FavouriteCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onLikeToggle;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const FavouriteCard({
    super.key,
    required this.data,
    required this.onLikeToggle,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dummy image box (color block)
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: data['color'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store name + status
                Row(
                  children: [
                    Flexible(
                      // ✅ allows text to shrink
                      child: Text(
                        data['store'],
                        overflow:
                            TextOverflow.ellipsis, // ✅ adds “...” if too long
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Open",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      "(${data['rating']}) • ${data['distance']}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  data['product'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  data['subtitle'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹${data['price']}/${data['unit']}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  data['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: onLikeToggle,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey,
                    ),
                    onPressed: onDecrement,
                  ),
                  Text(
                    "${data['quantity']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    ),
                    onPressed: onIncrement,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
