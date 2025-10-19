// import 'package:flutter/material.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   // Dummy cart data
//   List<Map<String, dynamic>> cartItems = [
//     {
//       'store': "Jeswin’s Mart",
//       'rating': 4.8,
//       'distance': '2.3 km',
//       'product': 'Fresh Apples',
//       'description': 'Red Delicious',
//       'price': 3.99,
//       'quantity': 3,
//     },
//     {
//       'store': "WeMart",
//       'rating': 4.8,
//       'distance': '2.3 km',
//       'product': 'Fresh Carrot',
//       'description': 'Freshly taken',
//       'price': 7.19,
//       'quantity': 1,
//     },
//   ];

//   double deliveryFee = 5.00;

//   double get itemsTotal {
//     return cartItems.fold(
//       0.0,
//       (sum, item) => sum + (item['price'] * item['quantity']),
//     );
//   }

//   double get totalCharge => itemsTotal + deliveryFee;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Cart', style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ...cartItems.map((item) => _buildCartItem(item)).toList(),
//             const SizedBox(height: 20),
//             _buildDeliveryDetails(),
//             const SizedBox(height: 20),
//             _buildBottomButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCartItem(Map<String, dynamic> item) {
//     return Card(
//       elevation: 0,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             // Placeholder image box
//             Container(
//               height: 70,
//               width: 70,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.shopping_bag_outlined,
//                 size: 35,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         item['store'],
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 3,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade100,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Text(
//                           "Open",
//                           style: TextStyle(color: Colors.green, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.orange, size: 16),
//                       Text(" ${item['rating']} "),
//                       Text(
//                         "• ${item['distance']}",
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     item['product'],
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   Text(
//                     item['description'],
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   Text(
//                     "₹${item['price']}/kg",
//                     style: const TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.delete_outline),
//                   onPressed: () {
//                     setState(() => cartItems.remove(item));
//                   },
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.remove_circle_outline),
//                       onPressed: () {
//                         setState(() {
//                           if (item['quantity'] > 1) item['quantity']--;
//                         });
//                       },
//                     ),
//                     Text(
//                       item['quantity'].toString(),
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add_circle_outline),
//                       onPressed: () {
//                         setState(() {
//                           item['quantity']++;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeliveryDetails() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         children: [
//           _buildDeliveryRow("Item Total", "₹${itemsTotal.toStringAsFixed(2)}"),
//           _buildDeliveryRow("Estimated Delivery", "30–40 min"),
//           _buildDeliveryRow(
//             "Delivery Fee",
//             "₹${deliveryFee.toStringAsFixed(2)}",
//           ),
//           const Divider(),
//           _buildDeliveryRow(
//             "Total Charge",
//             "₹${totalCharge.toStringAsFixed(2)}",
//             isBold: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDeliveryRow(String label, String value, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomButtons() {
//     return Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             onPressed: () {},
//             style: OutlinedButton.styleFrom(
//               side: const BorderSide(color: Colors.green),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: const Text(
//               "Continue Shopping",
//               style: TextStyle(color: Colors.green),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: const Text("Proceed To Checkout"),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Dummy cart data
  List<Map<String, dynamic>> cartItems = [
    {
      'store': "Jeswin’s Mart",
      'rating': 4.8,
      'distance': '2.3 km',
      'product': 'Fresh Apples',
      'description': 'Red Delicious',
      'price': 3.99,
      'quantity': 3,
    },
    {
      'store': "WeMart",
      'rating': 4.8,
      'distance': '2.3 km',
      'product': 'Fresh Carrot',
      'description': 'Freshly taken',
      'price': 7.19,
      'quantity': 1,
    },
  ];

  double deliveryFee = 5.00;
  int selectedIndex = 3; // Cart selected

  double get itemsTotal => cartItems.fold(
    0.0,
    (sum, item) => sum + (item['price'] * item['quantity']),
  );

  double get totalCharge => itemsTotal + deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...cartItems.map((item) => _buildCartItem(item)).toList(),
            const SizedBox(height: 20),
            _buildDeliveryDetails(),
            const SizedBox(height: 20),
            _buildBottomButtons(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 35,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        // ✅ makes text shrink instead of overflow
                        child: Text(
                          item['store'],
                          overflow:
                              TextOverflow.ellipsis, // ✅ truncates long text
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8), // ✅ small gap before "Open"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Open",
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(" ${item['rating']} "),
                      Text(
                        "• ${item['distance']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    item['product'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    item['description'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "₹${item['price']}/kg",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => setState(() => cartItems.remove(item)),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (item['quantity'] > 1) item['quantity']--;
                        });
                      },
                    ),
                    Text(
                      item['quantity'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() => item['quantity']++);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDeliveryRow("Item Total", "₹${itemsTotal.toStringAsFixed(2)}"),
          _buildDeliveryRow("Estimated Delivery", "30–40 min"),
          _buildDeliveryRow(
            "Delivery Fee",
            "₹${deliveryFee.toStringAsFixed(2)}",
          ),
          const Divider(),
          _buildDeliveryRow(
            "Total Charge",
            "₹${totalCharge.toStringAsFixed(2)}",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Continue Shopping",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Proceed To Checkout"),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomNavBar(
      currentIndex: 3,
      onTap: (index) {
        // Navigation handled by MainNavigation
      },
    );
  }
}
