import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/sort_botton.dart';

class MySearchBar extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;

  const MySearchBar({
    super.key,
    this.hintText = "Search",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 0, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Colors.brown.shade200, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GetX<DashboardController>(
          builder: (ctrl) => GestureDetector(
            onTap: () => SortBottomSheet.show(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ctrl.sortOption.value != 'none'
                    ? const Color(0xFFE89336)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(
                Icons.tune,
                color: ctrl.sortOption.value != 'none'
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}