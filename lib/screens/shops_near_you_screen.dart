import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class ShopsNearYouPage extends StatefulWidget {
  const ShopsNearYouPage({super.key});

  @override
  State<ShopsNearYouPage> createState() => _ShopsNearYouPageState();
}

class _ShopsNearYouPageState extends State<ShopsNearYouPage> {
  String selectedCategory = 'Grocery';
  String searchQuery = '';
  bool sortByRating = true;
  int selectedIndex = 0; // Shops near you is not in bottom nav, but we can set to 0 for home

  final List<String> categories = [
    'Grocery',
    'Electronics',
    'Pharmacy',
    'Beauty',
  ];

  final List<Shop> allShops = [
    Shop(
      name: 'Green Garden Bistro',
      rating: 4.8,
      description: 'Healthy • Organic • Salads',
      delivery: 'Free delivery',
      time: 15,
      categories: ['Grocery', 'Beauty'],
    ),
    Shop(
      name: 'Fresh Market Plus',
      rating: 4.6,
      description: 'Groceries • Fresh Produce',
      delivery: '\$2.99 delivery',
      time: 20,
      categories: ['Grocery', 'Electronics'],
    ),
    Shop(
      name: 'Health Hub Pharmacy',
      rating: 4.9,
      description: 'Medicines • Wellness Products',
      delivery: 'Free delivery',
      time: 10,
      categories: ['Pharmacy', 'Beauty'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<Shop> filtered =
        allShops.where((shop) {
          final matchCategory = shop.categories.contains(selectedCategory);
          final matchSearch = shop.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          return matchCategory && matchSearch;
        }).toList();

    if (sortByRating) {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Shops near you'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: ShopSearchDelegate(allShops, selectedCategory),
              );
              if (result != null) setState(() => searchQuery = result);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategorySelector(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${filtered.length} items found'),
                InkWell(
                  onTap: () => setState(() => sortByRating = !sortByRating),
                  child: Row(
                    children: [
                      const Icon(Icons.sort, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Sort by Rating',
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final shop = filtered[index];
                return _buildShopCard(shop);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = cat == selectedCategory;
          return ChoiceChip(
            label: Text(cat),
            selected: selected,
            onSelected: (_) => setState(() => selectedCategory = cat),
            selectedColor: Colors.green,
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopCard(Shop shop) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // placeholder if no image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.store, size: 50, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.green, size: 18),
                        Text(
                          shop.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  shop.description,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${shop.time}-25 min'),
                    Text(
                      shop.delivery,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Shop {
  final String name;
  final double rating;
  final String description;
  final String delivery;
  final int time;
  final List<String> categories;

  Shop({
    required this.name,
    required this.rating,
    required this.description,
    required this.delivery,
    required this.time,
    required this.categories,
  });
}

class ShopSearchDelegate extends SearchDelegate<String> {
  final List<Shop> allShops;
  final String selectedCategory;

  ShopSearchDelegate(this.allShops, this.selectedCategory);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results =
        allShops
            .where(
              (s) =>
                  s.categories.contains(selectedCategory) &&
                  s.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    if (results.isEmpty) {
      return const Center(child: Text('No shops found'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final shop = results[index];
        return ListTile(
          leading: const Icon(Icons.store),
          title: Text(shop.name),
          subtitle: Text(shop.description),
          trailing: Text(shop.rating.toString()),
          onTap: () => close(context, shop.name),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        allShops
            .where(
              (s) =>
                  s.categories.contains(selectedCategory) &&
                  s.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final shop = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.store),
          title: Text(shop.name),
          subtitle: Text(shop.description),
          onTap: () {
            query = shop.name;
            showResults(context);
          },
        );
      },
    );
  }
}
