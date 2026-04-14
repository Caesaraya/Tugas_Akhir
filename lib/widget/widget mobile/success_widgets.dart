import 'package:flutter/material.dart';

// Widget 1: Icon dan Text Status
class SuccessHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
    

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