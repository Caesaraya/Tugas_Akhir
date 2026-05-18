import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/succes.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/app_bar_desktop.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/komponen_nota.dart';

class KasirSelesaiDesktop extends StatelessWidget {
  const KasirSelesaiDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Scaffold(
      drawer: const DesktopNavigationDrawer(currentRoute: AppRoutes.kasirprint),
      body: Column(
        children: [
          const AppBarDesktop(title: 'Transaksi Selesai', showSearch: false),
          Expanded(
            child: Center(
              child: Container(
                width: 520,
                height: 700,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 6),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SuccessBadge(),
                    const SizedBox(height: 24),
                    const Text(
                      'Detail Pembelian',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Area daftar produk belanjaan (Scrollable)
                    Expanded(
                      child: Obx(() {
                        if (cart.cartItems.isEmpty) {
                          return const Center(
                            child: Text('Tidak ada produk yang dibeli.'),
                          );
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: cart.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cart.cartItems[index];
                            final double hargaAsli = item.price.toDouble();
                            final double persen = (item.discount ?? 0)
                                .toDouble();
                            final double hargaDiskon =
                                (hargaAsli - (hargaAsli * persen / 100))
                                    .roundToDouble();

                            return ReceiptProductRow(
                              name: item.name,
                              qty: item.qty,
                              unitPrice: hargaDiskon,
                              totalPrice: hargaDiskon * item.qty,
                            );
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Rincian Pembayaran
                    Obx(
                      () => ReceiptRowItem(
                        title: 'Total Tagihan',
                        value: cart.currencyFormatter.format(cart.totalPrice),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => ReceiptRowItem(
                        title: 'Jumlah Dibayar',
                        value: cart.paymentDisplayValueFormatted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => ReceiptRowItem(
                        title: 'Kembalian',
                        value: cart.kembalianDisplayFormatted,
                      ),
                    ),
                    Obx(
                      () => ReceiptRowItem(
                        title: 'Metode Pembayaran',
                        value: cart.paymentMethodLabel,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Baris Tombol Aksi (Sudah aman karena ReceiptActionButton menggunakan Expanded)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => cart.generateAndPrintPdf(),
                            icon: const Icon(
                              Icons.print_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Print Nota',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE89336),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ReceiptActionButton(
                          label: 'Selesai',
                          backgroundColor: Colors.orange,
                          onPressed: () =>
                              cart.handleSelesaiActionDashboard(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
