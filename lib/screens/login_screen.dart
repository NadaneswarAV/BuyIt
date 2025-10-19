import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/rounded_button.dart';
import 'main_navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                  const CustomTextField(hint: "Email"),
                  const CustomTextField(hint: "Password", isPassword: true),
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
                    text: "DONE",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MainNavigation(key: MainNavigation.mainKey),
                        ),
                        (route) => false,
                      );
                    },
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
