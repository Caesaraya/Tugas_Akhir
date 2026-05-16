import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/search_bar.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/section_header.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/dashboard_produk_grid.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/greeting.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/kategori.dart';

class KasirDashboardMobile extends StatelessWidget {
  const KasirDashboardMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DashboardController());

    return Obx(
      () => DefaultTabController(
        length: ctrl.categories.length,
        child: Scaffold(
          backgroundColor: const Color(0xFFFDFBFA),
          appBar: AppBar(
            title: const Text('Dashboard Kasir'),
            backgroundColor: const Color(0xFFE89336),
            elevation: 0,
          ),
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
