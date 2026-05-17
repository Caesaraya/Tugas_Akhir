import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';

class ProductPaginationFooter extends StatelessWidget {
  final ProductTableController controller;

  const ProductPaginationFooter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Halaman ${controller.currentPage.value} dari ${controller.totalPages.value}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                _PageButton(
                  icon: Icons.chevron_left,
                  onPressed: controller.currentPage.value > 1
                      ? controller.previousPage
                      : null,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5D4037),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${controller.currentPage.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _PageButton(
                  icon: Icons.chevron_right,
                  onPressed:
                      controller.currentPage.value < controller.totalPages.value
                      ? controller.nextPage
                      : null,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _PageButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: onPressed == null ? Colors.grey[100] : Colors.white,
        ),
        child: Icon(
          icon,
          color: onPressed == null ? Colors.grey : Colors.black,
        ),
      ),
    );
  }
}
