import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  static const String serverKey = "Mid-server-ZyYvVpBoK1CSIAyfbkcOCTTS";

  Future<void> startPayment(String snapToken, String orderId, {
    required Function onSuccess,
    required Function onPending,
  }) async {
    final url = Uri.parse(
      "https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken",
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception("Tidak dapat membuka browser");
    }

    // Polling status setiap 5 detik selama max 5 menit
    _pollStatus(orderId, onSuccess: onSuccess, onPending: onPending);
  }

  void _pollStatus(String orderId, {
  required Function onSuccess,
  required Function onPending,
}) {
  int attempt = 0;
  print('=== POLLING DIMULAI untuk orderId: $orderId ===');
  
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    attempt++;
    print('Polling attempt $attempt untuk $orderId');
    
    if (attempt > 60) {
      timer.cancel();
      onPending();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("https://api.sandbox.midtrans.com/v2/$orderId/status"),
        headers: {
          "Authorization": "Basic ${base64Encode(utf8.encode("$serverKey:"))}",
        },
      );

      print('Status response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['transaction_status'];
        print('Transaction status: $status');

        if (status == 'settlement' || status == 'capture') {
          timer.cancel();
          onSuccess();
        } else if (status == 'expire' || status == 'cancel' || status == 'deny') {
          timer.cancel();
          onPending();
        }
      }
    } catch (e) {
      print('Polling error: $e');
    }
  });
}
}