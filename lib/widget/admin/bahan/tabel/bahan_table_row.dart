// lib/views/widgets/bahan_baku/bahan_baku_table_row.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/widget/admin/bahan/bahan_baku_satuan_badge.dart';
import 'package:tugas_akhir/widget/admin/bahan/bahan_baku_stok_badge.dart';
import 'package:tugas_akhir/widget/admin/table_action_button.dart';

class BahanBakuTableRow extends StatelessWidget {
  BahanBakuTableRow({
    super.key,
    required this.index,
    required this.item,
    required this.isEven,
    required this.colWidths,
    required this.onEdit,
    required this.onDelete,
  });

  final int index;
  final BahanBaku item;
  final bool isEven;
  final List<double?> colWidths;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  final _currency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isEven ? Colors.white : const Color(0xFFFAFAFC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // No
          SizedBox(
            width: colWidths[0],
            child: Text('$index', style: _cell),
          ),
          // Nama Bahan
          SizedBox(
            width: colWidths[1],
            child: Text(
              item.namaBahan,
              style: _cell.copyWith(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Merk
          SizedBox(
            width: colWidths[2],
            child: Text(
              item.merk,
              style: _cell,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Satuan
          SizedBox(
            width: colWidths[3],
            child: BahanBakuSatuanBadge(satuan: item.satuan),
          ),
          // Stok
          SizedBox(
            width: colWidths[4],
            child: BahanBakuStokBadge(stok: item.stok),
          ),
          // Harga Satuan
          SizedBox(
            width: colWidths[5],
            child: Text(_currency.format(item.hargaSatuan), style: _cell),
          ),
          // Total Harga
          SizedBox(
            width: colWidths[6],
            child: Text(
              item.totalHarga != null ? _currency.format(item.totalHarga) : '-',
              style: _cell.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2196F3),
              ),
            ),
          ),
          // Aksi — reuse ProductTableActionButton
          Expanded(
            child: Row(
              children: [
                ProductTableActionButton(
                  label: 'Edit',
                  color: const Color(0xFF2196F3),
                  onPressed: onEdit,
                ),
                const SizedBox(width: 6),
                ProductTableActionButton(
                  label: 'Hapus',
                  color: const Color(0xFFEF5350),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _cell = TextStyle(fontSize: 13, color: Color(0xFF333333));
}
