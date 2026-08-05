import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/models/product.dart';

class KelolaProdukController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var searchQuery = "".obs;
  var currentPage = 1.obs;
  static const int pageSize = 15;

  List<Product> get paginatedProducts {
    if (filteredProducts.isEmpty) return [];

    final start = (currentPage.value - 1) * pageSize;

    if (start >= filteredProducts.length) {
      currentPage.value = totalPages;
      return [];
    }

    final end = (start + pageSize).clamp(0, filteredProducts.length);

    return filteredProducts.sublist(start, end);
  }

  int get totalPages {
    if (filteredProducts.isEmpty) return 1;
    return (filteredProducts.length / pageSize).ceil();
  }

  void nextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value++;
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
    }
  }
  // --------------------------------

  final ImagePicker picker = ImagePicker();
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
  final alasanStockController = TextEditingController(); // BARU

  int _oldStock = 0; // BARU - simpan stock sebelum diubah, buat dibandingkan

  final listJenis = [
    'BREAD',
    'CAKE',
    'TART',
    'BASAHAN',
    'PASTRY',
    'PASTA',
    'GROSIR RESILEDO',
    'HANTARAN',
    'KONSINYASI',
    'KUE KERING',
    'MINUMAN',
    'PACKAGING',
    'PUTUS',
  ].obs;

  final listSatuan = [
    'pcs',
    'piece',
    'slice',
    'loyang',
    'box',
    'cup',
    'botol',
    'toples',
    'porsi',
    'slop',
    'pouch',
    'kg',
    'gram',
    'lusin',
  ].obs;

  final selectedJenis = ''.obs;
  final selectedSatuan = ''.obs;

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
      if (searchQuery.value.isEmpty) {
        filteredProducts.assignAll(products);
      } else {
        filteredProducts.assignAll(
          products
              .where(
                (p) => p.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
              )
              .toList(),
        );
      }
      if (currentPage.value > totalPages) {
        currentPage.value = totalPages;
      }
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
    alasanStockController.dispose(); // BARU
    super.onClose();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
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
    alasanStockController.clear(); // BARU
    _oldStock = product.stock; // BARU
    selectedJenis.value = listJenis.contains(product.jenis)
        ? product.jenis
        : listJenis.first;
    selectedSatuan.value = listSatuan.contains(product.satuan)
        ? product.satuan
        : listSatuan.first;

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
              buildTextField(stockController, "Stock", isNumber: true),
              const SizedBox(height: 12),
              // BARU - field alasan perubahan stock
              TextField(
                controller: alasanStockController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Alasan Perubahan Stock",
                  hintText: "Wajib diisi kalau stock diubah",
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
    bool isDiscount = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isDiscount || isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
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
        if (isDiscount && value.isNotEmpty) {
          int val = int.tryParse(value) ?? 0;
          if (val > 99) {
            String clamped = value.substring(0, value.length - 1);
            controller.text = clamped;
            controller.selection = TextSelection.collapsed(
              offset: clamped.length,
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

  String cleanPriceText =
      priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
  int numericPrice =
      int.parse(cleanPriceText.isEmpty ? "0" : cleanPriceText);

  int newStock = int.tryParse(stockController.text) ?? 0;

  String cleanDiscountText =
      discountPercentController.text.isEmpty
          ? "0"
          : discountPercentController.text;

  int discountPercent =
      (int.tryParse(cleanDiscountText) ?? 0).clamp(0, 100);

  // ============================
  // BARU - cek apakah ada perubahan
  // ============================
  final bool hasChanged =
      nameController.text.trim() != oldProduct.name ||
      numericPrice != oldProduct.price ||
      discountPercent != oldProduct.discount ||
      newStock != oldProduct.stock ||
      jenisController.text != oldProduct.jenis ||
      satuanController.text != oldProduct.satuan ||
      selectedImage.value != null;

  if (!hasChanged) {
    Get.back();


    return;
  }

  // ============================
  // wajib isi alasan jika stock berubah
  // ============================
  if (newStock != oldProduct.stock &&
      alasanStockController.text.trim().isEmpty) {
    Get.snackbar(
      "Validasi",
      "Alasan perubahan stock wajib diisi",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  try {
    Get.back();
    isLoading(true);

    final success = await ApiService.updateProductWithImage(
      id: oldProduct.id,
      name: nameController.text.trim(),
      price: numericPrice,
      discount: discountPercent,
      stock: newStock,
      jenis: jenisController.text,
      satuan: satuanController.text,
      resepId: oldProduct.resepId,
      imageFile: selectedImage.value,
      alasanStock: newStock != oldProduct.stock
          ? alasanStockController.text.trim()
          : null,
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
    if (searchQuery.value.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where(
              (p) => p.name.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
            )
            .toList(),
      );
    }
    currentPage.value = 1;
  }

  void refreshData() => fetchData();
}