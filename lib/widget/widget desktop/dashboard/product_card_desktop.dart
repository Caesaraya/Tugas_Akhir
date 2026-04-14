import 'package:flutter/material.dart';
import '../../../models/product.dart';

class ProductCardDesktop extends StatelessWidget {
  final Product product;
  final String tag;
  final VoidCallback? onTap;

  const ProductCardDesktop({
    super.key,
    required this.product,
    this.tag = "Roti",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// GAMBAR
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),

            /// NAMA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            /// HARGA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Rp ${product.price.toStringAsFixed(0)}",
                style: const TextStyle(color: Colors.black54),
              ),
            ),

            if (product.discount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Disc ${product.discount.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
