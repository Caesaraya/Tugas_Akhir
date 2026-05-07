import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_Mobile_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/search_bar.dart';
import 'package:tugas_akhir/widget/widget mobile/section_header.dart';
import 'package:tugas_akhir/widget/widget%20mobile/product_card.dart';

class KasirDashboardMobile extends StatelessWidget {
  KasirDashboardMobile({super.key});
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.fetchProducts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. LOGO
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Image.asset(
                      'assets/Logo_Rumah_Lezaa-removebg-preview.png',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const Text(
                  "Halo, Someone!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Mau pesan roti apa hari ini?",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),

                // 2. SEARCH BAR
                MySearchBar(
                  onChanged: (value) => controller.applyFilter(query: value),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  return Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        String category = controller.categories[index];
                        bool isSelected = controller.selectedCategory.value == category;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            selectedColor: const Color(0xFFE89336),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (_) => controller.applyFilter(category: category),
                          ),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 10),
                SectionHeader(title: "Daftar Menu"),
                const SizedBox(height: 10),
                // 4. DAFTAR PRODUK (GRID VIEW)
                // Menggantikan ProductList horizontal agar tidak overflow
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.filteredList.isEmpty) {
                    return const Center(child: Text("Produk tidak ditemukan"));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Biar ngikut scroll utama
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: controller.filteredList.length,
                    itemBuilder: (context, index) {
                      final product = controller.filteredList[index];
                      // Pastikan kamu punya widget ProductCard yang menerima model Product baru
                      return ProductCard(
                        product: product,
                        tag: product.jenis, 
                      );
                    },
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}