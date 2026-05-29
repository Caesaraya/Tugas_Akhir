import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/page/admin/mobile/produk/product_detail_page.dart';
import '../../custom_network_image.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final ProductTableController controller;
  final NumberFormat formatCurrency;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.controller,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleted = product.deletedAt != null;
    Color stockColor = Colors.green;
    if (product.stock == 0) {
      stockColor = Colors.red;
    } else if (product.stock <= 5) {
      stockColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDeleted ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDeleted ? Border.all(color: Colors.grey.shade300) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomNetworkImage(
              imageUrl: product.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              color: isDeleted ? Colors.grey : null,
              colorBlendMode: isDeleted ? BlendMode.saturation : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDeleted
                              ? Colors.grey.shade600
                              : Colors.black,
                          decoration: isDeleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDeleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Arsip",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.jenis,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.discount > 0) ...[
                          Text(
                            formatCurrency.format(product.price),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            formatCurrency.format(product.priceAfterDiscount),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ] else ...[
                          Text(
                            formatCurrency.format(product.price),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDeleted
                                  ? Colors.grey.shade700
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: stockColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${product.stock} ${product.satuan}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          icon: Icons.visibility_outlined,
                          onTap: () =>
                              Get.to(() => ProductDetailPage(product: product)),
                        ),
                        _buildActionButton(
                          icon: Icons.edit_outlined,
                          onTap: () => controller.openEditDialog(product),
                        ),
                        if (isDeleted) ...[
                          _buildActionButton(
                            icon: Icons.settings_backup_restore_rounded,
                            color: Colors.green,
                            onTap: () => controller.confirmRestore(product.id),
                          ),
                          _buildActionButton(
                            icon: Icons.delete_forever_rounded,
                            color: Colors.red.shade900,
                            onTap: () =>
                                controller.confirmForceDelete(product.id),
                          ),
                        ] else ...[
                          _buildActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: Colors.red.shade400,
                            onTap: () =>
                                controller.confirmSoftDelete(product.id),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.black54,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
