import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String tag;
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  ProductCard({super.key, required this.product, this.tag = "Roti"});
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = product.discount != null && product.discount! > 0;
    final double originalPrice = product.price.toDouble();
    final double finalPrice =
        (product.priceAfterDiscount != null && product.priceAfterDiscount! > 0)
        ? product.priceAfterDiscount!.toDouble()
        : originalPrice;
    final bool outOfStock = product.stock <= 0;

    return GestureDetector(
      onTap: outOfStock
          ? null
          : () {
              cartController.addToCart(product);
              Get.snackbar(
                "Berhasil",
                "${product.name} ditambah ke keranjang",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black87,
                colorText: Colors.white,
                duration: const Duration(milliseconds: 800),
                margin: const EdgeInsets.all(10),
              );
            },
      child: Opacity(
        opacity: outOfStock ? 0.5 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(right: 12, bottom: 10, left: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
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
              // ── Gambar + badge ──────────────────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.network(
                      product.image,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 130,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Badge jenis
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                  // Badge diskon
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${product.discount}% OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Badge habis
                  if (outOfStock)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: const Text(
                          'Stok Habis',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // ── Info produk ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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

                    // Harga
                    if (hasDiscount) ...[
                      Text(
                        currencyFormatter.format(originalPrice),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        currencyFormatter.format(finalPrice),
                        style: const TextStyle(
                          color: Color(0xFFE89336),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ] else ...[
                      Text(
                        currencyFormatter.format(originalPrice),
                        style: const TextStyle(
                          color: Color(0xFFE89336),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],

                    const SizedBox(height: 4),

                    // ── Stok ────────────────────────────────────────────
                    Row(
                      children: [
                        const SizedBox(width: 3),
                        Text(
                          outOfStock
                              ? 'Stok habis'
                              : 'Stok: ${product.stock} ${product.satuan}',
                          style: TextStyle(
                            color: product.stock < 10
                                ? Colors.red
                                : Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
