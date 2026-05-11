// import 'package:get/get.dart';

// class PaymentController extends GetxController {

//   RxString input = "0".obs;
//   RxString selectedMethod = "cash".obs;

//   void onButtonPressed(String value) {

//     if (value == "DELETE") {

//       if (input.value.length > 1) {
//         input.value =
//             input.value.substring(0, input.value.length - 1);
//       } else {
//         input.value = "0";
//       }

//     } else {

//       if (input.value == "0") {
//         input.value = value;
//       } else {
//         input.value += value;
//       }

//     }
//   }

//   void onPaymentMethodChanged(String? value) {
//     if (value != null) {
//       selectedMethod.value = value;
//     }
//   }
// }