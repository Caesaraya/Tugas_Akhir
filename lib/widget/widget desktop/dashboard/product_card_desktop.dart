import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:intl/intl.dart';
 
class ProductCardDesktop extends StatelessWidget {
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
 
  final Product product;
  final String tag;
  final VoidCallback? onTap;
 
  ProductCardDesktop({
    super.key,
    required this.product,
    this.tag = "Baru",
    this.onTap,
  });
 
  final CartController cartController = Get.find<CartController>();
 
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ── Hitung qty produk ini di keranjang ─────────────────────────
      final qty = cartController.cartItems
          .where((item) => item.productId == product.id)
          .fold<int>(0, (sum, item) => sum + item.qty);
 
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Gambar + badge qty ────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12)),
                      child: Image.network(
                        product.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey),
                        ),
                      ),
                    ),
 
                    // Badge qty — muncul jika produk ada di keranjang
                    if (qty > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              qty.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
 
                    // Badge stok habis
                    if (product.stock <= 0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          color: Colors.black54,
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
              ),
 
              // ── Info produk ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (product.discount > 0)
                      Row(
                        children: [
                          Text(
                            currencyFormat.format(product.price),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${product.discount.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    Text(
                      currencyFormat.format(product.priceAfterDiscount),
                      style: const TextStyle(
                        color: Color(0xFFE89336),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.jenis.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 9,
                            ),
                          ),
                        ),
                        Text(
                          "Stok: ${product.stock} ${product.satuan}",
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
      );
    });
  }
}