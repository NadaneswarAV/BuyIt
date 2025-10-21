import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/data_provider.dart';
import '../models/shop.dart';
import '../widgets/shimmer_loading.dart';
import 'shop_detail_screen.dart';


class ShopsNearYouPage extends StatefulWidget {
  const ShopsNearYouPage({super.key});

  @override
  State<ShopsNearYouPage> createState() => _ShopsNearYouPageState();
}

class _ShopsNearYouPageState extends State<ShopsNearYouPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Shop>> _shopsFuture;
  List<Shop> _allShops = [];
  List<Shop> _filteredShops = [];
  String _selectedCategory = 'All';
  String _sortOption = 'Rating';

  final List<String> categories = [
    'All',
    'Grocery',
    'Electronics',
    'Pharmacy',
    'Beauty',
  ];

  @override
  void initState() {
    super.initState();
    _shopsFuture = DataProvider().getShops().then((shops) {
      setState(() {
        _allShops = shops;
        _applyFilters();
      });
      return shops;
    });
    _searchController.addListener(() {
      setState(() {
        _applyFilters();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Shops Near You'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategorySelector(),
          _buildFilterAndSortBar(),
          Expanded(
            child: FutureBuilder<List<Shop>>(
              future: _shopsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _allShops.isEmpty) {
                  return const ShopListShimmer();
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (_filteredShops.isEmpty) {
                  return const Center(child: Text("No shops found matching your criteria."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: _filteredShops.length,
                  itemBuilder: (context, index) {
                    final shop = _filteredShops[index];
                    return _buildShopCard(shop);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for shops...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
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
          final selected = cat == _selectedCategory;
          return ChoiceChip(
            backgroundColor: Colors.grey.shade200,
            label: Text(cat),
            selected: selected,
            onSelected: (_) => setState(() {
              _selectedCategory = cat;
              _applyFilters();
            }),
            selectedColor: Colors.green.shade100,
            labelStyle: TextStyle(
              color: selected ? Colors.white : Colors.black,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterAndSortBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${_filteredShops.length} shops found', style: const TextStyle(color: Colors.grey)),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortOption = value;
                _applyFilters();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'Rating', child: Text('Sort by Rating')),
              const PopupMenuItem<String>(value: 'Distance', child: Text('Sort by Distance')),
              const PopupMenuItem<String>(value: 'Delivery Time', child: Text('Sort by Delivery Time')),
            ],
            child: Row(
              children: [
                Text('Sort by: $_sortOption', style: TextStyle(color: Colors.green.shade700)),
                Icon(Icons.arrow_drop_down, color: Colors.green.shade700),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(Shop shop) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: shop)));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(shop.image, height: 140, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shop.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(shop.description, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          Text(' ${shop.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(' • ${shop.distance} km', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Text('${shop.time}-${shop.time + 10} min • ${shop.delivery}', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    List<Shop> tempShops = _allShops;

    // Filter by category
    if (_selectedCategory != 'All') {
      tempShops = tempShops.where((shop) => shop.categories.contains(_selectedCategory)).toList();
    }

    // Filter by search query
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      tempShops = tempShops.where((shop) => shop.name.toLowerCase().contains(query)).toList();
    }

    // Sort the list
    switch (_sortOption) {
      case 'Rating':
        tempShops.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Distance':
        tempShops.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'Delivery Time':
        tempShops.sort((a, b) => a.time.compareTo(b.time));
        break;
    }

    setState(() {
      _filteredShops = tempShops;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
