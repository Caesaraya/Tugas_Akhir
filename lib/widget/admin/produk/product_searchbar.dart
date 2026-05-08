// lib/views/widgets/product/product_search_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/produk_admin_controller.dart';

class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({super.key, required this.ctrl});

  final ProductController ctrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 44,
      child: TextField(
        controller: ctrl.searchController,
        onChanged: ctrl.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Cari Produk',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: Obx(
            () => ctrl.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: ctrl.clearSearch,
                  )
                : const SizedBox.shrink(),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF26C6DA)),
          ),
        ),
      ),
    );
  }
}
