import 'package:flutter/material.dart';

class QuickChip extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const QuickChip({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
        ),
        child: Text(text),
      ),
    );
  }
}