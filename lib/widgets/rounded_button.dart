import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double horizontalPadding;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF1B1C4A), // dark purple
    this.textColor = Colors.white,
    this.horizontalPadding = 100,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        elevation: 4,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
