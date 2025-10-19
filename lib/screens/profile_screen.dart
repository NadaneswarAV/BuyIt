// import 'package:flutter/material.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   int _selectedIndex = 4; // Profile tab selected

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Your profile',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),

//       // Scrollable Body
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 10),

//             // Profile Picture
//             Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 const CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage('assets/profile.jpg'),
//                 ),
//                 Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: const Icon(
//                       Icons.camera_alt,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     onPressed: () {},
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "Change Photo",
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 20),

//             sectionTitle("Personal Information"),
//             profileField("Full Name", "Sarah Johnson"),
//             profileField("Email", "sarah.johnson@email.com"),
//             profileField("Phone Number", "+91 940052 6562"),
//             profileFieldWithIcon(
//               "Date of Birth",
//               "1992-03-15",
//               Icons.calendar_today,
//             ),

//             const SizedBox(height: 16),
//             sectionTitle("Saved Delivery Address"),
//             profileField("Street Address", "123 Main Street"),
//             profileField("City", "New York"),
//             profileField("ZIP Code", "10001"),

//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   "Save Changes",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   side: const BorderSide(color: Colors.grey),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   "Cancel",
//                   style: TextStyle(color: Colors.black, fontSize: 16),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextButton(
//               onPressed: () {},
//               child: const Text(
//                 "Logout",
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),

//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.grid_view_rounded),
//             label: '',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart_outlined),
//             label: '',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
//         ],
//       ),
//     );
//   }

//   Widget sectionTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 8),
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget profileField(String label, String value) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
//           const SizedBox(height: 3),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget profileFieldWithIcon(String label, String value, IconData icon) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(color: Colors.grey, fontSize: 13),
//               ),
//               const SizedBox(height: 3),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           Icon(icon, size: 20, color: Colors.grey),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;

  // Controllers
  final TextEditingController _nameController = TextEditingController(
    text: "Sarah Johnson",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "sarah.johnson@email.com",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+91 940052 6562",
  );
  final TextEditingController _dobController = TextEditingController(
    text: "1992-03-15",
  );
  final TextEditingController _streetController = TextEditingController(
    text: "123 Main Street",
  );
  final TextEditingController _cityController = TextEditingController(
    text: "New York",
  );
  final TextEditingController _zipController = TextEditingController(
    text: "10001",
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dobController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Dummy API call
  Future<void> _saveProfile() async {
    final data = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "dob": _dobController.text,
      "street": _streetController.text,
      "city": _cityController.text,
      "zip": _zipController.text,
    };

    const url = "https://jsonplaceholder.typicode.com/posts"; // dummy API
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update profile")));
    }

    // Just to see data in console
    print("Data sent: $data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Your profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Scrollable body
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // Profile image
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/temp/profile.jpg'),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Change Photo",
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            sectionTitle("Personal Information"),
            editableField("Full Name", _nameController),
            editableField("Email", _emailController),
            editableField("Phone Number", _phoneController),
            editableFieldWithIcon(
              "Date of Birth",
              _dobController,
              Icons.calendar_today,
              () {
                _selectDate(context);
              },
            ),

            const SizedBox(height: 16),
            sectionTitle("Saved Delivery Address"),
            editableField("Street Address", _streetController),
            editableField("City", _cityController),
            editableField("ZIP Code", _zipController),

            const SizedBox(height: 30),

            // Save & Cancel buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _saveProfile,
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Changes canceled")),
                  );
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 5),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget editableField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  Widget editableFieldWithIcon(
    String label,
    TextEditingController controller,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          suffixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
