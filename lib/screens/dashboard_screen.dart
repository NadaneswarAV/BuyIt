import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Awesome App")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                const CircleAvatar(radius: 30, child: Icon(Icons.person, size: 30)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("John Doe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("UX Designer", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Shortcuts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Icon(Icons.home, size: 40),
                Icon(Icons.show_chart, size: 40),
                Icon(Icons.photo, size: 40),
              ],
            ),
            const SizedBox(height: 20),

            // Featured Products
            const Text("Featured Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: const [
                          Text("Product 1", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Lorem ipsum"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: const [
                          Text("Product 2", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Lorem ipsum"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Customer Reviews
            const Text("Customer Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text("Alice"),
                subtitle: Text("Great product! Will buy again."),
                trailing: Icon(Icons.star, color: Colors.yellow),
              ),
            ),
            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text("Bob"),
                subtitle: Text("Excellent service"),
                trailing: Icon(Icons.star, color: Colors.yellow),
              ),
            ),
            const SizedBox(height: 20),

            // Latest Articles
            const Text("Latest Articles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Card(
              child: ListTile(
                title: Text("Article 1"),
                subtitle: Text("Lorem ipsum dolor sit amet"),
                trailing: Icon(Icons.article),
              ),
            ),
            const Card(
              child: ListTile(
                title: Text("Article 2"),
                subtitle: Text("Consectetur adipiscing elit"),
                trailing: Icon(Icons.article),
              ),
            ),
            const SizedBox(height: 20),

            // Performance Metrics
            const Text("Performance Metrics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: const [
                          Text("Revenue", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("\$10,000"),
                          Text("+5%"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: const [
                          Text("Visits", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("1000"),
                          Text("-10%"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
