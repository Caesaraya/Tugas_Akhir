import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // WAJIB ADA untuk FilteringTextInputFormatter

class KalkulatorInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  // TAMBAHKAN DUA BARIS INI:
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const KalkulatorInput({
    super.key,
    required this.controller,
    required this.onChanged,
    this.keyboardType, // Tambahkan di constructor
    this.inputFormatters, // Tambahkan di constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      // PASANG DI TEXTFIELD:
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: "0",
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixText: "Rp ", // Biar otomatis ada tulisan Rp di depan input
        prefixStyle: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }
}