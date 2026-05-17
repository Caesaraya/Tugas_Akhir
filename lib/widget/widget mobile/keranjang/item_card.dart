import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/payment_controller.dart';
import 'package:collection/collection.dart';

class KeranjangItemCard extends StatelessWidget {
  final PaymentController ctrl;
  final dynamic item;
 
  const KeranjangItemCard({super.key, required this.ctrl, required this.item});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 237, 118, 0),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.qty} X  |  ${ctrl.itemTotalFormatted(item)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: item.qty > 1
                    ? () => ctrl.decreaseQty(item.productId)
                    : null,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: item.qty > 1 ? Colors.orange : Colors.grey.shade400,
                ),
              ),
              Text(
                '${item.qty}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => ctrl.increaseQty(item.productId),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.orange,
                ),
              ),
              IconButton(
                onPressed: () => ctrl.removeItem(item),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.brown,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}