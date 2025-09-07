// shoppe_flutter_main.dart
// A starting Flutter app that implements a simplified version of the "Shoppe" UI
// You can paste this file into `lib/main.dart` of a new Flutter project.

// --- pubspec.yaml (add these deps & assets) ---
/*
name: shoppe_app
description: A starter for the Shoppe eCommerce UI
publish_to: 'none'
version: 0.0.1

environment:
  sdk: '>=2.18.0 <3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  google_fonts: ^4.0.3

flutter:
  uses-material-design: true
  assets:
    - assets/images/
*/

// If you have the zip you uploaded, unzip its images into `assets/images/`.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ShoppeApp());
}

class ShoppeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoppe',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  @override
  _MainShellState createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selected = 0;

  final _pages = [HomeScreen(), AnalyticsScreen(), GalleryScreen(), CategoriesScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selected,
        onTap: (i) => setState(() => _selected = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: 'Gallery'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ------------------------- Home Screen -------------------------
class HomeScreen extends StatelessWidget {
  final List<Product> featured = List.generate(
    6,
    (i) => Product(
      id: i,
      name: 'Product ${i + 1}',
      price: (17 + i * 10).toDouble(),
      image: 'assets/images/product_${(i % 4) + 1}.png',
      isNew: i % 2 == 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Awesome App', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('John Doe — UX Designer', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                  Row(children: [IconButton(onPressed: () {}, icon: Icon(Icons.search)), IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))])
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryChip(label: 'All'),
                        CategoryChip(label: 'Female'),
                        CategoryChip(label: 'Male'),
                        CategoryChip(label: 'Dresses'),
                        CategoryChip(label: 'Tops'),
                        CategoryChip(label: 'Bottoms'),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                  Text('Featured Products', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 12, mainAxisSpacing: 12),
                    itemCount: featured.length,
                    itemBuilder: (context, idx) {
                      final p = featured[idx];
                      return ProductCard(product: p);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  CategoryChip({required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.pink[50],
      ),
    );
  }
}

// ------------------------- Product Card -------------------------
class ProductCard extends StatelessWidget {
  final Product product;
  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(product: product))),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey[200]),
                  child: Center(
                    child: productImageWidget(product.image),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget productImageWidget(String path) {
  // If you don't have assets yet, this will show an Icon placeholder.
  return Image.asset(
    path,
    fit: BoxFit.contain,
    errorBuilder: (_, __, ___) => Icon(Icons.image, size: 48, color: Colors.grey),
  );
}

// ------------------------- Product Detail -------------------------
class ProductDetail extends StatelessWidget {
  final Product product;
  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, foregroundColor: Colors.black, title: Text(product.name)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 300,
              child: productImageWidget(product.image),
            ),
            SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(product.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)), Text('\$${product.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18))]),
            SizedBox(height: 8),
            Text('Pink, Size M', style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 12),
            Expanded(child: SingleChildScrollView(child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'))),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => showModalBottomSheet(context: context, builder: (_) => CheckoutSheet(product: product)),
                  child: Text('Buy Now'),
                )),
                SizedBox(width: 12),
                ElevatedButton(onPressed: () {}, child: Icon(Icons.add_shopping_cart)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CheckoutSheet extends StatelessWidget {
  final Product product;
  CheckoutSheet({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          ListTile(leading: Icon(Icons.location_on), title: Text('26, Duong So 2, Thao Dien Ward'), subtitle: Text('Ho Chi Minh City')),
          SizedBox(height: 8),
          Row(children: [Expanded(child: Text('\$${product.price.toStringAsFixed(2)}')), ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Pay'))])
        ],
      ),
    );
  }
}

// ------------------------- Other Screens (stubs) -------------------------
class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CenterScreen(title: 'Analytics');
  }
}

class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CenterScreen(title: 'Gallery');
  }
}

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CenterScreen(title: 'Categories');
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CenterScreen(title: 'Profile');
  }
}

class CenterScreen extends StatelessWidget {
  final String title;
  CenterScreen({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title screen')),
    );
  }
}

// ------------------------- Models -------------------------
class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final bool isNew;
  Product({required this.id, required this.name, required this.price, required this.image, this.isNew = false});
}

/*
--- How to use this starter ---
1. Create a new Flutter project: `flutter create shoppe_app`.
2. Replace `lib/main.dart` with the code from this file.
3. Add `google_fonts` to pubspec.yaml (see top comment) and add asset images under `assets/images/`.
   If you uploaded a ZIP (Shoppe - eCommerce...zip) to the environment, unzip its images into that folder.
4. Run `flutter pub get` and then `flutter run`.

--- Next steps I can help with (pick any):
- Convert more screens from the Figma design into Flutter widgets (cart, wishlist, filters, payment flows).
- Add state management (Provider / Riverpod / Bloc) and implement cart logic.
- Implement authentication screen and forms.
- Implement real API integration and product models.
- Polish styles, animations, and transitions.

Tell me which area you want next and I will continue building it.
*/
