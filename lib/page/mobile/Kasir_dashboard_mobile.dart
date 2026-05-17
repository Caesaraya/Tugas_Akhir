import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/page/mobile/keranjang_mobile.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/search_bar.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/section_header.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/dashboard_produk_grid.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/greeting.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/kategori.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';

class KasirDashboardMobile extends StatelessWidget {
  const KasirDashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DashboardController>();
    final cartCtrl = Get.find<CartController>();
    return Obx(
      () => DefaultTabController(
        length: ctrl.categories.length,
        child: Scaffold(
          drawer: const KasirMobileDrawer(),
          backgroundColor: const Color(0xFFFDFBFA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),
          floatingActionButton: Obx(() {
            final jumlahItem = cartCtrl.cartItems.length;
            return FloatingActionButton.extended(
              onPressed: () => Get.to(
                () => const KeranjangMobilePage(),
              ), 
              backgroundColor: const Color(0xFFE8A045),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  if (jumlahItem > 0)
                    Positioned(
                      top: -6,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$jumlahItem',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: const Text(
                'Keranjang',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: ctrl.fetchProducts,
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
                    const DashboardGreeting(),
                    const SizedBox(height: 20),
                    MySearchBar(
                      onChanged: (value) => ctrl.applyFilter(query: value),
                    ),
                    const SizedBox(height: 10),
                    DashboardCategoryTabs(ctrl: ctrl),
                    const SizedBox(height: 10),
                    SectionHeader(title: 'Daftar Menu'),
                    const SizedBox(height: 10),
                    DashboardProductGrid(ctrl: ctrl),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
