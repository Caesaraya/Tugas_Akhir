import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KalkulatorInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const KalkulatorInput({
    super.key,
    required this.controller,
    required this.onChanged,
    this.keyboardType, 
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
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
        prefixText: "Rp ", 
        prefixStyle: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }
}