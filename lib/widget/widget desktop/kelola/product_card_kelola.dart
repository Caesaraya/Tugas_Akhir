import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/kelola/product_image.dart';
import 'package:tugas_akhir/widget/widget desktop/kelola/product_subtitle.dart';

class ProductCardKelola extends StatelessWidget {
  final KelolaProdukController ctrl;
  final dynamic produk;

  const ProductCardKelola({required this.ctrl, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ProductImage(imageUrl: produk.image),
        title: Text(
          produk.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: ProductSubtitle(ctrl: ctrl, produk: produk),
        trailing: ElevatedButton(
          onPressed: () => ctrl.showEditForm(context, produk),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Edit'),
        ),
      ),
    );
  }
}
