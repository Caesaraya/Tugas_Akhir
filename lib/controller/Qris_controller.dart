import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class QrisPaymentController extends GetxController {
  final CartController cartCtrl = Get.find<CartController>();
  final ImagePicker _picker = ImagePicker();

  final Rx<File?> buktiFoto = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool sudahKonfirmasi = false.obs;
  String get totalFormatted =>
      cartCtrl.currencyFormatter.format(cartCtrl.totalPrice);
  bool get canBayar =>
      buktiFoto.value != null && sudahKonfirmasi.value && !isLoading.value;

  Future<void> pilihFoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      buktiFoto.value = File(picked.path);
      sudahKonfirmasi.value = false;
    }
  }

  void toggleKonfirmasi(bool? value) {
    sudahKonfirmasi.value = value ?? false;
  }

  Future<void> prosesBayar() async {
    if (!canBayar) return;

    isLoading.value = true;
    try {
      cartCtrl.selectedPayment.value = 'qris';
      cartCtrl.inputUang.value = cartCtrl.totalPrice;
      Get.offAllNamed(AppRoutes.sukses);
    } finally {
      isLoading.value = false;
    }
  }
}