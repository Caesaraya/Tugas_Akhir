import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class MidtransProvider {
  static const String serverKey =
      "Mid-server-ZyYvVpBoK1CSIAyfbkcOCTTS"; 

  static const String url =
      "https://app.sandbox.midtrans.com/snap/v1/transactions";

  Future<Map<String, String>?> fetchSnapToken({
  required String title,
  required int amount,
}) async {
  final orderId = "ORDER-${DateTime.now().millisecondsSinceEpoch}";

  final body = {
    "transaction_details": {
      "order_id": orderId,
      "gross_amount": amount,
    },
    "item_details": [
      {
        "id": "item-001",
        "price": amount,
        "quantity": 1,
        "name": title,
      }
    ],
    "customer_details": {
      "first_name": "User",
      "email": "user@test.com",
    }
  };

  final response = await http.post(
    Uri.parse("https://app.sandbox.midtrans.com/snap/v1/transactions"),
    headers: {
      "Authorization": "Basic ${base64Encode(utf8.encode("$serverKey:"))}",
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