import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambahkan ini
import 'package:tugas_akhir/controller/cart_controller.dart'; // Tambahkan ini
import 'package:tugas_akhir/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String tag;

   ProductCard({super.key, required this.product, this.tag = "Roti"});
   final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
   

    return GestureDetector(
      onTap: () => cartController.addToCart(product),
      child: Container(
        width: 180, // Lebar tetap agar sinkron dengan ProductList
        margin: const EdgeInsets.only(right: 12, bottom: 10, left: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // OUTLINE: Memastikan garis tepi terlihat jelas
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18), // Sedikit lebih kecil dari Container (20 - border)
                  ),
                  child: Image.network(
                    product.image,
                    height: 130, // Tinggi gambar proporsional
                    width: double.infinity,
                    fit: BoxFit.cover, // MEMASTIKAN GAMBAR PENUH
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 130,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp ${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Color(0xFFE89336), // Warna orange bakery
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (product.discount > 0)
                    Text(
                      "Disc ${product.discount.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}