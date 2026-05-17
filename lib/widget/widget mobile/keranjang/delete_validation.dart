import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteValidation {
  static void show({
    required String productName,
    required VoidCallback onConfirm,
  }) {
    Get.defaultDialog(
      title: "Hapus Produk",
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      radius: 20,
      // Bagian Isi Dialog
      content: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 50),
          const SizedBox(height: 15),
          Text(
            "Yakin ingin menghapus $productName dari keranjang?",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
      // Tombol Aksi
      confirm: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onConfirm,
          child: const Text("Hapus", style: TextStyle(color: Colors.white)),
        ),
      ),
      cancel: SizedBox(
        width: 100,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Get.back(),
          child: const Text("Batal", style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}