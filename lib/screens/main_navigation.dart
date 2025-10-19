import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favourites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'shops_near_you_screen.dart';
import 'fresh_market_screen.dart';
import '../widgets/bottom_navbar.dart';

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
  int _previousIndex = 0;
  final List<int> _tabHistory = <int>[];

  final GlobalKey<NavigatorState> _homeTabKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _tabHistory.clear();
    _tabHistory.add(_selectedIndex);
    MainNavigation.instance = this;
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
      // push to history if different from last to avoid loops
      if (_tabHistory.isEmpty || _tabHistory.last != index) {
        _tabHistory.add(index);
      }
      // update global fallbacks
      MainNavigation.previousTabIndex = _previousIndex;
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
      setState(() {
        _previousIndex = _selectedIndex;
        _selectedIndex = target;
        MainNavigation.previousTabIndex = _previousIndex;
        MainNavigation.currentTabIndex = _selectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home tab with nested navigator to preserve bottom nav on subpages
          _HomeTabNavigator(navigatorKey: _homeTabKey),
          const CategoriesScreen(),
          const FavouritesScreen(),
          const CartScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

class _HomeTabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const _HomeTabNavigator({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        switch (settings.name) {
          case '/shopsNearYou':
            page = const ShopsNearYouPage();
            break;
          case '/freshMarket':
            page = const FreshMarketScreen();
            break;
          case '/':
          default:
            page = const HomeScreen();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
