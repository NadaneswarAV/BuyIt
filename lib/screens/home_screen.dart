import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/data_provider.dart';
import '../models/shop.dart';
import '../widgets/shimmer_loading.dart';
import 'shops_near_you_screen.dart';
import 'fresh_market_screen.dart';
import 'main_navigation.dart';
import 'search_screen.dart';
import 'shop_detail_screen.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _locationText;
  SearchType _searchMode = SearchType.items;
  final ScrollController _pageController = ScrollController();
  final ScrollController _featuredController = ScrollController();

  final Map<String, List<Map<String, String>>> _categoryMap = {
    'Grocery': [
      {'title': 'Fruits & Vegetables', 'filter': 'Fruits', 'image': 'assets/temp/fruits.png'},
      {'title': 'Dairy & Eggs', 'filter': 'Dairy', 'image': 'assets/temp/diary.png'},
      {'title': 'Grains & Oil', 'filter': 'Organic', 'image': 'assets/temp/grains.png'},
    ],
    'Snacks & Drinks': [
      {'title': 'Tea, Coffee & more', 'filter': 'Tea', 'image': 'assets/temp/tea.png'},
      {'title': 'Icecreams & more', 'filter': 'Icecreams', 'image': 'assets/temp/icecreams.png'},
      {'title': 'Frozen food', 'filter': 'Frozen', 'image': 'assets/temp/frozen.png'},
      {'title': 'Sweets', 'filter': 'Sweets', 'image': 'assets/temp/sweets.png'},
    ],
    'Beauty & Personal Care': [
      {'title': 'Beauty Parlour', 'filter': 'Beauty', 'image': 'assets/temp/beauty.png'},
      {'title': 'Skincare', 'filter': 'Skincare', 'image': 'assets/temp/skincare.png'},
      {'title': 'Protein & Nutrition', 'filter': 'Protein', 'image': 'assets/temp/whey.png'},
      {'title': 'Baby Care', 'filter': 'Baby', 'image': 'assets/temp/baby.png'},
    ],
    'Household Essentials': [
      {'title': 'Kitchen & Dining', 'filter': 'Kitchen', 'image': 'assets/temp/kitchen.png'},
      {'title': 'Home Needs', 'filter': 'Home', 'image': 'assets/temp/home.png'},
      {'title': 'Electronics', 'filter': 'Electronics', 'image': 'assets/temp/electronics.png'},
      {'title': 'Pet Care', 'filter': 'Pet', 'image': 'assets/temp/pet.png'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _featuredController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedLocation() async {
    final saved = await StorageService.getString(StorageKeys.savedLocation);
    if (!mounted) return;
    setState(() => _locationText = saved);
  }

  Future<void> _handleLocationTap() async {
    final name = await LocationService.getCurrentPlacemarkName();
    if (name == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission denied. Using saved location: ${_locationText ?? 'Not set'}')), 
      );
      return;
    }
    await StorageService.setString(StorageKeys.savedLocation, name);
    if (!mounted) return;
    setState(() => _locationText = name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _pageController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header
            Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _handleLocationTap,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.white),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Deliver to', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                                Text(
                                  _locationText ?? 'Tap to set location',
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          (MainNavigation.instance ?? MainNavigation.mainKey.currentState)?.setIndex(4);
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage('assets/temp/profile.jpg'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => SearchScreen(initialType: _searchMode)),
                              );
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: 'Search for food, groceries...',
                                    border: InputBorder.none,
                                    hintStyle:
                                        GoogleFonts.poppins(color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<SearchType>(
                            value: _searchMode,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                            items: const [
                              DropdownMenuItem(value: SearchType.shops, child: Text('Shops')),
                              DropdownMenuItem(value: SearchType.items, child: Text('Items')),
                            ],
                            onChanged: (val) {
                              if (val == null) return;
                              setState(() => _searchMode = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Free Delivery Banner
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Free Delivery",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("On orders over ₹50",
                              style: GoogleFonts.poppins(fontSize: 13)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              final cart = Provider.of<CartProvider>(context, listen: false);
                              final nav = (MainNavigation.instance ?? MainNavigation.mainKey.currentState);
                              if (cart.itemCount > 0) {
                                nav?.setIndex(3); // Cart tab
                              } else {
                                nav?.setIndex(1); // Categories tab
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text("Order Now"),
                          ),
                        ]),
                    const Icon(Icons.delivery_dining,
                        color: Colors.green, size: 40),
                  ],
                ),
              ),
            ),

            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Categories",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategory(context, Icons.local_cafe, "Snacks & Drinks",
                      Colors.green.shade100, Colors.green),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (_) => const FreshMarketScreen()));
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.shopping_bag_outlined, color: Colors.blue, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            "Grocery",
                            style: GoogleFonts.poppins(fontSize: 11),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  _buildCategory(context, Icons.spa_outlined, "Wellness",
                      Colors.purple.shade100, Colors.purple),
                  _buildCategory(context, Icons.home_outlined, "Homewares",
                      Colors.red.shade100, Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Featured Shops
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Featured Shops",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (_) => const ShopsNearYouPage()));
                    },
                    child: Text("See All",
                        style: GoogleFonts.poppins(
                            color: Colors.green, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Featured shops vertical scroll inside invisible container
            SizedBox(
              height: 560,
              child: FutureBuilder<List<Shop>>(
                future: DataProvider().getShops(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShopListShimmer();
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No shops found."));
                  }
                  final shops = snapshot.data!;
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is OverscrollNotification) {
                        final delta = notification.overscroll;
                        if (_pageController.hasClients) {
                          final newOffset = _pageController.position.pixels + delta;
                          if (newOffset >= 0 && newOffset <= _pageController.position.maxScrollExtent) {
                            _pageController.jumpTo(newOffset);
                          }
                        }
                      }
                      return false;
                    },
                    child: ListView.separated(
                      controller: _featuredController,
                      padding: const EdgeInsets.only(bottom: 8),
                      itemCount: shops.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) => _buildShopCard(context, shops[index]),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
            // Category + Subcategory rows
            ..._categoryMap.entries.map((entry) => _buildHorizontalSubcats(context, entry.key, entry.value)).toList(),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildCategory(
      BuildContext context, IconData icon, String title, Color bgColor, Color iconColor) {
    return GestureDetector(
      onTap: () {
        (MainNavigation.instance ?? MainNavigation.mainKey.currentState)?.setIndex(1);
      },
      child: Container(
        width: 70,
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(BuildContext context, Shop shop) {
    return GestureDetector(
      onTap: () { 
        Navigator.of(context, rootNavigator: false).push(MaterialPageRoute(builder: (_) => ShopDetailScreen(shop: shop)));
      }, 
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(shop.image ?? 'assets/images/logo.png', height: 140, width: double.infinity, fit: BoxFit.cover)),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name,
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(shop.description,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.star, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text(shop.rating.toString(),
                              style: GoogleFonts.poppins(
                                  fontSize: 13, fontWeight: FontWeight.w500)),
                        ]),
                        Text("${shop.time}–${shop.time + 10} min  •  ${shop.delivery}",
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSubcats(BuildContext context, String category, List<Map<String, String>> subcats) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(category, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (_) => FreshMarketScreen(initialFilter: category, initialIsCategory: true),
                      ),
                    );
                  },
                  child: const Text('View all', style: TextStyle(color: Colors.green)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: subcats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final sc = subcats[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(
                        builder: (_) => FreshMarketScreen(
                          initialFilter: sc['filter']!,
                          initialIsCategory: false,
                          initialCategoryTitle: category,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 2))],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(sc['image']!, height: 36),
                        const SizedBox(height: 8),
                        Text(sc['title']!, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
