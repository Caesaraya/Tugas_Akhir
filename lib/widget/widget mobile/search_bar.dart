import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;

  const MySearchBar({
    super.key,
    this.hintText = "Cari roti favoritmu...",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.brown.shade200, width: 1.5),
        ),
        // Menambahkan sedikit bayangan agar terlihat menyatu dengan tema kartu
        enabled: true,
      ),
    );
  }
}