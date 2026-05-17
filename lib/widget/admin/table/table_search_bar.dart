import 'package:flutter/material.dart';

class TableSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const TableSearchBar({
    super.key,
    required this.controller,
    this.hint = "Cari data",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
