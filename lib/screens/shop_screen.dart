import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"icon": "🚗", "label": "Cars"},
    {"icon": "🏢", "label": "Real Estate"},
    {"icon": "👕", "label": "Clothes"},
    {"icon": "🏃", "label": "Sports"},
    {"icon": "🎨", "label": "Art"},
  ];

  final List<Map<String, String>> newlyListed = [
    {"image": "assets/images/camera.png", "title": "GoPro HERO12 Black", "price": "₹27,990"},
    {"image": "assets/images/bike.png", "title": "Royal Enfield Thunderbird", "price": "₹78,000"},
  ];

  final List<Map<String, dynamic>> mostPopular = [
    {"image": "assets/images/dress1.png", "likes": 1001},
    {"image": "assets/images/dress2.png", "likes": 999},
    {"image": "assets/images/watch.png", "likes": 123},
    {"image": "assets/images/watch2.png", "likes": 1324},
    {"image": "assets/images/lantern.png", "likes": 5645},
    {"image": "assets/images/lights.png", "likes": 5765},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text("See All"),
                )
              ],
            ),
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          child: Text(categories[index]["icon"]!, style: const TextStyle(fontSize: 20)),
                        ),
                        Text(categories[index]["label"]!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Newly Listed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Newly Listed", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text("See All"),
                )
              ],
            ),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newlyListed.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(newlyListed[index]["image"]!, height: 100, width: 150, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(newlyListed[index]["title"]!, maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(newlyListed[index]["price"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Most Popular
            const Text("Most Popular", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: mostPopular.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(mostPopular[index]["image"], fit: BoxFit.cover, width: double.infinity),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: Colors.blue, size: 18),
                          const SizedBox(width: 4),
                          Text("${mostPopular[index]["likes"]}"),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
