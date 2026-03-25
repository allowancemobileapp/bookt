import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CyberpunkText extends StatelessWidget {
  final String text;
  final double fontSize;

  const CyberpunkText({super.key, required this.text, this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF08F7FE), // Neon aqua
      highlightColor: const Color(0xFF5CFFFE), // A lighter variant
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono', // Or your preferred font
        ),
      ),
    );
  }
}
