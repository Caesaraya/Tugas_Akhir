import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/succes.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/komponen_nota.dart';
import 'package:intl/intl.dart';

class SuksesMobilePage extends StatelessWidget {
  final CartController controller = Get.find<CartController>();
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  SuksesMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SuccessBadge(),
              const SizedBox(height: 24),
              const Text(
                'Detail Pembelian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (cart.cartItems.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada produk yang dibeli.'),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: cart.cartItems.map((item) {
                        final double hargaAsli = item.price.toDouble();
                        final double persen = (item.discount ?? 0).toDouble();
                        final double hargaDiskon =
                            (hargaAsli - (hargaAsli * persen / 100))
                                .roundToDouble();
                        return ReceiptProductRow(
                          name: item.name,
                          qty: item.qty,
                          unitPrice: hargaDiskon,
                          totalPrice: hargaDiskon * item.qty,
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),

              const Divider(),
              const SizedBox(height: 8),
              Obx(() => ReceiptRowItem(
                    title: 'Total Tagihan',
                    value: cart.currencyFormatter.format(cart.totalPrice),
                  )),
              const SizedBox(height: 8),
              Obx(() => ReceiptRowItem(
                    title: 'Jumlah Dibayar',
                    value: cart.paymentDisplayValueFormatted,
                  )),
              const SizedBox(height: 8),
              Obx(() => ReceiptRowItem(
                    title: 'Kembalian',
                    value: cart.kembalianDisplayFormatted,
                  )),
              Obx(() => ReceiptRowItem(
                    title: 'Metode Pembayaran',
                    value: cart.paymentMethodLabel,
                  )),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => cart.printNotaSaja(),
                      icon: const Icon(Icons.print_outlined, color: Colors.white),
                      label: const Text('Print Nota',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE89336),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => cart.handleSelesaiActionMobile(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE89336),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Selesai',style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}