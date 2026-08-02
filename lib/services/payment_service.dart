import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentService {
  Future<void> startPayment(String snapToken) async {
    final url =
        "https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken";

    Get.to(() => Scaffold(
          appBar: AppBar(title: const Text("Midtrans Payment")),
          body: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(url)),
          ),
        ));
  }
}