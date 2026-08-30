import 'package:get/get.dart';
import '../../api service/api_service.dart';
import '../../models/transactions.dart';
import '../../models/keuangan_summary.dart' as old_summary;
import '../../models/histori_stok.dart';
import '../../models/financial_report.dart';
import '../../models/expense.dart';
import '../../models/expense_category.dart';
import '../../models/dashboard_summary.dart';
import '../../models/dashboard_activity.dart';

class KeuanganController extends GetxController {
  final isLoading = false.obs;

  // State untuk Dashboard Asli dari API
  final dashboardSummary = Rxn<DashboardSummary>();
  final dashboardActivities = <DashboardActivity>[].obs;
  final isDashboardError = false.obs;
  final dashboardErrorMessage = ''.obs;

  // --- SUMBER DATA UTAMA (SINGLE SOURCE OF TRUTH) ---
  final allTransactions = <TransactionModel>[].obs;
  final allHistoriStok = <HistoriStokModel>[].obs;
  final listExpensesBulanIni = <Expense>[].obs;
  final listCategories = <ExpenseCategory>[].obs;

  // --- STATE FILTER & TABEL REKAP ---
  final availableYears = <int>[].obs;
  final selectedYear = DateTime.now().year.obs;
  final filteredReports = <FinancialReport>[].obs;

  // --- KOMPOSISI PENGELUARAN BULAN BERJALAN ---
  final komposisiBulanIni = <String, double>{}.obs;
  final keuangan = old_summary.KeuanganSummary.kosong().obs;

  @override
  void onInit() {
    super.onInit();
    initialFetch();
  }

  Future<void> initialFetch() async {
    await fetchCategories();
    await loadDataKeuangan();
    await loadDashboardData();
  }

  // Fetch khusus untuk Dashboard (Summary & Activities)
  Future<void> loadDashboardData() async {
    try {
      isLoading(true);
      isDashboardError(false);

      // Fetch secara paralel agar lebih optimal
      final results = await Future.wait([
        ApiService.getDashboardSummary(),
        ApiService.getDashboardActivities(limit: 10),
      ]);

      dashboardSummary.value = results[0] as DashboardSummary;
      dashboardActivities.value = results[1] as List<DashboardActivity>;
    } catch (e) {
      isDashboardError(true);
      dashboardErrorMessage.value = 'Gagal memuat dashboard: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final cats = await ApiService.getAllExpenseCategories();
      listCategories.value = cats;
    } catch (e) {
      print("Gagal memuat kategori dari API: $e");
    }
  }

