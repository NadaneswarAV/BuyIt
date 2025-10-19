import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../screens/main_navigation.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

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
    widget.onTap(index);
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
