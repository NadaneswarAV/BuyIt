import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../providers/cart_provider.dart';
import '../models/product.dart';
import '../models/shop.dart';
import '../data/data_provider.dart';
import 'product_detail_screen.dart';
import 'shop_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../apis/wishlist_api.dart';
import 'main_navigation.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> with WidgetsBindingObserver {
  int _selectedIndex = 2; // 2 = Favourites tab
  String _sortBy = 'Recent'; // Recent, Name, Rating, Price
  String _filterType = 'All'; // All, Shops, Items

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Map<String, dynamic>> favourites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadFavourites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload in case favourites were modified from other screens
    _loadFavourites();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadFavourites();
    }
  }

  Future<void> _loadFavourites() async {
    try {
      final list = await WishlistApi.allWishlist();
      final mapped = list.map<Map<String, dynamic>>((e) {
        final m = e as Map<String, dynamic>;
        final type = (m['wishlist_type'] ?? '').toString();
        if (type == 'shop' && m['shop'] != null) {
          final shop = m['shop'] as Map<String, dynamic>;
          return {
            'type': 'shop',
            'store': shop['name'] ?? 'Shop',
            'rating': double.tryParse('${shop['average_rating'] ?? shop['rating'] ?? ''}') ?? 0.0,
            'distance': '',
            'shop_id': int.tryParse('${shop['id'] ?? ''}'),
            'added_at': m['added_at'],
          };
        } else {
          final prod = m['product'] as Map<String, dynamic>?;
          return {
            'type': 'item',
            'store': '',
            'product': prod?['name'] ?? 'Product',
            'subtitle': (prod?['category'] is Map) ? (prod!['category']['name'] ?? '') : '',
            'price': null, // API product schema doesn't include price here
            'unit': 'pc',
            'rating': 0.0,
            'distance': '',
            'product_id': int.tryParse('${prod?['id'] ?? ''}'),
            'added_at': m['added_at'],
          };
        }
      }).toList();
      if (!mounted) return;
      setState(() => favourites = mapped);
    } catch (_) {
      if (!mounted) return;
      setState(() => favourites = []);
    }
  }

  Future<void> _removeFavourite(Map<String, dynamic> item) async {
    try {
      if (item['type'] == 'shop' && item['shop_id'] != null) {
        await WishlistApi.removeFromWishlist(shopId: item['shop_id'] as int);
      } else if (item['type'] == 'item' && item['product_id'] != null) {
        await WishlistApi.removeFromWishlist(productId: item['product_id'] as int);
      }
      await _loadFavourites();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to remove from wishlist')));
    }
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
          onPressed: () {
            (MainNavigation.instance ?? MainNavigation.mainKey.currentState)?.goToPreviousTab();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Recent', child: Text('Sort: Recent')),
              PopupMenuItem(value: 'Name', child: Text('Sort: Name')),
              PopupMenuItem(value: 'Rating', child: Text('Sort: Rating')),
              PopupMenuItem(value: 'Price', child: Text('Sort: Price')),
            ],
            child: Row(children: [
              Text(_sortBy, style: const TextStyle(color: Colors.black87)),
              const Icon(Icons.sort, color: Colors.black87)
            ]),
          ),
        ],
      ),
      backgroundColor: Colors.white,
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
              : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildTypeChips(),
                        const SizedBox(height: 8),
                        ..._visibleSorted().map(
                          (item) => FavouriteCard(
                            data: item,
                            onAddToCart: () => _addFavItemToCart(context, item),
                            onRemove: () => _removeFavourite(item),
                            onTap: () => _onFavouriteTap(context, item),
                          ),
                        ),
                        const SizedBox(height: 100), // Space for the button
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Row(children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add to wishlist from product/shop pages')),
                            );
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('How to add?'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            (MainNavigation.instance ?? MainNavigation.mainKey.currentState)?.setIndex(3);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Go to Cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.shopping_cart, color: Colors.white),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),


    );
  }

  List<Map<String, dynamic>> _visibleSorted() {
    List<Map<String, dynamic>> list = favourites.where((e) =>
      _filterType == 'All' ||
      (_filterType == 'Shops' && e['type'] == 'shop') ||
      (_filterType == 'Items' && e['type'] == 'item')
    ).toList();

    switch (_sortBy) {
      case 'Name':
        list.sort((a, b) => (a['type'] == 'shop' ? a['store'] : a['product'])
            .toString().toLowerCase().compareTo((b['type'] == 'shop' ? b['store'] : b['product']).toString().toLowerCase()));
        break;
      case 'Rating':
        list.sort((a, b) => (b['rating'] ?? 0).compareTo(a['rating'] ?? 0));
        break;
      case 'Price':
        list.sort((a, b) => (a['price'] ?? double.infinity).compareTo(b['price'] ?? double.infinity));
        break;
      case 'Recent':
      default:
        break;
    }
    return list;
  }

  Widget _buildTypeChips() {
    final types = ['All', 'Shops', 'Items'];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final t = types[i];
          return ChoiceChip(
            label: Text(t),
            selected: _filterType == t,
            onSelected: (_) => setState(() => _filterType = t),
            selectedColor: Colors.green.shade100,
            backgroundColor: Colors.grey.shade200,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: types.length,
      ),
    );
  }

  

  void _addFavItemToCart(BuildContext context, Map<String, dynamic> item) {
    if (item['type'] != 'item') return;
    final product = Product(
      id: 'fav_${DateTime.now().millisecondsSinceEpoch}',
      shopId: '',
      name: item['product'] ?? 'Item',
      description: '',
      price: (item['price'] ?? 0.0).toDouble(),
      unit: item['unit'] ?? 'pc',
      category: '',
      image: 'assets/temp/fruits.png',
      rating: (item['rating'] ?? 4.5).toDouble(),
    );
    Provider.of<CartProvider>(context, listen: false).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  Future<void> _onFavouriteTap(BuildContext context, Map<String, dynamic> item) async {
    if (item['type'] == 'item') {
      final product = Product(
        id: 'fav_${(item['product'] ?? 'item')}_${DateTime.now().millisecondsSinceEpoch}',
        shopId: '',
        name: item['product'] ?? 'Item',
        description: item['subtitle'] ?? '',
        price: (item['price'] ?? 0.0).toDouble(),
        unit: item['unit'] ?? 'pc',
        category: '',
        image: 'assets/temp/fruits.png',
        rating: (item['rating'] ?? 4.5).toDouble(),
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      );
      return;
    }

    // Shop favourite: resolve shop by name and navigate
    final String storeName = (item['store'] ?? '').toString();
    try {
      final shops = await DataProvider().getShops();
      final Shop found = shops.firstWhere(
        (s) => s.name.toLowerCase() == storeName.toLowerCase(),
        orElse: () => Shop(
          id: '0',
          name: storeName,
          description: 'Shop',
          location: 'Unknown',
          averageRating: (item['rating'] ?? 4.5).toDouble(),
          reviewCount: 0,
          shopProducts: [],
          image: 'assets/temp/store.png',
        ),
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: found)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open favourite.')),
      );
    }
  }
}

class FavouriteCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const FavouriteCard({
    super.key,
    required this.data,
    required this.onAddToCart,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                data['type'] == 'shop' ? Icons.storefront : Icons.shopping_bag,
                color: Colors.green,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          data['store'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Open",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text("(${data['rating'] ?? '-'}) • ${data['distance'] ?? ''}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ]),
                  const SizedBox(height: 6),
                  if (data['type'] == 'item') ...[
                    Text(data['product'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(data['subtitle'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                  const SizedBox(height: 6),
                  if (data['type'] == 'item')
                    Text("₹${data['price'] ?? '-'}/${data['unit'] ?? 'pc'}",
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: onRemove,
                ),
                if (data['type'] == 'item')
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: onAddToCart,
                  ),
                if (data['type'] == 'shop') const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
