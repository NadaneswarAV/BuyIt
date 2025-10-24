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
import '../services/storage_service.dart';
import '../services/favourites_service.dart';
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
    FavouritesService.version.removeListener(_loadFavourites);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Map<String, dynamic>> favourites = [];
  static const String _favKey = 'favourites_json';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadFavourites();
    FavouritesService.version.addListener(_loadFavourites);
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
    final saved = await StorageService.getString(_favKey);
    if (saved != null && saved.isNotEmpty) {
      final List<dynamic> data = json.decode(saved);
      setState(() => favourites = data.cast<Map<String, dynamic>>());
      return;
    }
    final seed = await rootBundle.loadString('assets/data/favourites.json');
    final List<dynamic> parsed = json.decode(seed);
    setState(() => favourites = parsed.cast<Map<String, dynamic>>());
    await _saveFavourites();
  }

  Future<void> _saveFavourites() async {
    await StorageService.setString(_favKey, json.encode(favourites));
  }

  void _removeFavourite(Map<String, dynamic> item) async {
    setState(() {
      favourites.remove(item);
    });
    await _saveFavourites();
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
                          onPressed: _showAddFavouriteSheet,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Favourite'),
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

  void _showAddFavouriteSheet() {
    String type = 'item';
    final storeCtl = TextEditingController();
    final productCtl = TextEditingController();
    final priceCtl = TextEditingController();
    final unitCtl = TextEditingController(text: 'kg');
    final ratingCtl = TextEditingController(text: '4.5');
    final distanceCtl = TextEditingController(text: '1.0 km');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: StatefulBuilder(builder: (ctx, setS) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add to Favourites', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(children: [
                    ChoiceChip(label: const Text('Item'), selected: type=='item', onSelected: (_) => setS(() => type='item')),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Shop'), selected: type=='shop', onSelected: (_) => setS(() => type='shop')),
                  ]),
                  const SizedBox(height: 12),
                  TextField(controller: storeCtl, decoration: const InputDecoration(labelText: 'Store name')),
                  if (type == 'item') ...[
                    const SizedBox(height: 8),
                    TextField(controller: productCtl, decoration: const InputDecoration(labelText: 'Product name')),
                    const SizedBox(height: 8),
                    TextField(controller: priceCtl, decoration: const InputDecoration(labelText: 'Price (e.g., 5.99)'), keyboardType: TextInputType.number),
                    const SizedBox(height: 8),
                    TextField(controller: unitCtl, decoration: const InputDecoration(labelText: 'Unit (e.g., kg, pc)')),
                  ],
                  const SizedBox(height: 8),
                  TextField(controller: ratingCtl, decoration: const InputDecoration(labelText: 'Rating (1-5)'), keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  TextField(controller: distanceCtl, decoration: const InputDecoration(labelText: 'Distance (e.g., 2.3 km)')),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel'))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final entry = <String, dynamic>{
                            'type': type,
                            'store': storeCtl.text.trim(),
                            'rating': double.tryParse(ratingCtl.text) ?? 0.0,
                            'distance': distanceCtl.text.trim(),
                          };
                          if (type == 'item') {
                            entry.addAll({
                              'product': productCtl.text.trim(),
                              'subtitle': '',
                              'price': double.tryParse(priceCtl.text) ?? 0.0,
                              'unit': unitCtl.text.trim().isEmpty ? 'pc' : unitCtl.text.trim(),
                            });
                          }
                          setState(() {
                            favourites.insert(0, entry);
                          });
                          _saveFavourites();
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Add'),
                      ),
                    ),
                  ])
                ],
              ),
            );
          }),
        );
      }
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
