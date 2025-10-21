import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favourites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

// A list of keys, one for each tab, to control navigation stacks independently.
final List<GlobalKey<NavigatorState>> _navigatorKeys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];
class MainNavigation extends StatefulWidget {
  static final GlobalKey<_MainNavigationState> mainKey = GlobalKey<_MainNavigationState>();
  // Track tab history globally as a fallback when the key is unavailable
  static int currentTabIndex = 0;
  static int previousTabIndex = 0;
  static _MainNavigationState? instance;
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;
  late int _previousIndex;
  final List<int> _tabHistory = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabHistory.clear();
    _tabHistory.add(_selectedIndex);
    MainNavigation.instance = this;
    _previousIndex = _selectedIndex;
  }

  void _onItemTapped(int index) {
    // If the user is re-selecting the same tab, pop to the first route in that tab's navigator.
    if (index == _selectedIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }

    setState(() {
      int previousIndex = _selectedIndex;
      _selectedIndex = index;
      // push to history if different from last to avoid loops
      if (_tabHistory.isEmpty || _tabHistory.last != index) {
        _tabHistory.add(index);
      }
      // update global fallbacks
      MainNavigation.previousTabIndex = previousIndex;
      MainNavigation.currentTabIndex = _selectedIndex;
    });
  }

  // Public API to switch tabs programmatically
  void setIndex(int index) {
    _onItemTapped(index);
  }

  // Public API to go back to previous tab if any
  void goToPreviousTab() {
    if (_tabHistory.length > 1) {
      // pop current
      _tabHistory.removeLast();
      final int target = _tabHistory.last;
      setState(() { // Use setState to trigger a rebuild
        _previousIndex = _selectedIndex;
        _selectedIndex = target;
        MainNavigation.previousTabIndex = _previousIndex;
        MainNavigation.currentTabIndex = _selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if the current tab's navigator can pop.
        final canPop = await _navigatorKeys[_selectedIndex].currentState?.maybePop() ?? false;
        if (!canPop) {
          // If it can't pop, try to go to the previous tab.
          if (_tabHistory.length > 1) {
            goToPreviousTab();
            return false; // Prevent app from closing.
          }
        }
        return !canPop; // Allow app to close if there's nothing to pop.
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            _buildOffstageNavigator(0, const HomeScreen()),
            _buildOffstageNavigator(1, const CategoriesScreen()),
            _buildOffstageNavigator(2, const FavouritesScreen()),
            _buildOffstageNavigator(3, const CartScreen()),
            _buildOffstageNavigator(4, const ProfileScreen()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view_rounded), label: 'Categories'),
            const BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_, cart, child) => Badge(
                  label: Text(cart.itemCount.toString()),
                  isLabelVisible: cart.itemCount > 0,
                  child: child,
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: const Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget initialRoute) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => initialRoute,
          );
        },
      ),
    );
  }
}
