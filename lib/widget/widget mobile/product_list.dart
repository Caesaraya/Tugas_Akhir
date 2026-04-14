import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_Mobile_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/product_card.dart';

class ProductList extends StatelessWidget {
  final String Function(int) tagBuilder;
  final int? limit; 
  final DashboardController controller = Get.find();

  final ScrollController localScrollController = ScrollController();
  final RxInt localCurrentIndex = 0.obs;

  ProductList({
    super.key, 
    required this.tagBuilder, 
    this.limit,
  }) {
    localScrollController.addListener(() {
      int index = (localScrollController.offset / 192).round();
      if (index != localCurrentIndex.value) {
        localCurrentIndex.value = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var displayList = limit != null 
          ? controller.filteredList.take(limit!).toList() 
          : controller.filteredList;

      if (displayList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          SizedBox(
            height: 270,
            child: ListView.builder(
              controller: localScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: displayList.length,
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: displayList[index],
                  tag: tagBuilder(index),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              displayList.length, 
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: localCurrentIndex.value == index ? 20 : 8,
                decoration: BoxDecoration(
                  color: localCurrentIndex.value == index
                      ? const Color(0xFFE89336)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}