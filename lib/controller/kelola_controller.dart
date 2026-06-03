import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class KelolaProdukController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;

  final ImagePicker _picker = ImagePicker();
  var selectedImage = Rx<File?>(null);

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final discountPercentController = TextEditingController();
  final stockController = TextEditingController();
  final jenisController = TextEditingController();
  final satuanController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
    debounce(
      searchQuery,
      (_) => runFilter(),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);
      final data = await ApiService.getProducts();
      products.assignAll(data);
      filteredProducts.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat produk: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    discountPercentController.dispose();
    stockController.dispose();
    jenisController.dispose();
    satuanController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void showEditForm(BuildContext context, Product product) {
    selectedImage.value = null;

    nameController.text = product.name;
    priceController.text = currencyFormatter.format(product.price);
    discountPercentController.text = product.discount.toString();
    stockController.text = product.stock.toString();
    jenisController.text = product.jenis;
    satuanController.text = product.satuan;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Edit Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImage.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : (product.image.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) =>
                                        const Icon(Icons.image, size: 50),
                                  ),
                                )
                              : const Icon(Icons.add_a_photo, size: 50)),
                  ),
                ),
              ),

              buildTextField(nameController, "Nama Produk"),
              const SizedBox(height: 12),
              buildTextField(
                priceController,
                "Harga",
                isNumber: true,
                isPrice: true,
              ),
              const SizedBox(height: 12),
              buildTextField(
                discountPercentController,
                "Diskon (%)",
                isNumber: true,
              ),
              const SizedBox(height: 12),
              buildTextField(stockController, "Stok", isNumber: true),
              const SizedBox(height: 12),
              buildTextField(jenisController, "Jenis"),
              const SizedBox(height: 12),
              buildTextField(satuanController, "Satuan"),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => updateProduct(product),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE89336),
            ),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool isPrice = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: (value) {
        if (isPrice && value.isNotEmpty) {
          String cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleanValue.isEmpty) cleanValue = "0";
          String formatted = currencyFormatter.format(int.parse(cleanValue));
          if (controller.text != formatted) {
            controller.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        }
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> updateProduct(Product oldProduct) async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar(
        "Validasi",
        "Nama dan Harga tidak boleh kosong",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      String cleanPriceText = priceController.text.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      int numericPrice = int.parse(
        cleanPriceText.isEmpty ? "0" : cleanPriceText,
      );

      String cleanDiscountText = discountPercentController.text.isEmpty
          ? "0"
          : discountPercentController.text;
      int discountPercent = int.tryParse(cleanDiscountText) ?? 0;

      Get.back();
      isLoading(true);

      final success = await ApiService.updateProductWithImage(
        id: oldProduct.id,
        name: nameController.text,
        price: numericPrice,
        discount: discountPercent,
        stock: int.tryParse(stockController.text) ?? 0,
        jenis: jenisController.text,
        satuan: satuanController.text,
        resepId: oldProduct.resepId,
        imageFile: selectedImage.value,
      );

      if (success) {
        Get.snackbar(
          "Sukses",
          "Produk berhasil diperbarui",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().fetchProducts();
        }

        fetchData();
      } else {
        Get.snackbar(
          "Gagal",
          "Gagal memperbarui produk",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memperbarui: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void runFilter() {
    if (searchQuery.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      var result = products
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
      filteredProducts.assignAll(result);
    }
  }

  void refreshData() => fetchData();
}
