import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class ProductDetailBody extends StatelessWidget {
  final Product product;
  final NumberFormat currency;

  const ProductDetailBody({
    super.key,
    required this.product,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailImage(product: product),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailHeader(product: product),
                  const SizedBox(height: 10),
                  if (product.discount > 0)
                    ProductPriceDiscount(product: product, currency: currency),
                  Text(
                    currency.format(product.priceAfterDiscount),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF5D4037),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 40),
                  const Text(
                    'Informasi Detail',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  ProductDetailFieldRow(
                    label: 'ID Produk',
                    value: '#${product.id}',
                  ),
                  ProductDetailFieldRow(
                    label: 'Kategori/Jenis',
                    value: product.jenis,
                  ),
                  ProductDetailFieldRow(
                    label: 'Stok Tersedia',
                    value: '${product.stock} ${product.satuan}',
                  ),
                  ProductDetailFieldRow(
                    label: 'Satuan Jual',
                    value: product.satuan,
                  ),
                  ProductDetailFieldRow(
                    label: 'Potongan Harga',
                    value: currency.format(
                      product.price - product.priceAfterDiscount,
                    ),
                  ),
                  ProductDetailFieldRow(
                    label: 'Status Resep',
                    value: product.resepId != null
                        ? 'Terhubung (ID: ${product.resepId})'
                        : 'Tanpa Resep',
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Catatan / Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Produk ini termasuk dalam kategori ${product.jenis}. Pastikan stok selalu tersedia minimal 5 ${product.satuan} untuk menjaga ketersediaan.',
                    style: const TextStyle(color: Colors.grey, height: 1.5),
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

class ProductDetailImage extends StatelessWidget {
  final Product product;

  const ProductDetailImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'prod_${product.id}',
      child: Image.network(
        product.image,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 250,
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, size: 50),
        ),
      ),
    );
  }
}

class ProductDetailHeader extends StatelessWidget {
  final Product product;

  const ProductDetailHeader({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ProductDetailBadge(label: product.jenis),
      ],
    );
  }
}

class ProductPriceDiscount extends StatelessWidget {
  final Product product;
  final NumberFormat currency;

  const ProductPriceDiscount({
    super.key,
    required this.product,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          currency.format(product.price),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '-${product.discount}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class ProductDetailBadge extends StatelessWidget {
  final String label;

  const ProductDetailBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF5D4037),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProductDetailFieldRow extends StatelessWidget {
  final String label;
  final String value;

  const ProductDetailFieldRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ProductDetailActions extends StatelessWidget {
  final Product product;
  final ProductTableController controller;

  const ProductDetailActions({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ToolbarButton(
              title: 'Edit',
              icon: Icons.edit_outlined,
              color: const Color(0xFF5D4037),
              onTap: () => controller.openEditDialog(product),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ToolbarButton(
              title: 'Hapus',
              icon: Icons.delete_outline,
              color: Colors.red,
              onTap: () => controller.deleteData(product.id),
            ),
          ),
        ],
      ),
    );
  }
}
