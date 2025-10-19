import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shops_near_you_screen.dart';
import 'categories_screen.dart';
import 'fresh_market_screen.dart';
import '../widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Home is selected

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.white),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Deliver to",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white70, fontSize: 12)),
                                Text("Edachira, Kakkanad",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage('assets/temp/profile.jpg'),
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
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Search for food, groceries...',
                                  border: InputBorder.none,
                                  hintStyle:
                                      GoogleFonts.poppins(color: Colors.grey)),
                            ),
                          ),
                          const Icon(Icons.tune, color: Colors.green),
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
                              onPressed: () {},
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategory(context, Icons.local_cafe, "Snacks & Drinks",
                        Colors.green.shade100, Colors.green),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FreshMarketScreen()),
                        );
                      },
                      child: Container(
                        width: 70,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ShopsNearYouPage()),
                        );
                      },
                      child: Text("See All",
                          style: GoogleFonts.poppins(
                              color: Colors.green, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Shop Card
              _buildShopCard(
                image: "assets/temp/restaurant.jpg",
                name: "Green Garden Bistro",
                rating: 4.8,
                tags: "Healthy • Organic • Salads",
                time: "15–25 min",
                delivery: "Free delivery",
              ),
              _buildShopCard(
                image: "assets/temp/grocery.jpg",
                name: "FreshMart Grocery",
                rating: 4.6,
                tags: "Groceries • Vegetables • Fruits",
                time: "10–20 min",
                delivery: "Free delivery",
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  Widget _buildCategory(
      BuildContext context, IconData icon, String title, Color bgColor, Color iconColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategoriesScreen()),
        );
      },
      child: Container(
        width: 70,
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
              style: GoogleFonts.poppins(fontSize: 11),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard({
    required String image,
    required String name,
    required double rating,
    required String tags,
    required String time,
    required String delivery,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200, blurRadius: 6, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(image, height: 140, width: double.infinity, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(tags,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.star, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(rating.toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                      ]),
                      Text("$time  •  $delivery",
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
