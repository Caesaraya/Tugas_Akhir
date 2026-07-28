import 'dart:io';
import 'package:flutter/material.dart';

class BuktiFotoPicker extends StatelessWidget {
  final File? buktiFoto;
  final VoidCallback onTap;

  const BuktiFotoPicker({
    super.key,
    required this.buktiFoto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Bukti Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: buktiFoto != null
                    ? const Color(0xFFE89336)
                    : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: buktiFoto != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.file(buktiFoto!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap untuk pilih foto bukti dari gallery',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}