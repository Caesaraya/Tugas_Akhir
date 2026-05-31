import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';

class ProductListHeader extends StatelessWidget {
  final ProductTableController controller;

  const ProductListHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', 'Roti', 'Kue', 'Pastry', 'Minuman'];
    final selectedCategory = 'Semua'.obs;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar Atas Penuh
          TableSearchBar(
            controller: controller.searchC,
            hint: 'Cari nama produk...',
          ),
          const SizedBox(height: 12),

          // Horizontal Scroll Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: categories.map((cat) {
                return Obx(() {
                  bool isSelected = selectedCategory.value == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          selectedCategory.value = cat;
                          // Memanggil fungsi search bawaan controller tanpa mengubah strukturnya
                          controller.search(cat == 'Semua' ? '' : cat);
                        }
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade300,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                });
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
