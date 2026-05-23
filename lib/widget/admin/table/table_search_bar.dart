import 'package:flutter/material.dart';

class TableSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const TableSearchBar({
    super.key,
    required this.controller,
    this.hint = "Cari bahan baku...",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 42,
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1E1E1E), width: 1.5),
          ),
        ),
      ),
    );
  }
}
