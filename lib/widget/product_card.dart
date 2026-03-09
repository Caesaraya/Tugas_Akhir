import 'package:flutter/material.dart';
import '../models/product.dart'; // Sesuaikan path model kamu

class ProductCard extends StatelessWidget {
  final Product product;
  final String tag;

  const ProductCard({
    super.key,
    required this.product,
    this.tag = "Roti",
  });

  @override
  Widget build(BuildContext context) {
    // Ukuran 44% lebar layar supaya pas (tidak kebesaran) di HP
    double cardWidth = MediaQuery.of(context).size.width * 0.44;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 14, bottom: 10, left: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Gambar Produk dari API
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  product.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Muncul saat gambar error atau link mati
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              // Tag Label (Hot/New)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${product.price.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Color(0xFF8B5E3C),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                if (product.discount > 0)
                  Text(
                    "Disc ${product.discount.toStringAsFixed(0)}%",
                    style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}