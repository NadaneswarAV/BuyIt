import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../apis/wishlist_api.dart';
import '../apis/product_api.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavourited = false;

  @override
  void initState() {
    super.initState();
    _loadFavState();
  }

  Future<void> _loadFavState() async {
    try {
      final list = await WishlistApi.allWishlist();
      final pid = int.tryParse(widget.product.id);
      final fav = list.any((e) {
        final m = e as Map<String, dynamic>;
        if ((m['wishlist_type'] ?? '') != 'product') return false;
        final p = m['product'] as Map<String, dynamic>?;
        if (p == null) return false;
        if (pid != null) return p['id'] == pid;
        return (p['name']?.toString().toLowerCase() == widget.product.name.toLowerCase());
      });
      if (!mounted) return;
      setState(() => _isFavourited = fav);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                tooltip: _isFavourited ? 'Remove from favourites' : 'Add to favourites',
                icon: Icon(_isFavourited ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent),
                onPressed: () async {
                  try {
                    // Resolve product id for API
                    int? pid = int.tryParse(widget.product.id);
                    if (pid == null) {
                      // Fallback: search by name
                      final results = await ProductApi.searchProducts(widget.product.name);
                      if (results.isNotEmpty && results.first is Map<String, dynamic>) {
                        final first = results.first as Map<String, dynamic>;
                        pid = int.tryParse('${first['id']}');
                      }
                    }

                    if (pid == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product id not found for wishlist')));
                      return;
                    }

                    if (_isFavourited) {
                      await WishlistApi.removeFromWishlist(productId: pid);
                      if (!mounted) return;
                      setState(() => _isFavourited = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item removed from wishlist')),
                      );
                    } else {
                      await WishlistApi.addToWishlist(wishlistType: 'product', productId: pid);
                      if (!mounted) return;
                      setState(() => _isFavourited = true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item added to wishlist')),
                      );
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wishlist action failed')));
                  }
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${widget.product.id}',
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${widget.product.price.toStringAsFixed(2)} / ${widget.product.unit}',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.rating} Rating',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Text(
                        'Category: ${widget.product.category}',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            cart.addItem(widget.product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.product.name} added to cart!'), duration: const Duration(seconds: 1)),
            );
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Add to Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}