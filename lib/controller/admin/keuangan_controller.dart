import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../api service/api_service.dart';
import '../../models/transactions.dart';
import '../../models/keuangan_summary.dart';
import '../../models/histori_stok.dart';
import '../../models/financial_report.dart';
import '../../models/expense.dart';
import '../../models/expense_category.dart';

class KeuanganController extends GetxController {
  final isLoading = false.obs;
  final keuangan = KeuanganSummary.kosong().obs;
  final _storage = GetStorage();

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

  @override
  void onInit() {
    super.onInit();
    initialFetch();
  }

  Future<void> initialFetch() async {
    await fetchCategories();
    await loadDataKeuangan();
  }

  Future<void> fetchCategories() async {
    try {
      final cats = await ApiService.getAllExpenseCategories();
      listCategories.value = cats;
    } catch (e) {
      print("Gagal memuat kategori dari API: $e");
    }
  }

  // 1. TAMBAHAN: Fungsi untuk membuat kategori baru dari dialog input manual
  Future<int?> tambahKategoriBaru(String name) async {
    try {
      isLoading(true);
      // Panggil API pembuatan kategori baru
      bool success = await ApiService.createExpenseCategory(name: name);
      if (success) {
        // Refresh list kategori agar state lokal diperbarui
        await fetchCategories();

        // Cari kategori yang baru saja dibuat berdasarkan nama untuk mengambil ID-nya
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

      // 1. Ambil Data Pemasukan dari API Transaksi Backend
      final rawListData = await ApiService.getTransactions();
      allTransactions.value = rawListData
          .map<TransactionModel>((e) => TransactionModel.fromJson(e))
          .toList();

      // 2. Ambil Data Pengeluaran Bahan Baku (Pembelian) SECARA ONLINE dari API
      try {
        final rawPembelian = await ApiService.getAllPembelian();
        allHistoriStok.value = rawPembelian.map<HistoriStokModel>((p) {
          return HistoriStokModel(
            tanggal: p.tanggal,
            bahanBakuId: 0, // tidak tersedia di level header Pembelian
            namaBahan: p.namaSupplier ?? '',
            stokSebelum: 0.0,
            stokSesudah: 0.0,
            jumlahPenambahan: 0.0,
            hargaSatuan: 0.0,
            totalPengeluaran: p.total,
          );
        }).toList();
      } catch (e) {
        print("Gagal memuat data pembelian (Bahan Baku): $e");
        allHistoriStok.value = [];
      }

      // 3. Ambil Data Pengeluaran Manual dari API Backend sesuai Bulan Berjalan
      final firstDayBulanIni = DateTime(sekarang.year, sekarang.month, 1);
      final lastDayBulanIni = DateTime(sekarang.year, sekarang.month + 1, 0);
      final expenses = await ApiService.getAllExpenses(
        startDate: _formatDate(firstDayBulanIni),
        endDate: _formatDate(lastDayBulanIni),
      );
      listExpensesBulanIni.value = expenses;

      // 4. Sinkronisasi Tahun untuk Dropdown Filter
      final years = allTransactions
          .map((t) => DateTime.tryParse(t.tanggal)?.year)
          .where((y) => y != null)
          .cast<int>()
          .toSet()
          .toList();
      if (!years.contains(sekarang.year)) years.add(sekarang.year);
      years.sort((a, b) => b.compareTo(a));
      availableYears.value = years;

      // 5. Hitung Nilai Berjalan untuk Summary Card & Komposisi Grafik
      double totalPemasukanBulanIni = 0;
      for (var trx in allTransactions) {
        final date = DateTime.tryParse(trx.tanggal);
        if (date != null &&
            date.month == sekarang.month &&
            date.year == sekarang.year) {
          totalPemasukanBulanIni += trx.totalHarga;
        }
      }

      double totalBahanBakuBulanIni = 0;
      for (var h in allHistoriStok) {
        if (h.tanggal.month == sekarang.month &&
            h.tanggal.year == sekarang.year) {
          totalBahanBakuBulanIni += h.totalPengeluaran;
        }
      }

      // --- PERBAIKAN LOGIKA KOMPOSISI PENGELUARAN ---
      Map<String, double> tempKomposisi = {};

      // Masukkan semua kategori resmi dari database terlebih dahulu dengan nilai default 0.0
      for (var cat in listCategories) {
        tempKomposisi[cat.name] = 0.0;
      }

      // Berikan fallback jika 'Bahan Baku' atau 'Lainnya' belum terdaftar di database
      if (!tempKomposisi.containsKey('Bahan Baku')) {
        tempKomposisi['Bahan Baku'] = 0.0;
      }
      if (!tempKomposisi.containsKey('Lainnya')) {
        tempKomposisi['Lainnya'] = 0.0;
      }

      // Cari penulisan nama kategori bahan baku yang valid dari database (Case-Insensitive)
      final bahanBakuCategory = listCategories.firstWhereOrNull(
        (c) => c.name.toLowerCase() == 'bahan baku',
      );
      String namaKategoriBahanBaku = bahanBakuCategory?.name ?? 'Bahan Baku';

      // Plot total pengeluaran dari histori stok (pembelian) ke kategori Bahan Baku
      tempKomposisi[namaKategoriBahanBaku] = totalBahanBakuBulanIni;

      // Hitung akumulasi dari pengeluaran manual bulanan
      double totalManualBulanIni = 0;
      for (var exp in listExpensesBulanIni) {
        totalManualBulanIni += exp.nominal;
        String catName = exp.categoryName.isEmpty
            ? 'Lainnya'
            : exp.categoryName;

        // Akumulasikan nilai pengeluaran manual (jika ada input manual dengan kategori Bahan Baku, data akan digabung secara aman)
        tempKomposisi[catName] = (tempKomposisi[catName] ?? 0.0) + exp.nominal;
      }

      komposisiBulanIni.value = tempKomposisi;
      double grandTotalPengeluaranBulanIni =
          totalBahanBakuBulanIni + totalManualBulanIni;

      keuangan.value = KeuanganSummary(
        pemasukan: totalPemasukanBulanIni,
        pengeluaran: grandTotalPengeluaranBulanIni,
        profit: totalPemasukanBulanIni - grandTotalPengeluaranBulanIni,
      );

      // Hitung akumulasi tabel rekap tahunan
      await hitungUlangLaporanTahunan(selectedYear.value);
    } catch (e) {
      print("Error pada loadDataKeuangan: $e");
    } finally {
      isLoading(false);
    }
  }

  void changeYear(int year) {
    selectedYear.value = year;
    hitungUlangLaporanTahunan(year);
  }

  Future<void> hitungUlangLaporanTahunan(int year) async {
    Map<int, double> mapPemasukan = {};
    Map<int, double> mapPengeluaran = {};
    Map<int, int> mapTransaksi = {};

    for (var t in allTransactions) {
      final date = DateTime.tryParse(t.tanggal);
      if (date != null && date.year == year) {
        mapPemasukan[date.month] =
            (mapPemasukan[date.month] ?? 0) + t.totalHarga;
        mapTransaksi[date.month] = (mapTransaksi[date.month] ?? 0) + 1;
      }
    }

    for (var h in allHistoriStok) {
      if (h.tanggal.year == year) {
        mapPengeluaran[h.tanggal.month] =
            (mapPengeluaran[h.tanggal.month] ?? 0) + h.totalPengeluaran;
      }
    }

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
