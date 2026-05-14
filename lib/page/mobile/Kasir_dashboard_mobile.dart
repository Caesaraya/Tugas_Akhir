import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/search_bar.dart';
import 'package:tugas_akhir/widget/widget mobile/section_header.dart';
import 'package:tugas_akhir/widget/widget%20mobile/product_card.dart';
import 'package:intl/intl.dart';

class KasirDashboardMobile extends StatelessWidget {
  KasirDashboardMobile({super.key});
  final DashboardController controller = Get.put(DashboardController());
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        length: controller.categories.length,
        child: Scaffold(
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Mau pesan apa hari ini?",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    MySearchBar(
                      onChanged: (value) =>
                          controller.applyFilter(query: value),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorColor: Colors.orange,
                        labelColor: Colors.orange,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: (index) {
                          controller.applyFilter(
                            category: controller.categories[index],
                          );
                        },
                        tabs: controller.categories
                            .map((jenis) => Tab(text: jenis.toUpperCase()))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SectionHeader(title: "Daftar Menu"),
                    const SizedBox(height: 10),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.filteredList.isEmpty) {
                        return const Center(
                          child: Text("Produk tidak ditemukan"),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.65,
                            ),
                        itemCount: controller.filteredList.length,
                        itemBuilder: (context, index) {
                          final product = controller.filteredList[index];
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
        ),
      );
    });
  }
}