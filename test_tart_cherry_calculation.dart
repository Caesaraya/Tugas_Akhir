// Test file untuk validasi perhitungan Tart Cherry
// Contoh kasus dari user:
// - Tart Cherry: Rp 25.000
// - Diskon: 30% → Rp 17.500 (benar)
// - Quantity: 6
// - Subtotal seharusnya: Rp 17.500 × 6 = Rp 105.000
// - Tapi yang muncul: Rp 149.820

void main() {
  print('=== TEST PERHITUNGAN TART CHERRY ===');
  print('');
  
  // Data dari user
  final item = {
    'product_name': 'Tart Cherry',
    'price': 25000.0,        // Harga asli
    'quantity': 6,
    'discount': 30.0,        // Diskon 30%
    'subtotal': 149820.0,    // Subtotal yang salah dari backend
  };
  
  final price = item['price'] as double;
  final quantity = item['quantity'] as int;
  final discountPercent = item['discount'] as double;
  final wrongSubtotal = item['subtotal'] as double;
  
  // Perhitungan yang BENAR
  final priceAfterDiscount = price * (1 - discountPercent / 100);
  final correctSubtotal = priceAfterDiscount * quantity;
  final totalDiscount = (price * discountPercent / 100) * quantity;
  
  print('DATA TART CHERRY:');
  print('- Harga asli: Rp ${price.toStringAsFixed(0)}');
  print('- Diskon: $discountPercent%');
  print('- Quantity: $quantity');
  print('- Harga setelah diskon: Rp ${priceAfterDiscount.toStringAsFixed(0)}');
  print('');
  
  print('PERHITUNGAN USER (YANG SALAH):');
  print('- Subtotal dari backend: Rp ${wrongSubtotal.toStringAsFixed(0)}');
  print('- Total diskon: -Rp 45.000');
  print('- Total pembayaran: Rp ${wrongSubtotal.toStringAsFixed(0)}');
  print('');
  
  print('PERHITUNGAN YANG BENAR:');
  print('- Subtotal: Rp ${correctSubtotal.toStringAsFixed(0)}');
  print('- Total diskon: Rp ${totalDiscount.toStringAsFixed(0)}');
  print('- Total pembayaran: Rp ${correctSubtotal.toStringAsFixed(0)}');
  print('');
  
  print('ANALISIS ERROR:');
  print('- Backend mengirim subtotal: Rp ${wrongSubtotal.toStringAsFixed(0)}');
  print('- Seharusnya subtotal: Rp ${correctSubtotal.toStringAsFixed(0)}');
  print('- Selisih: Rp ${(wrongSubtotal - correctSubtotal).toStringAsFixed(0)}');
  print('- Kemungkinan: Backend masih hitung (price × quantity) - diskon kecil');
  print('');
  
  print('SOLUSI:');
  print('1. ✅ Frontend hitung ulang subtotal dengan harga setelah diskon');
  print('2. ✅ Total diskon: Rp 45.000 (benar)');
  print('3. ✅ Total pembayaran: Rp 105.000 (benar)');
  print('');
  
  // Perhitungan yang BENAR SESUAI SARAN USER
  final originalSubtotal = price * quantity; // Harga asli × quantity
  final finalTotal = originalSubtotal - totalDiscount; // Subtotal - Diskon
  
  print('HASIL SETELAH PERBAIKAN (SESUAI SARAN USER):');
  print('✅ Subtotal: Rp ${originalSubtotal.toStringAsFixed(0)} (harga asli × quantity)');
  print('✅ Total diskon: -Rp ${totalDiscount.toStringAsFixed(0)}');
  print('✅ Total pembayaran: Rp ${finalTotal.toStringAsFixed(0)} (subtotal - diskon)');
  print('');
  
  print('VALIDASI AKHIR:');
  print('- Subtotal: Rp ${originalSubtotal.toStringAsFixed(0)} ✅');
  print('- Total diskon: -Rp ${totalDiscount.toStringAsFixed(0)} ✅');
  print('- Total pembayaran: Rp ${finalTotal.toStringAsFixed(0)} ✅');
  print('- Rp ${originalSubtotal.toStringAsFixed(0)} - Rp ${totalDiscount.toStringAsFixed(0)} = Rp ${finalTotal.toStringAsFixed(0)} ✅');
}
