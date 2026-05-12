import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseTableController<T> extends GetxController {
  final RxList<T> originalList = <T>[].obs;
  final RxList<T> filteredList = <T>[].obs;
  final RxList<T> paginatedList = <T>[].obs;

  final RxBool isLoading = false.obs;

  final TextEditingController searchC = TextEditingController();

  int itemsPerPage = 10;

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();

    searchC.addListener(() {
      search(searchC.text);
    });

    fetchData();
  }

  Future<void> fetchData();

  void setData(List<T> data) {
    originalList.assignAll(data);
    filteredList.assignAll(data);

    setupPagination();
  }

  void setupPagination() {
    totalPages.value = (filteredList.length / itemsPerPage).ceil();

    if (totalPages.value == 0) {
      totalPages.value = 1;
    }

    paginate();
  }

  void paginate() {
    final start = (currentPage.value - 1) * itemsPerPage;
    final end = start + itemsPerPage;

    paginatedList.assignAll(
      filteredList.sublist(
        start,
        end > filteredList.length ? filteredList.length : end,
      ),
    );
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      paginate();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      paginate();
    }
  }

  void refreshData() async {
    await fetchData();
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(originalList);
    } else {
      filteredList.assignAll(
        originalList.where((item) {
          return item.toString().toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }

    currentPage.value = 1;

    setupPagination();
  }
}
