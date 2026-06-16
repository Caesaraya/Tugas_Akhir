import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/resep.dart';

class ResepItemCard extends StatelessWidget {
  final Resep resep;
  final VoidCallback onTap;

  const ResepItemCard({super.key, required this.resep, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDeleted = resep.deletedAt != null;

    return Card(
      elevation: isDeleted ? 0 : 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDeleted
            ? BorderSide(color: Colors.red.withOpacity(0.3), width: 1)
            : BorderSide.none,
      ),
      color: isDeleted ? Colors.grey.shade100 : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isDeleted
                    ? Colors.grey.shade300
                    : Colors.brown.shade50,
                radius: 22,
                child: Icon(
                  Icons.restaurant_menu,
                  color: isDeleted
                      ? Colors.grey.shade600
                      : const Color(0xFF5D4037),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resep.namaResep,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDeleted ? Colors.grey.shade500 : Colors.black,
                        decoration: isDeleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resep.deskripsi.isEmpty
                          ? "Tidak ada deskripsi"
                          : resep.deskripsi,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDeleted
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDeleted
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isDeleted ? "DIHAPUS" : "AKTIF",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDeleted
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
