import 'package:flutter/material.dart';
import 'contact_info_card.dart';
import 'change_password_tile.dart';
import 'manage_addresses_tile.dart';
import 'notification_preferences_tile.dart';
import 'payment_methods_tile.dart';
import 'logout_tile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_profile_dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final response = await http.get(
        Uri.parse('https://webhook.site/8288d55b-8055-423d-bde5-a3b02b6bfd9f'),
      );
      if (response.statusCode == 200) {
        setState(() {
          profileData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = "Failed to load profile";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error: $e";
        isLoading = false;
      });
    }
  }

void _showEditProfileDialog() {
  showDialog(
    context: context,
    builder: (context) => EditProfileDialog(
      initialEmail: profileData?['email'] ?? '',
      initialPhone: profileData?['phone'] ?? '',
      onSave: (email, phone) {
        setState(() {
          profileData?['email'] = email;
          profileData?['phone'] = phone;
        });
        // Here you can add API/database update logic later
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView(
                  children: [
                    // Profile header/banner
                    Image.asset(
                      'assets/figma/Profile.png',
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => SizedBox.shrink(),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ContactInfoCard(
                        email: profileData?['email'] ?? '',
                        phone: profileData?['phone'] ?? '',
                        onEdit: _showEditProfileDialog,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ChangePasswordTile(),
                    ManageAddressesTile(),
                    NotificationPreferencesTile(),
                    PaymentMethodsTile(),
                    LogoutTile(),
                  ],
                ),
    );
  }
}