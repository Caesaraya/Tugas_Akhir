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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Search Bar Utama
          TableSearchBar(
            controller: controller.searchC,
            hint: 'Cari nama produk...',
            // Jika TableSearchBar mendukung onChanged, kamu bisa pasang:
            // onChanged: (val) => controller.search(val),
          ),
          const SizedBox(height: 12),

          // 2. Kategori Pilihan (Pill/Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                          if (cat == 'Semua') {
                            controller.search('');
                          } else {
                            controller.search(cat);
                          }
                        }
                      },
                      selectedColor: Colors.black,
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
