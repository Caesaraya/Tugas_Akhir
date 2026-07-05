const db = require("../config/db");

// ========================
// GET DASHBOARD SUMMARY
// ========================
exports.getDashboardSummary = async (req, res) => {
  try {
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    const todayStr = today.toISOString().split('T')[0];
    const yesterdayStr = yesterday.toISOString().split('T')[0];

    // ========================
    // 1. Omzet Hari Ini
    // ========================
    const [todayRevenueResult] = await db.execute(
      `
      SELECT
        COALESCE(SUM(total_harga), 0) AS omzet_hari_ini
      FROM transactions
      WHERE DATE(tanggal) = ?
      `,
      [todayStr]
    );

    const omzetHariIni = parseFloat(todayRevenueResult[0].omzet_hari_ini) || 0;

    // ========================
    // 2. Omzet Kemarin
    // ========================
    const [yesterdayRevenueResult] = await db.execute(
      `
      SELECT
        COALESCE(SUM(total_harga), 0) AS omzet_kemarin
      FROM transactions
      WHERE DATE(tanggal) = ?
      `,
      [yesterdayStr]
    );

    const omzetKemarin = parseFloat(yesterdayRevenueResult[0].omzet_kemarin) || 0;

    // ========================
    // 3. Persentase Perubahan
    // ========================
    let persentasePerubahan = 0;
    if (omzetKemarin > 0) {
      persentasePerubahan = ((omzetHariIni - omzetKemarin) / omzetKemarin) * 100;
    } else if (omzetHariIni > 0) {
      persentasePerubahan = 100;
    }

    // ========================
    // 4. Profit Bulan Ini
    // ========================
    const currentMonth = today.getMonth() + 1;
    const currentYear = today.getFullYear();

    const [monthRevenueResult] = await db.execute(
      `
      SELECT
        COALESCE(SUM(total_harga), 0) AS pemasukan_bulan_ini
      FROM transactions
      WHERE MONTH(tanggal) = ? AND YEAR(tanggal) = ?
      `,
      [currentMonth, currentYear]
    );

    const [monthExpenseResult] = await db.execute(
      `
      SELECT
        COALESCE(SUM(total), 0) AS pengeluaran_bulan_ini
      FROM pembelian_bahan
      WHERE MONTH(tanggal) = ? AND YEAR(tanggal) = ?
      `,
      [currentMonth, currentYear]
    );

    const pemasukanBulanIni = parseFloat(monthRevenueResult[0].pemasukan_bulan_ini) || 0;
    const pengeluaranBulanIni = parseFloat(monthExpenseResult[0].pengeluaran_bulan_ini) || 0;
    const profitBulanIni = pemasukanBulanIni - pengeluaranBulanIni;

    // ========================
    // 5. Total Transaksi Bulan Ini
    // ========================
    const [monthTransactionResult] = await db.execute(
      `
      SELECT
        COUNT(*) AS total_transaksi_bulan_ini
      FROM transactions
      WHERE MONTH(tanggal) = ? AND YEAR(tanggal) = ?
      `,
      [currentMonth, currentYear]
    );

    const totalTransaksiBulanIni = monthTransactionResult[0].total_transaksi_bulan_ini;

    // ========================
    // 6. Jumlah Bahan Baku Kritis
    // ========================
    const [criticalStockResult] = await db.execute(
      `
      SELECT
        COUNT(*) AS jumlah_bahan_kritis
      FROM bahan_baku
      WHERE deleted_at IS NULL
      AND stok <= 10
      `
    );

    const jumlahBahanKritis = criticalStockResult[0].jumlah_bahan_kritis;

    res.json({
      success: true,
      data: {
        omzet_hari_ini: omzetHariIni,
        omzet_kemarin: omzetKemarin,
        persentase_perubahan: persentasePerubahan,
        profit_bulan_ini: profitBulanIni,
        total_transaksi_bulan_ini: totalTransaksiBulanIni,
        jumlah_bahan_kritis: jumlahBahanKritis,
      },
    });

  } catch (error) {
    console.log("ERROR GET DASHBOARD SUMMARY:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil dashboard summary",
    });
  }
};

// ========================
// GET DASHBOARD ACTIVITIES
// ========================
exports.getDashboardActivities = async (req, res) => {
  try {
    const limit = req.query.limit ? parseInt(req.query.limit) : 10;

    // ========================
    // 1. Pembelian Bahan Baku
    // ========================
    const [pembelianActivities] = await db.query(
      `
      SELECT
        'pembelian' AS jenis_aktivitas,
        CONCAT('Pembelian ', s.nama_supplier, ' total Rp', pb.total) AS deskripsi,
        pb.tanggal AS waktu
      FROM pembelian_bahan pb
      JOIN supplier s ON pb.supplier_id = s.id
      ORDER BY pb.tanggal DESC
      LIMIT ${limit}
      `
    );

    // ========================
    // 2. Produksi (Penggunaan Bahan Baku)
    // ========================
    const [produksiActivities] = await db.query(
      `
      SELECT
        'produksi' AS jenis_aktivitas,
        CONCAT('Produksi ', p.name, ' sebanyak ', pr.jumlah_produksi, ' ', p.satuan) AS deskripsi,
        pr.tanggal AS waktu
      FROM produksi pr
      JOIN products p ON pr.product_id = p.id
      ORDER BY pr.tanggal DESC
      LIMIT ${limit}
      `
    );

    // ========================
    // 3. Transaksi Penjualan
    // ========================
    const [transactionActivities] = await db.query(
      `
      SELECT
        'transaksi' AS jenis_aktivitas,
        CONCAT('Transaksi Rp', t.total_harga, ' - ', t.metode_pembayaran) AS deskripsi,
        t.tanggal AS waktu
      FROM transactions t
      ORDER BY t.tanggal DESC
      LIMIT ${limit}
      `
    );

    // ========================
    // 4. Gabungkan dan Urutkan
    // ========================
    const allActivities = [
      ...pembelianActivities.map(a => ({
        ...a,
        icon: '🛒'
      })),
      ...produksiActivities.map(a => ({
        ...a,
        icon: '🏭'
      })),
      ...transactionActivities.map(a => ({
        ...a,
        icon: '💰'
      }))
    ];

    // Sort by waktu descending
    allActivities.sort((a, b) => new Date(b.waktu) - new Date(a.waktu));

    // Limit result
    const limitedActivities = allActivities.slice(0, limit);

    res.json({
      success: true,
      data: limitedActivities,
    });

  } catch (error) {
    console.log("ERROR GET DASHBOARD ACTIVITIES:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil dashboard activities",
    });
  }
};
