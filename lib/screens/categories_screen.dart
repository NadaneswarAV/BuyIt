import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navbar.dart';
import 'fresh_market_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 1; // 1 = Categories tab

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(
                        child: Text(
                      "R",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sort, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Icon(Icons.search, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body Scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection("Grocery & Kitchen", [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FreshMarketScreen(initialFilter: "Fruits")),
                          );
                        },
                        child: _buildCategoryCard("assets/temp/fruits.png", "Fruits & vegetables"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FreshMarketScreen(initialFilter: "Vegetables")),
                          );
                        },
                        child: _buildCategoryCard("assets/temp/diary.png", "Diary, Bread & Eggs"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FreshMarketScreen(initialFilter: "Organic")),
                          );
                        },
                        child: _buildCategoryCard("assets/temp/grains.png", "Grains & oil"),
                      ),
                    ]),
                    _buildSection("Snacks & Drinks", [
                      _buildCategoryCard("assets/temp/tea.png", "Tea, Coffee & more"),
                      _buildCategoryCard("assets/temp/icecream.png", "Icecreams & more"),
                      _buildCategoryCard("assets/temp/frozen.png", "Frozen food"),
                      _buildCategoryCard("assets/temp/sweets.png", "Sweets"),
                    ]),
                    _buildSection("Beauty & Personal Care", [
                      _buildCategoryCard("assets/temp/beauty.png", "Beauty Parlour"),
                      _buildCategoryCard("assets/temp/skincare.png", "Skincare"),
                      _buildCategoryCard("assets/temp/whey.png", "Protein & Nutrition"),
                      _buildCategoryCard("assets/temp/baby.png", "Baby Care"),
                    ]),
                    _buildSection("Household Essentials", [
                      _buildCategoryCard("assets/temp/kitchen.png", "Kitchen & Dining"),
                      _buildCategoryCard("assets/temp/home.png", "Home Needs"),
                      _buildCategoryCard("assets/temp/electronics.png", "Electronics"),
                      _buildCategoryCard("assets/temp/pet.png", "Pet Care"),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }



  Widget _buildSection(String title, List<Widget> categories) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String imagePath, String title) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200, blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Image.asset(imagePath, height: 50, fit: BoxFit.contain),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 11),
          ),
        ],
      ),
    );
  }
}


