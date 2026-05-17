import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/resep.dart';

class ResepItemCard extends StatelessWidget {
  final Resep resep;
  final VoidCallback onTap;

  const ResepItemCard({super.key, required this.resep, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.brown.shade100,
          child: const Icon(Icons.restaurant, color: Color(0xFF5D4037)),
        ),
        title: Text(
          resep.namaResep,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          resep.deskripsi,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
