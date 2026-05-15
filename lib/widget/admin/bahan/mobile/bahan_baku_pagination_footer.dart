import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';

class BahanBakuPaginationFooter extends StatelessWidget {
  final BahanBakuTableController controller;

  const BahanBakuPaginationFooter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
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
            ),
            Row(
              children: [
                _PageButton(
                  icon: Icons.chevron_left,
                  onTap: controller.currentPage.value > 1
                      ? controller.previousPage
                      : null,
                ),
                const SizedBox(width: 8),
                _PageButton(
                  icon: Icons.chevron_right,
                  onTap:
                      controller.currentPage.value < controller.totalPages.value
                      ? controller.nextPage
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _PageButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: onTap == null ? Colors.grey : Colors.black),
      ),
    );
  }
}
