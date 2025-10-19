import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import '../widgets/bottom_navbar.dart';

class FreshMarketScreen extends StatefulWidget {
  final String? initialFilter;
  const FreshMarketScreen({super.key, this.initialFilter});

  @override
  State<FreshMarketScreen> createState() => _FreshMarketScreenState();
}

class _FreshMarketScreenState extends State<FreshMarketScreen> {
  int _selectedIndex = 0; // Default to home, but can be adjusted
  String _selectedFilter = "All";
  bool _filterSet = false;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialFilter != null) {
      _selectedFilter = widget.initialFilter!;
      _filterSet = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Fresh Market",
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _selectedFilter = "All"),
                      child: _buildFilterChip("All", _selectedFilter == "All"),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _selectedFilter = "Fruits"),
                      child: _buildFilterChip("Fruits", _selectedFilter == "Fruits"),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _selectedFilter = "Vegetables"),
                      child: _buildFilterChip("Vegetables", _selectedFilter == "Vegetables"),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _selectedFilter = "Organic"),
                      child: _buildFilterChip("Organic", _selectedFilter == "Organic"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("247 items found",
                        style: GoogleFonts.poppins(fontSize: 13)),
                    Row(
                      children: [
                        Text("Sort by Rating",
                            style: GoogleFonts.poppins(fontSize: 13)),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Shop Cards
                _buildShopCard(
                  name: "Green Valley Market",
                  rating: 4.8,
                  distance: "2.3 km",
                  status: "Open",
                  color: Colors.green,
                  products: [
                    ProductItem("assets/apples.png", "Fresh Apples", "₹3.99/kg",
                        "Red Delicious"),
                    ProductItem("assets/carrots.png", "Organic Carrots",
                        "₹2.49/kg", "1 lb bundle"),
                  ],
                ),
                _buildShopCard(
                  name: "Organic Paradise",
                  rating: 4.5,
                  distance: "1.8 km",
                  status: "Open",
                  color: Colors.green,
                  products: [
                    ProductItem("assets/bananas.png", "Bananas", "₹1.99/kg",
                        "Organic bunch"),
                    ProductItem("assets/spinach.png", "Fresh Spinach", "₹4.99/kg",
                        "Baby spinach"),
                  ],
                ),
                _buildShopCard(
                  name: "Farm Fresh Corner",
                  rating: 4.9,
                  distance: "0.9 km",
                  status: "Busy",
                  color: Colors.orange,
                  products: [
                    ProductItem("assets/tomatoes.png", "Tomatoes", "₹3.49/kg",
                        "Fresh & Juicy"),
                    ProductItem("assets/cucumber.png", "Cucumbers", "₹2.89/kg",
                        "Organic bundle"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.green.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(label,
          style: GoogleFonts.poppins(
              color: selected ? Colors.green : Colors.black87,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
    );
  }

  Widget _buildShopCard({
    required String name,
    required double rating,
    required String distance,
    required String status,
    required Color color,
    required List<ProductItem> products,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop Header
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.storefront, color: color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: GoogleFonts.poppins(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 14),
                            Text(" $rating ",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w500)),
                            Text("• $distance",
                                style: GoogleFonts.poppins(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(status,
                        style: GoogleFonts.poppins(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              // Product Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...products.map((p) => _buildProductCard(p)).toList(),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text("See all ➜",
                    style: GoogleFonts.poppins(
                        color: Colors.green, fontSize: 13)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductItem item) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(item.image,
                  height: 80, width: double.infinity, fit: BoxFit.cover)),
          const SizedBox(height: 8),
          Text(item.name,
              style:
                  GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13)),
          Text(item.subtitle,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.price,
                  style: GoogleFonts.poppins(
                      color: Colors.green, fontWeight: FontWeight.w600)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.add, size: 14, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ProductItem {
  final String image;
  final String name;
  final String price;
  final String subtitle;
  ProductItem(this.image, this.name, this.price, this.subtitle);
}
