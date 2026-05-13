import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/success_widgets.dart';
import 'package:intl/intl.dart';

class SuksesMobilePage extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  @override
  Widget build(BuildContext context) {
    final data = controller.getSuksesData(Get.arguments);
    final bool isFromHistory = data['isHistory'] == 'true';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Nota Transaksi",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => controller.handleSelesaiAction(isFromHistory),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuccessHeader(),
            const SizedBox(height: 40),

            // HAPUS tanda "!" agar daftar item muncul di keduanya,
            // atau biarkan tampil tanpa syarat jika ingin selalu muncul.
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                // Jika dari riwayat, ambil dari data['items'], jika transaksi baru ambil dari controller
                itemCount: isFromHistory
                    ? (data['items'] != null
                          ? (data['items'] as List).length
                          : 0)
                    : controller.cartItems.length,
                itemBuilder: (context, index) {
                  // Ambil data item
                  final dynamic item = isFromHistory
                      ? (data['items'] as List)[index]
                      : controller.cartItems[index];

                  String itemName;
                  int itemQty;
                  double displayPrice;

                  if (isFromHistory) {
                    final Map<String, dynamic> itemMap =
                        item as Map<String, dynamic>;

                    // Sesuaikan dengan model TransactionDetailModel Anda
                    itemName = itemMap['name'] ?? "Produk";
                    itemQty =
                        int.tryParse(
                          itemMap['quantity']?.toString() ??
                              itemMap['qty']?.toString() ??
                              "0",
                        ) ??
                        0;
                    displayPrice =
                        double.tryParse(
                          itemMap['subtotal']?.toString() ?? "0",
                        ) ??
                        0.0;
                  } else {
                    // Logika untuk transaksi baru (dari keranjang)
                    itemName = item.name;
                    itemQty = item.qty;
                    displayPrice =
                        (item.price - (item.price * (item.discount / 100))) *
                        item.qty;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            itemName,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          "Qty: $itemQty",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          " ${currencyFormatter.format(displayPrice)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            InfoRow(label: "Total Tagihan", value: data['total']!),
            InfoRow(label: data['label']!, value: data['bayar']!),
            const Divider(thickness: 1.5, height: 30),
            InfoRow(
              label: "Kembalian",
              value: data['kembalian']!,
              isBold: true,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
