import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/controller/cart_controller.dart';

class MidtransProvider {
  static const String serverKey = "Mid-server-ZyYvVpBoK1CSIAyfbkcOCTTS";

  Future<Map<String, String>?> fetchSnapToken({
    required String title,
    required int amount,
  }) async {
    final orderId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";
    final cart = Get.find<CartController>();

    // ← Buat item_details dari cartItems
    final itemDetails = cart.cartItems.map((item) {
      final double hargaAsli = item.price.toDouble();
      final double persen = (item.discount ?? 0).toDouble();
      final int hargaDiskon =
          (hargaAsli - (hargaAsli * persen / 100)).round();
      
      return {
        "id": "item-${item.productId}",
        "price": hargaDiskon,
        "quantity": item.qty,
        // ← Potong nama max 50 karakter
        "name": item.name.length > 50
            ? item.name.substring(0, 50)
            : item.name,
      };
    }).toList();

    // ← Hitung total dari item_details agar cocok dengan gross_amount
    final int totalFromItems = itemDetails.fold<int>(
      0,
      (sum, item) =>
          sum + ((item['price'] as int) * (item['quantity'] as int)),
    );

    final body = {
      "transaction_details": {
        "order_id": orderId,
        "gross_amount": totalFromItems, // ← pakai total dari items
      },
      "item_details": itemDetails,
      "customer_details": {
        "first_name": "Kasir",
        "email": "kasir@rumah-lezzaaa.com",
      }
    };

    final response = await http.post(
      Uri.parse(
          "https://app.sandbox.midtrans.com/snap/v1/transactions"),
      headers: {
        "Authorization":
            "Basic ${base64Encode(utf8.encode("$serverKey:"))}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'order_id': orderId,
      };
    }

    print("MIDTRANS ERROR: ${response.body}");
    return null;
  }
}