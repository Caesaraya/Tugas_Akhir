import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/controller/detail_transaction_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/detail_transaction/product_tile.dart';
import 'package:tugas_akhir/widget/widget desktop/detail_transaction/row.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/komponen_nota.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionDetailController detailController =
        Get.find<TransactionDetailController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE89336),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${detailController.transactionId}'),
            Text('Tanggal: ${detailController.tanggalFormatted}'),
            Text('Metode: ${detailController.methodLabel}'),
            const SizedBox(height: 20),
            const Text(
              'Daftar Produk:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: detailController.items.isEmpty
                  ? const Text('Tidak ada item transaksi.')
                  : ListView.builder(
                      itemCount: detailController.items.length,
                      itemBuilder: (context, index) {
                        final item = detailController.items[index];
                        return ProductTile(
                          transactionDetailController: detailController,
                          item: item,
                        );
                      },
                    ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            SummaryRow(
              label: 'Total:',
              value: detailController.totalFormatted,
              isBold: true,
            ),
            SummaryRow(label: 'Bayar:', value: detailController.bayarFormatted),
            SummaryRow(
              label: 'Kembalian:',
              value: detailController.kembalianFormatted,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ReceiptActionButton(
                label: 'Print Nota',
                onPressed: () =>
                    cartController.printFromDetail(detailController),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
