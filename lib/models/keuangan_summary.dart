class KeuanganSummary {
  final double pemasukan;
  final double pengeluaran;
  final double profit;

  const KeuanganSummary({
    required this.pemasukan,
    required this.pengeluaran,
    required this.profit,
  });

  factory KeuanganSummary.kosong() {
    return const KeuanganSummary(pemasukan: 0, pengeluaran: 0, profit: 0);
  }
}
