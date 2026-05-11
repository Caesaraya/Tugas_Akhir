// lib/views/widgets/product/product_refresh_button.dart
import 'package:flutter/material.dart';

class ProductRefreshButton extends StatelessWidget {
  const ProductRefreshButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF4CAF50),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.refresh, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
