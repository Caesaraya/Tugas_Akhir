import 'package:get/get.dart';

class PaymentController extends GetxController {
  var selectedMethod = ''.obs;
  var input = ''.obs;

  void onButtonPressed(String text) {
    if (text == "X") {
      if (input.value.isNotEmpty) {
        input.value = input.value.substring(0, input.value.length - 1);
      }
    } else {
      input.value += text;
    }
  }

  void onPaymentMethodChanged(String? val) {
    selectedMethod.value = val ?? '';
  }

  void onChipPressed(String text, {double? totalPrice}) {
    if (text == "Uang Pas" && totalPrice != null) {
      input.value = totalPrice.toStringAsFixed(0);
    } else {
      input.value = text.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  String get methodLabel {
    switch (selectedMethod.value) {
      case 'cash':
        return 'Tunai / Cash';
      case 'qris':
        return 'QRIS';
      default:
        return selectedMethod.value.isEmpty ? '-' : selectedMethod.value;
    }
  }
}
