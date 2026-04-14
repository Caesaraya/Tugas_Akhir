import 'package:flutter/material.dart';

class KalkulatorInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hint;

  const KalkulatorInput({
    super.key, 
    required this.controller, 
    required this.onChanged,
    this.hint = "0",
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      autofocus: true,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        prefixText: "Rp ",
        hintText: hint,
        // Semua dekorasi rumit ditaruh di sini sekali saja
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
      ),
    );
  }
}