import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String tag;

  ProductCard({super.key, required this.product, this.tag = "Baru"});

  final CartController cartController = Get.find<CartController>();

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = product.discount != null && product.discount! > 0;

    final double originalPrice = product.price.toDouble();

    final double finalPrice =
        (product.priceAfterDiscount != null && product.priceAfterDiscount! > 0)
        ? product.priceAfterDiscount!.toDouble()
        : originalPrice;

    final bool outOfStock = product.stock <= 0;

    return Obx(() {
      final qty = cartController.cartItems
          .where((item) => item.productId == product.id)
          .fold<int>(0, (sum, item) => sum + item.qty);

      return InkWell(
        borderRadius: BorderRadius.circular(12),
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
          opacity: outOfStock ? 0.5 : 1,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          product.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.white,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        ),
                      ),

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

                      // Stok Habis
                      if (outOfStock)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            color: Colors.black54,
                            child: const Text(
                              "Stok Habis",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 34,
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 2),

                      if (hasDiscount)
                        Row(
                          children: [
                            Text(
                              currencyFormat.format(originalPrice),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${product.discount!.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                      Text(
                        currencyFormat.format(finalPrice),
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
                            outOfStock
                                ? "Stok Habis"
                                : "Stok: ${product.stock} ${product.satuan}",
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
    });
  }
}
