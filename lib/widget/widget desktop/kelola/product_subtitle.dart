import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';

class ProductSubtitle extends StatelessWidget {
  final KelolaProdukController ctrl;
  final dynamic produk;
 
  const ProductSubtitle({required this.ctrl, required this.produk});
 
  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = (produk.discount ?? 0) > 0;
 
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasDiscount) ...[
            Text(
              ctrl.currencyFormatter.format(produk.price),
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Text(
              ctrl.currencyFormatter.format(produk.priceAfterDiscount),
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ] else ...[
            Text(
              ctrl.currencyFormatter.format(produk.price),
              style: const TextStyle(
                color: Color(0xFFE89336),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
          const SizedBox(height: 2),
          Text(
            'Stok: ${produk.stock} ${produk.satuan} | ${produk.jenis.toUpperCase()}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}