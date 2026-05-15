import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/detail_transaction_controller.dart';

class ProductTile extends StatelessWidget {
  final TransactionDetailController transactionDetailController ;
  final Map<String, dynamic> item;
 
   ProductTile({required this.transactionDetailController, required this.item});
 
  @override
  Widget build(BuildContext context) {
    final bool diskon = transactionDetailController.hasDiscount(item);
 
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        transactionDetailController.namaProduk(item),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Text('Qty: ${transactionDetailController.qty(item)} | '),
          if (diskon) ...[
            Text(
              transactionDetailController.currencyFormatter.format(transactionDetailController.hargaAsli(item)),
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.red,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              transactionDetailController.currencyFormatter.format(transactionDetailController.hargaSetelahDiskon(item)),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 12,
              ),
            ),
          ] else ...[
            Text(
              transactionDetailController.currencyFormatter.format(transactionDetailController.hargaAsli(item)),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}