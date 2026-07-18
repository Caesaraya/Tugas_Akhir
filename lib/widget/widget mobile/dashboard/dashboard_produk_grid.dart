import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/product_card.dart';

class DashboardProductGrid extends StatefulWidget {
  final DashboardController dashboardController;

  const DashboardProductGrid({super.key, required this.dashboardController});

  @override
  State<DashboardProductGrid> createState() => DashboardProductGridState();
}

class DashboardProductGridState extends State<DashboardProductGrid> {
  ScrollPosition? scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != scrollPosition) {
      scrollPosition?.removeListener(onScroll);
      scrollPosition = newPosition;
      scrollPosition?.addListener(onScroll);
    }
  }

  void onScroll() {
    final position = scrollPosition;
    if (position == null) return;
    final remaining = position.maxScrollExtent - position.pixels;
    if (remaining <= 200 &&
        widget.dashboardController.hasMore &&
        !widget.dashboardController.isLoadingMore.value) {
      widget.dashboardController.loadMore();
    }
  }

  @override
  void dispose() {
    scrollPosition?.removeListener(onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.dashboardController;
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctrl.displayedList.isEmpty) {
        return const Center(child: Text('Produk tidak ditemukan'));
      }
      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.60,
            ),
            itemCount: ctrl.displayedList.length,
            itemBuilder: (context, index) {
              final product = ctrl.displayedList[index];
              return ProductCard(product: product, tag: product.jenis);
            },
          ),
          if (ctrl.isLoadingMore.value)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}