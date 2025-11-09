import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_textfield.dart';
import '../widgets/rounded_button.dart';
import 'main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.226.208.163:8000/dj-rest-auth/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username':'nadan','email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Login successful
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => MainNavigation(key: MainNavigation.mainKey),
          ),
          (route) => false,
        );
      } else {
        // Login failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MainNavigation(key: MainNavigation.mainKey),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text("Skip >", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/images/logo1.png', height: 150),
                  const SizedBox(height: 15),
                  const Text(
                    "Welcome Back !",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Shop from your favourite local stores\nWe deliver it to your doorstep!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(hint: "Email", controller: _emailController),
                  CustomTextField(hint: "Password", isPassword: true, controller: _passwordController),
                  const SizedBox(height: 10),
                  const Text(
                    "FORGOT PASSWORD",
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 30),
                  Image.asset('assets/images/character.png', height: 80),
                  const SizedBox(height: 20),
                  RoundedButton(
                    text: _isLoading ? "LOGGING IN..." : "DONE",
                    onPressed: _isLoading ? () {} : _login,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
