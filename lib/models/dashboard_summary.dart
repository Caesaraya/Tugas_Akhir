class DashboardSummary {
  final double omzetHariIni;
  final double omzetKemarin;
  final double persentasePerubahan;
  final double profitBulanIni;
  final int totalTransaksiBulanIni;
  final int jumlahBahanKritis;

  DashboardSummary({
    required this.omzetHariIni,
    required this.omzetKemarin,
    required this.persentasePerubahan,
    required this.profitBulanIni,
    required this.totalTransaksiBulanIni,
    required this.jumlahBahanKritis,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      omzetHariIni: double.tryParse(json['omzet_hari_ini'].toString()) ?? 0.0,
      omzetKemarin: double.tryParse(json['omzet_kemarin'].toString()) ?? 0.0,
      persentasePerubahan: double.tryParse(json['persentase_perubahan'].toString()) ?? 0.0,
      profitBulanIni: double.tryParse(json['profit_bulan_ini'].toString()) ?? 0.0,
      totalTransaksiBulanIni: int.tryParse(json['total_transaksi_bulan_ini'].toString()) ?? 0,
      jumlahBahanKritis: int.tryParse(json['jumlah_bahan_kritis'].toString()) ?? 0,
    );
  }

  DashboardSummary copyWith({
    double? omzetHariIni,
    double? omzetKemarin,
    double? persentasePerubahan,
    double? profitBulanIni,
    int? totalTransaksiBulanIni,
    int? jumlahBahanKritis,
  }) {
    return DashboardSummary(
      omzetHariIni: omzetHariIni ?? this.omzetHariIni,
      omzetKemarin: omzetKemarin ?? this.omzetKemarin,
      persentasePerubahan: persentasePerubahan ?? this.persentasePerubahan,
      profitBulanIni: profitBulanIni ?? this.profitBulanIni,
      totalTransaksiBulanIni: totalTransaksiBulanIni ?? this.totalTransaksiBulanIni,
      jumlahBahanKritis: jumlahBahanKritis ?? this.jumlahBahanKritis,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'omzet_hari_ini': omzetHariIni,
      'omzet_kemarin': omzetKemarin,
      'persentase_perubahan': persentasePerubahan,
      'profit_bulan_ini': profitBulanIni,
      'total_transaksi_bulan_ini': totalTransaksiBulanIni,
      'jumlah_bahan_kritis': jumlahBahanKritis,
    };
  }

  // Helper untuk format currency
  String formatCurrency(double value) {
    return 'Rp${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  // Helper untuk format persentase
  String formatPersentase() {
    if (persentasePerubahan >= 0) {
      return '+${persentasePerubahan.toStringAsFixed(1)}%';
    } else {
      return '${persentasePerubahan.toStringAsFixed(1)}%';
    }
  }

  // Helper untuk cek apakah naik
  bool isNaik() {
    return persentasePerubahan >= 0;
  }
}
