import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/data_provider.dart';
import '../models/product.dart';
import '../models/shop.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer_loading.dart';
import 'product_detail_screen.dart';
import 'shop_detail_screen.dart';

class FreshMarketScreen extends StatefulWidget {
  final String? initialFilter;
  final bool? initialIsCategory; // true if coming from a main category tap
  final String? initialCategoryTitle; // used for page title when opening via subcategory
  const FreshMarketScreen({super.key, this.initialFilter, this.initialIsCategory, this.initialCategoryTitle});

  @override
  State<FreshMarketScreen> createState() => _FreshMarketScreenState();
}

class _FreshMarketScreenState extends State<FreshMarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> _dataFuture;
  List<Product> _allProducts = [];
  List<Shop> _allShops = [];
  List<dynamic> _filteredData = [];
  Map<String, Shop> _shopById = {};

  String _selectedCategory = 'All';
  String _sortOption = 'Rating';
  String? _contextCategory; // when coming from a main category
  String _pageTitle = 'Fresh Market';
  final List<String> _defaultCategories = ['All'];
  late List<String> _categories;
  Map<String, List<String>> _subcatsByCategory = {};
  Map<String, String> _titleToFilter = {}; // maps display title to filter value
  Map<String, String> _filterToTitle = {}; // reverse map: filter -> title

  @override
  void initState() {
    super.initState();
    _categories = List.from(_defaultCategories);
    if (widget.initialFilter != null) {
      final isCategory = widget.initialIsCategory == true;
      if (isCategory) {
        // Category context: title = category, default to All to show shops
        _contextCategory = widget.initialFilter;
        _pageTitle = widget.initialFilter!;
        _selectedCategory = 'All';
        // ensure default chips
      } else {
        // Subcategory context: select that subcategory
        _pageTitle = widget.initialCategoryTitle ?? widget.initialFilter!;
        // Use provided parent category to load the right subcategories
        if (widget.initialCategoryTitle != null && widget.initialCategoryTitle!.isNotEmpty) {
          _contextCategory = widget.initialCategoryTitle;
        }
        _selectedCategory = widget.initialFilter!;
      }
    }
    _dataFuture = _loadData();
    _loadCategoriesFromProvider();
    _searchController.addListener(_applyFilters);
  }

  Future<List<dynamic>> _loadData() async {
    // Fetch both products and shops in parallel
    final results = await Future.wait([
      DataProvider().getProducts(),
      DataProvider().getShops(),
    ]);
    _allProducts = results[0] as List<Product>;
    _allShops = results[1] as List<Shop>;
    _shopById = {for (final s in _allShops) s.id.toString(): s};
    // Ensure product-shop linkage: keep only products whose shop exists
    _allProducts = _allProducts.where((p) => _shopById.containsKey(p.shopId)).toList();
    _applyFilters();
    return _filteredData;
  }

  Future<void> _loadCategoriesFromProvider() async {
    final raw = await DataProvider().getCategories();
    // Build subcats per category name and title->filter mapping
    final map = <String, List<String>>{};
    final titleMap = <String, String>{};
    final filterMap = <String, String>{};
    raw.forEach((cat, subs) {
      final titles = <String>[];
      for (final sub in subs) {
        final title = sub['title'] ?? '';
        final filter = sub['filter'] ?? '';
        if (title.isNotEmpty && filter.isNotEmpty) {
          titles.add(title);
          titleMap[title] = filter;
          filterMap[filter] = title;
        }
      }
      map[cat] = titles;
    });
    if (!mounted) return;
    setState(() {
      _subcatsByCategory = map;
      _titleToFilter = titleMap;
      _filterToTitle = filterMap;
      // Build chips based on context category
      if (_contextCategory != null && _subcatsByCategory.containsKey(_contextCategory)) {
        // Show subcategories for the selected main category
        _categories = ['All', ..._subcatsByCategory[_contextCategory!]!];
      } else {
        // No context or coming from subcategory - show all subcategories from first category
        if (_subcatsByCategory.isNotEmpty) {
          final first = _subcatsByCategory.keys.first;
          _categories = ['All', ..._subcatsByCategory[first]!];
        }
      }

      // If opened via subcategory (filter value), select its display title chip
      if (widget.initialFilter != null && widget.initialIsCategory != true) {
        final title = _filterToTitle[widget.initialFilter!];
        if (title != null && title.isNotEmpty) {
          _selectedCategory = title;
          if (!_categories.contains(title)) {
            _categories = ['All', ..._categories.where((c) => c != 'All'), title];
          }
        }
      }
      print('DEBUG: Context category: $_contextCategory');
      print('DEBUG: Categories chips: $_categories');
      print('DEBUG: Title to filter map: $_titleToFilter');
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    if (_selectedCategory == 'All') {
      // Show shops, optionally filter by context category
      List<Shop> tempShops = _allShops;
      if (_contextCategory != null) {
        tempShops = tempShops.where((shop) => shop.categories.contains(_contextCategory)).toList();
      }
      if (query.isNotEmpty) {
        tempShops = tempShops.where((shop) => shop.name.toLowerCase().contains(query)).toList();
      }
      _sortShops(tempShops);
      _filteredData = tempShops;
    } else {
      // Show products
      // Map selected title to filter value
      final filterValue = _titleToFilter[_selectedCategory] ?? _selectedCategory;
      print('DEBUG: Selected category: $_selectedCategory, Filter value: $filterValue');
      List<Product> tempProducts = _allProducts.where((p) => p.category == filterValue).toList();
      print('DEBUG: Products matching filter "$filterValue": ${tempProducts.length}');
      // If we have a context category, ensure products belong to shops tagged with that category
      if (_contextCategory != null) {
        tempProducts = tempProducts.where((p) => _shopById[p.shopId]?.categories.contains(_contextCategory) == true).toList();
        print('DEBUG: After context category filter "$_contextCategory": ${tempProducts.length}');
      }
      if (query.isNotEmpty) {
        tempProducts = tempProducts.where((p) => p.name.toLowerCase().contains(query)).toList();
      }
      // Sort products
      _sortProducts(tempProducts);
      _filteredData = tempProducts;
    }

    setState(() {});
  }

  void _sortShops(List<Shop> shops) {
    switch (_sortOption) {
      case 'Rating':
        shops.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Distance':
        shops.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'Delivery Time':
        shops.sort((a, b) => a.time.compareTo(b.time));
        break;
    }
  }

  void _sortProducts(List<Product> products) {
    switch (_sortOption) {
      case 'Rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Price: Low to High':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategorySelector(),
          _buildFilterAndSortBar(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _filteredData.isEmpty) {
                  return _selectedCategory == 'All' ? const ShopListShimmer() : const ProductListShimmer();
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (_filteredData.isEmpty) {
                  return const Center(child: Text("No items found."));
                }
                return _selectedCategory == 'All' ? _buildShopList() : _buildProductGrid();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: _selectedCategory == 'All' ? 'Search for shops...' : 'Search for products...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(icon: const Icon(Icons.clear), onPressed: () => _searchController.clear())
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      );

  Widget _buildCategorySelector() => SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final selected = cat == _selectedCategory;
            return ChoiceChip(
              label: Text(cat),
              selected: selected,
              onSelected: (_) => setState(() {
                _selectedCategory = cat;
                _applyFilters();
              }),
              selectedColor: Colors.green.shade100,
              labelStyle: TextStyle(color: selected ? Colors.green.shade800 : Colors.black),
            );
          },
        ),
      );

  Widget _buildFilterAndSortBar() {
    List<String> sortOptions = _selectedCategory == 'All'
        ? ['Rating', 'Distance', 'Delivery Time']
        : ['Rating', 'Price: Low to High', 'Price: High to Low'];
    if (!sortOptions.contains(_sortOption)) {
      _sortOption = 'Rating'; // Reset if current option is invalid
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${_filteredData.length} items found', style: const TextStyle(color: Colors.grey)),
          PopupMenuButton<String>(
            onSelected: (value) => setState(() {
              _sortOption = value;
              _applyFilters();
            }),
            itemBuilder: (context) => sortOptions.map((opt) => PopupMenuItem<String>(value: opt, child: Text(opt))).toList(),
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

  Widget _buildShopList() => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredData.length,
        itemBuilder: (context, index) {
          final shop = _filteredData[index] as Shop;
          return GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: shop))),
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(shop.image ?? 'assets/images/logo.png', width: 70, height: 70, fit: BoxFit.cover)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(shop.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(shop.description, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(' ${shop.rating} • ${shop.distance} km'),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

  Widget _buildProductGrid() => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemCount: _filteredData.length,
        itemBuilder: (context, index) {
          final product = _filteredData[index] as Product;
          final shopName = _shopById[product.shopId]?.name ?? '';
          return GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(product.image, height: 100, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(shopName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('₹${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                              onPressed: () {
                                Provider.of<CartProvider>(context, listen: false).addItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${product.name} added to cart!'), duration: const Duration(seconds: 1)),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    super.dispose();
  }
}