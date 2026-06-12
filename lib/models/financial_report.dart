class FinancialReport {
  final int? id;
  final int tahun;
  final int bulan;
  final double pemasukan;
  final double pengeluaran;
  final double profit;
  final int totalTransaksi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FinancialReport({
    this.id,
    required this.tahun,
    required this.bulan,
    required this.pemasukan,
    required this.pengeluaran,
    required this.profit,
    required this.totalTransaksi,
    this.createdAt,
    this.updatedAt,
  });

  factory FinancialReport.fromJson(Map<String, dynamic> json) {
    return FinancialReport(
      id: json['id'] as int?,
      tahun: json['tahun'] as int,
      bulan: json['bulan'] as int,
      pemasukan: (json['pemasukan'] as num).toDouble(),
      pengeluaran: (json['pengeluaran'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      totalTransaksi: json['total_transaksi'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tahun': tahun,
      'bulan': bulan,
      'pemasukan': pemasukan,
      'pengeluaran': pengeluaran,
      'profit': profit,
      'total_transaksi': totalTransaksi,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get bulanNama {
    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return namaBulan[bulan - 1];
  }
}

class FinancialSummary {
  final int totalBulan;
  final double totalPemasukan;
  final double totalPengeluaran;
  final double totalProfit;
  final int totalTransaksi;

  FinancialSummary({
    required this.totalBulan,
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.totalProfit,
    required this.totalTransaksi,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalBulan: json['total_bulan'] as int,
      totalPemasukan: (json['total_pemasukan'] as num).toDouble(),
      totalPengeluaran: (json['total_pengeluaran'] as num).toDouble(),
      totalProfit: (json['total_profit'] as num).toDouble(),
      totalTransaksi: json['total_transaksi'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_bulan': totalBulan,
      'total_pemasukan': totalPemasukan,
      'total_pengeluaran': totalPengeluaran,
      'total_profit': totalProfit,
      'total_transaksi': totalTransaksi,
    };
  }
}
