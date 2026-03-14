import 'package:flutter/material.dart';

// Widget 1: Icon dan Text Status
class SuccessHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade500,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.check, size: 80, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text("Sukses!", 
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green.shade600)),
      ],
    );
  }
}

// Widget 2: Baris Informasi Ringkasan
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const InfoRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(
            fontSize: 18, 
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal
          )),
        ],
      ),
    );
  }
}

// Widget 3: Tombol Aksi (Print & Selesai)
class SuccessActions extends StatelessWidget {
  final VoidCallback onPrint;
  final VoidCallback onFinish;

  const SuccessActions({required this.onPrint, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onPrint,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.grey.shade200,
              side: BorderSide.none
            ),
            child: const Text("Print Nota", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: onFinish,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.orange.shade400,
              elevation: 0
            ),
            child: const Text("Selesai", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}