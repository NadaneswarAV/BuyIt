import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/data_provider.dart';
import '../models/product.dart';
import '../models/shop.dart';
import '../providers/cart_provider.dart';
import '../widgets/shimmer_loading.dart';
import 'product_detail_screen.dart';
import 'shop_detail_screen.dart';

enum SearchType { items, shops }

class SearchScreen extends StatefulWidget {
  final SearchType? initialType;
  const SearchScreen({super.key, this.initialType});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchType _searchType = SearchType.items;

  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  List<Product> _allProducts = [];
  List<Shop> _allShops = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _searchType = widget.initialType!;
    }
    _loadInitialData();
    _searchController.addListener(() {
      _performSearch(_searchController.text);
    });
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      DataProvider().getProducts(),
      DataProvider().getShops(),
    ]);
    _allProducts = results[0] as List<Product>;
    _allShops = results[1] as List<Shop>;
    setState(() => _isLoading = false);
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    List<dynamic> results;
    if (_searchType == SearchType.items) {
      results = _allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      results = _allShops
          .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() => _searchResults = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        toolbarHeight: 72,
        title: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search for food, groceries...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButtonHideUnderline(
                  child: DropdownButton<SearchType>(
                    value: _searchType,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    items: const [
                      DropdownMenuItem(value: SearchType.shops, child: Text('Shops')),
                      DropdownMenuItem(value: SearchType.items, child: Text('Items')),
                    ],
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => _searchType = val);
                      _performSearch(_searchController.text);
                    },
                  ),
                ),
                if (_searchController.text.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _searchController.clear(),
                    child: const Icon(Icons.clear, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(child: Text('No results found.'))
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          if (item is Product) {
                            return _buildProductTile(item);
                          } else if (item is Shop) {
                            return _buildShopTile(item);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilterChip(
            label: const Text('Items'),
            selected: _searchType == SearchType.items,
            onSelected: (selected) {
              if (selected) {
                setState(() => _searchType = SearchType.items);
                _performSearch(_searchController.text);
              }
            },
            selectedColor: Colors.green.shade200,
          ),
          const SizedBox(width: 16),
          FilterChip(
            label: const Text('Shops'),
            selected: _searchType == SearchType.shops,
            onSelected: (selected) {
              if (selected) {
                setState(() => _searchType = SearchType.shops);
                _performSearch(_searchController.text);
              }
            },
            selectedColor: Colors.green.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildProductTile(Product product) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(product.image, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(product.name),
      subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
        onPressed: () {
          Provider.of<CartProvider>(context, listen: false).addItem(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product.name} added to cart!'), duration: const Duration(seconds: 1)),
          );
        },
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
      },
    );
  }

  Widget _buildShopTile(Shop shop) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(shop.image ?? 'assets/images/logo.png', width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(shop.name),
      subtitle: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          Text(' ${shop.rating}'),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: shop)));
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}