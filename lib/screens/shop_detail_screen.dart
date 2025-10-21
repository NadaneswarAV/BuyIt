import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/data_provider.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/shop.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/shimmer_loading.dart';
import 'product_detail_screen.dart';
import '../services/favourites_service.dart';

class ShopDetailScreen extends StatefulWidget {
  final Shop shop;
  const ShopDetailScreen({super.key, required this.shop});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  late Future<List<Product>> _productsFuture;
  late Future<List<Review>> _reviewsFuture;
  List<Review> _reviews = [];
  final TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _sortOption = 'Rating';
  bool _isFavourited = false;

  @override
  void initState() {
    super.initState();
    _productsFuture = DataProvider().getProducts(shopId: widget.shop.id);
    _reviewsFuture = DataProvider().getReviews(widget.shop.id);
    _reviewsFuture.then((reviews) => setState(() => _reviews = reviews));
    _productsFuture.then((products) {
      _allProducts = products;
      _applyProductFilters();
      _searchController.addListener(_applyProductFilters);
      if (mounted) setState(() {});
    });
    _loadFavouriteState();
  }

  Future<void> _loadFavouriteState() async {
    final fav = await FavouritesService.isShopFavouritedByName(widget.shop.name);
    if (!mounted) return;
    setState(() => _isFavourited = fav);
  }

  void _applyProductFilters() {
    String q = _searchController.text.toLowerCase();
    List<Product> tmp = List.from(_allProducts);
    if (q.isNotEmpty) {
      tmp = tmp.where((p) => p.name.toLowerCase().contains(q)).toList();
    }
    switch (_sortOption) {
      case 'Rating':
        tmp.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Price: Low to High':
        tmp.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        tmp.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    setState(() {
      _filteredProducts = tmp;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyProductFilters);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.shop.name),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            tooltip: _isFavourited ? 'Remove from favourites' : 'Add shop to favourites',
            icon: Icon(
              _isFavourited ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: () async {
              if (_isFavourited) {
                await FavouritesService.removeShopByName(widget.shop.name);
                if (!mounted) return;
                setState(() => _isFavourited = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shop removed from favourites')),
                );
              } else {
                await FavouritesService.addShop(
                  store: widget.shop.name,
                  rating: widget.shop.rating,
                  distance: '${widget.shop.distance} km',
                );
                if (!mounted) return;
                setState(() => _isFavourited = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shop added to favourites')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShopHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search items in this shop...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() {
                        _sortOption = value;
                        _applyProductFilters();
                      });
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Rating', child: Text('Sort by Rating')),
                      PopupMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                      PopupMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                    ],
                    child: Row(
                      children: [
                        Text('Sort: $_sortOption', style: TextStyle(color: Colors.green.shade700)),
                        Icon(Icons.arrow_drop_down, color: Colors.green.shade700),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _buildProductList(),
            const Divider(height: 32, thickness: 8, color: Color(0xFFF5F5F5)),
            _buildReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildShopHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(widget.shop.image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.shop.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.shop.description, style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(" ${widget.shop.rating} (${widget.shop.distance}km away)"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _filteredProducts.isEmpty) {
          return const ProductListShimmer();
        }
        if (snapshot.hasError) {
          return const Center(child: Text("No products available from this shop."));
        }
        if (_filteredProducts.isEmpty) {
          return const Center(child: Text("No products match your search."));
        }
        final products = _filteredProducts;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
              onAddToCart: () {
                Provider.of<CartProvider>(context, listen: false).addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart!'), duration: const Duration(seconds: 1)),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: _showAddReviewDialog,
                icon: const Icon(Icons.add_comment_outlined),
                label: const Text("Add Review"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Review>>(
            future: _reviewsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Could not load reviews."));
              }
              if (_reviews.isEmpty) {
                return const Center(child: Text("No reviews yet. Be the first to add one!"));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              ...List.generate(5, (i) => Icon(
                                i < review.rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(review.comment),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddReviewDialog() {
    final reviewController = TextEditingController();
    int rating = 0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Your Review"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  )),
                ),
                TextField(
                  controller: reviewController,
                  decoration: const InputDecoration(hintText: "Write your comment..."),
                  maxLines: 3,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (rating > 0 && reviewController.text.isNotEmpty) {
                final newReview = Review(id: 'rev_new_${DateTime.now().millisecondsSinceEpoch}', shopId: widget.shop.id, userName: 'You', rating: rating, comment: reviewController.text);
                DataProvider().addReview(newReview); // Simulate API call
                setState(() => _reviews.insert(0, newReview)); // Add to list locally for instant UI update
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Review submitted!")));
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}