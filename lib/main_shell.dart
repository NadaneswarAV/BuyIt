import 'package:flutter/material.dart';
import 'screens/shop_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/cart_screen.dart'; // new

class MainShell extends StatefulWidget {
  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ShopScreen(),        // Home
    DashboardScreen(),   // Analytics
    GalleryScreen(),     // Gallery
    CartScreen(),        // 🛒 Cart replaces Categories
    ProfileScreen(),     // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: "Gallery"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"), // 🔄 changed
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
