import 'package:get/get.dart';

class PaymentController extends GetxController {
  var input = "".obs;
  var selectedMethod = "cash".obs;

  void onButtonPressed(String value) {
    // Cek jika tombol yang ditekan adalah "X"
    if (value == "X") {
      // Logika Backspace: Hapus 1 karakter terakhir
      if (input.value.isNotEmpty) {
        input.value = input.value.substring(0, input.value.length - 1);
      }
    } 
    else if (value == "CLEAR") {
      input.value = "";
    } 
    else {
      // Batasi input maksimal 12 digit
      if (input.value.length < 12) {
        // Mencegah angka 0 di depan jika input masih kosong
        if (input.value.isEmpty && (value == "0" || value == "000")) return;
        
        input.value += value;
      }
    }
    // Paksa UI untuk update agar tidak macet
    input.refresh();
  }

  void onPaymentMethodChanged(String? value) {
    if (value != null) {
      selectedMethod.value = value;
    }
  }
}