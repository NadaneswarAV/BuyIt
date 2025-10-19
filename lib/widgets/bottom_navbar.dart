import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../screens/home_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _handleTap(int index) {
    if (index == widget.currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const CategoriesScreen();
        break;
      case 2:
        page = const FavouritesScreen();
        break;
      case 3:
        page = const CartScreen();
        break;
      case 4:
        page = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: widget.currentIndex,
      onTap: _handleTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Ionicons.home_outline), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Ionicons.grid_outline), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Ionicons.heart_outline), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Ionicons.cart_outline), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Ionicons.person_outline), label: 'Profile'),
      ],
    );
  }
}