  Future<int?> tambahKategoriBaru(String name) async {
    try {
      isLoading(true);

      bool success = await ApiService.createExpenseCategory(name: name);

      if (success) {
        // Ambil kategori terbaru dari server
        await fetchCategories();

        // Refresh seluruh data keuangan
        // agar data tabel, komposisi, profit,
        // dan laporan ikut diperbarui
        await loadDataKeuangan();

        final newCat = listCategories.firstWhereOrNull(
          (c) => c.name.toLowerCase() == name.toLowerCase(),
        );

        return newCat?.id;
      }

      return null;
    } catch (e) {
      print("Gagal menambah kategori baru di controller: $e");
      return null;
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadDataKeuangan() async {
    try {
      isLoading(true);

      final sekarang = DateTime.now();

      // =========================
      // TRANSAKSI
      // =========================
      final rawListData = await ApiService.getTransactions();

      allTransactions.value = rawListData
          .map<TransactionModel>((e) => TransactionModel.fromJson(e))
          .toList();

      // =========================
      // PEMBELIAN BAHAN BAKU
      // =========================
      try {
        final rawPembelian = await ApiService.getAllPembelian();

        allHistoriStok.value = rawPembelian.map<HistoriStokModel>((p) {
          return HistoriStokModel(
            tanggal: p.tanggal,
            bahanBakuId: 0,
            namaBahan: p.namaSupplier ?? '',
            stokSebelum: 0.0,
            stokSesudah: 0.0,
            jumlahPenambahan: 0.0,
            hargaSatuan: 0.0,
            totalPengeluaran: p.total,
          );
        }).toList();
      } catch (e) {
        allHistoriStok.value = [];
      }

      // =========================
      // PENGELUARAN BULAN INI
      // =========================
      final firstDayBulanIni = DateTime(sekarang.year, sekarang.month, 1);

      final lastDayBulanIni = DateTime(sekarang.year, sekarang.month + 1, 0);

      final expenses = await ApiService.getAllExpenses(
        startDate: _formatDate(firstDayBulanIni),
        endDate: _formatDate(lastDayBulanIni),
      );

      listExpensesBulanIni.value = expenses;

      // =========================
      // AVAILABLE YEARS
      // =========================
      final years = allTransactions
          .map((t) => DateTime.tryParse(t.tanggal)?.year)
          .where((y) => y != null)
          .cast<int>()
          .toSet()
          .toList();

      if (!years.contains(sekarang.year)) {
        years.add(sekarang.year);
      }

      years.sort((a, b) => b.compareTo(a));
      availableYears.value = years;

      // =========================
      // TOTAL PEMASUKAN BULAN INI
      // =========================
      double totalPemasukanBulanIni = 0;

      for (var trx in allTransactions) {
        final date = DateTime.tryParse(trx.tanggal);

        if (date != null &&
            date.month == sekarang.month &&
            date.year == sekarang.year) {
          totalPemasukanBulanIni += trx.totalHarga;
        }
      }

      // =========================
      // TOTAL BAHAN BAKU BULAN INI
      // =========================
      double totalBahanBakuBulanIni = 0;

      for (var h in allHistoriStok) {
        if (h.tanggal.month == sekarang.month &&
            h.tanggal.year == ceramicsYear(sekarang.year)) {
          totalBahanBakuBulanIni += h.totalPengeluaran;
        }
      }

      // =========================
      // KOMPOSISI PENGELUARAN
      // =========================
      Map<String, double> tempKomposisi = {
        'Bahan Baku': totalBahanBakuBulanIni,
      };

      for (var cat in listCategories) {
        if (cat.name != 'Bahan Baku') {
          tempKomposisi[cat.name] = 0.0;
        }
      }

      if (!tempKomposisi.containsKey('Lainnya')) {
        tempKomposisi['Lainnya'] = 0.0;
      }

      double totalManualBulanIni = 0;

      for (var exp in listExpensesBulanIni) {
        totalManualBulanIni += exp.nominal;

        String catName = exp.categoryName.isEmpty
            ? 'Lainnya'
            : exp.categoryName;

        tempKomposisi[catName] = (tempKomposisi[catName] ?? 0.0) + exp.nominal;
      }

      komposisiBulanIni.value = tempKomposisi;

      // =========================
      // TOTAL PENGELUARAN
      // =========================
      double grandTotalPengeluaranBulanIni =
          totalBahanBakuBulanIni + totalManualBulanIni;

      // =========================
      // PROFIT
      // =========================
      keuangan.value = old_summary.KeuanganSummary(
        pemasukan: totalPemasukanBulanIni,
        pengeluaran: grandTotalPengeluaranBulanIni,
        profit: totalPemasukanBulanIni - grandTotalPengeluaranBulanIni,
      );

      // =========================
      // LAPORAN TAHUNAN
      // =========================
      await hitungUlangLaporanTahunan(selectedYear.value);
    } catch (e) {
      print("Error pada loadDataKeuangan: $e");
    } finally {
      isLoading(false);
    }
  }

  int ceramicsYear(int year) => year;

  void changeYear(int year) {
    selectedYear.value = year;
    hitungUlangLaporanTahunan(year);
  }

  Future<void> hitungUlangLaporanTahunan(int year) async {
    Map<int, double> mapPemasukan = {};
    Map<int, double> mapPengeluaran = {};
    Map<int, int> mapTransaksi = {};

    // =========================
    // PEMASUKAN & TRANSAKSI
    // =========================
    for (var t in allTransactions) {
      final date = DateTime.tryParse(t.tanggal);

      if (date != null && date.year == year) {
        mapPemasukan[date.month] =
            (mapPemasukan[date.month] ?? 0) + t.totalHarga;

        mapTransaksi[date.month] = (mapTransaksi[date.month] ?? 0) + 1;
      }
    }

    // =========================
    // PENGELUARAN BAHAN BAKU
    // =========================
    for (var h in allHistoriStok) {
      if (h.tanggal.year == year) {
        mapPengeluaran[h.tanggal.month] =
            (mapPengeluaran[h.tanggal.month] ?? 0) + h.totalPengeluaran;
      }
    }

    // =========================
    // PENGELUARAN MANUAL
    // =========================
    try {
      final firstDayOfYear = DateTime(year, 1, 1);

      final lastDayOfYear = DateTime(year, 12, 31);

      final yearlyExpenses = await ApiService.getAllExpenses(
        startDate: _formatDate(firstDayOfYear),
        endDate: _formatDate(lastDayOfYear),
      );

      for (var exp in yearlyExpenses) {
        final date = DateTime.tryParse(exp.tanggal);

        if (date != null && date.year == year) {
          mapPengeluaran[date.month] =
              (mapPengeluaran[date.month] ?? 0) + exp.nominal;
        }
      }
    } catch (e) {
      print("Gagal memuat pengeluaran manual tahunan: $e");
    }

    // =========================
    // MEMBUAT REPORT
    // =========================
    List<FinancialReport> reports = [];

    for (int m = 1; m <= 12; m++) {
      double pem = mapPemasukan[m] ?? 0;
      double peng = mapPengeluaran[m] ?? 0;
      int trxCount = mapTransaksi[m] ?? 0;

      if (pem > 0 ||
          peng > 0 ||
          m <= DateTime.now().month ||
          year < DateTime.now().year) {
        reports.add(
          FinancialReport(
            tahun: year,
            bulan: m,
            pemasukan: pem,
            pengeluaran: peng,
            profit: pem - peng,
            totalTransaksi: trxCount,
          ),
        );
      }
    }

    filteredReports.value = reports;
  }

  Future<bool> tambahPengeluaranManual({
    required String tanggal,
    required int categoryId,
    required double nominal,
    required String keterangan,
  }) async {
    try {
      isLoading(true);

      bool success = await ApiService.createExpense(
        tanggal: tanggal,
        categoryId: categoryId,
        nominal: nominal,
        keterangan: keterangan,
      );

      if (success) {
        // Refresh seluruh data setelah
        // pengeluaran berhasil ditambahkan
        await loadDataKeuangan();

        return true;
      }

      return false;
    } catch (e) {
      print("Gagal menyimpan pengeluaran: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');

    final m = date.month.toString().padLeft(2, '0');

    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }
}
