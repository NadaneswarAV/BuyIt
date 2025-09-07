import 'package:flutter/material.dart';
import 'auth_screen.dart';

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
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: AuthScreen(), // first screen = login/create account
    );
  }
}
