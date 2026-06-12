const db = require("../config/db");

// ========================
// GET ALL FINANCIAL REPORTS
// ========================
exports.getAllFinancialReports = async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT
        id,
        tahun,
        bulan,
        pemasukan,
        pengeluaran,
        profit,
        total_transaksi,
        created_at,
        updated_at
      FROM financial_reports
      ORDER BY tahun DESC, bulan DESC
    `);

    res.json({
      success: true,
      data: rows,
    });

  } catch (error) {
    console.log("ERROR GET FINANCIAL REPORTS:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil laporan keuangan",
    });
  }
};

// ========================
// GET FINANCIAL REPORT BY YEAR AND MONTH
// ========================
exports.getFinancialReportByMonth = async (req, res) => {
  try {
    const { tahun, bulan } = req.params;

    const [rows] = await db.execute(
      `
      SELECT
        id,
        tahun,
        bulan,
        pemasukan,
        pengeluaran,
        profit,
        total_transaksi,
        created_at,
        updated_at
      FROM financial_reports
      WHERE tahun = ? AND bulan = ?
      `,
      [tahun, bulan]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Laporan keuangan tidak ditemukan",
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });

  } catch (error) {
    console.log("ERROR GET FINANCIAL REPORT BY MONTH:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil laporan keuangan",
    });
  }
};

// ========================
// GENERATE FINANCIAL REPORT FOR MONTH
// ========================
exports.generateFinancialReport = async (req, res) => {
  try {
    const { tahun, bulan } = req.body;

    if (!tahun || !bulan) {
      return res.status(400).json({
        success: false,
        message: "Tahun dan bulan harus diisi",
      });
    }

    // Calculate pemasukan from transactions
    const [pemasukanResult] = await db.execute(
      `
      SELECT
        COALESCE(SUM(total_harga), 0) AS total_pemasukan,
        COUNT(*) AS total_transaksi
      FROM transactions
      WHERE YEAR(tanggal) = ? AND MONTH(tanggal) = ?
      `,
      [tahun, bulan]
    );

    // Calculate pengeluaran from pembelian_bahan
    const [pengeluaranResult] = await db.execute(
      `
      SELECT
        COALESCE(SUM(total), 0) AS total_pengeluaran
      FROM pembelian_bahan
      WHERE YEAR(tanggal) = ? AND MONTH(tanggal) = ?
      `,
      [tahun, bulan]
    );

    const pemasukan = pemasukanResult[0].total_pemasukan;
    const pengeluaran = pengeluaranResult[0].total_pengeluaran;
    const total_transaksi = pemasukanResult[0].total_transaksi;
    const profit = pemasukan - pengeluaran;

    // Check if report already exists
    const [existingReport] = await db.execute(
      `
      SELECT id FROM financial_reports
      WHERE tahun = ? AND bulan = ?
      `,
      [tahun, bulan]
    );

    if (existingReport.length > 0) {
      // Update existing report
      await db.execute(
        `
        UPDATE financial_reports
        SET
          pemasukan = ?,
          pengeluaran = ?,
          profit = ?,
          total_transaksi = ?
        WHERE tahun = ? AND bulan = ?
        `,
        [pemasukan, pengeluaran, profit, total_transaksi, tahun, bulan]
      );

      res.json({
        success: true,
        message: "Laporan keuangan berhasil diupdate",
        data: {
          tahun,
          bulan,
          pemasukan,
          pengeluaran,
          profit,
          total_transaksi,
        },
      });
    } else {
      // Create new report
      const [result] = await db.execute(
        `
        INSERT INTO financial_reports
        (tahun, bulan, pemasukan, pengeluaran, profit, total_transaksi)
        VALUES (?, ?, ?, ?, ?, ?)
        `,
        [tahun, bulan, pemasukan, pengeluaran, profit, total_transaksi]
      );

      res.json({
        success: true,
        message: "Laporan keuangan berhasil dibuat",
        id: result.insertId,
        data: {
          tahun,
          bulan,
          pemasukan,
          pengeluaran,
          profit,
          total_transaksi,
        },
      });
    }

  } catch (error) {
    console.log("ERROR GENERATE FINANCIAL REPORT:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal membuat laporan keuangan",
    });
  }
};

// ========================
// DELETE FINANCIAL REPORT
// ========================
exports.deleteFinancialReport = async (req, res) => {
  try {
    const { tahun, bulan } = req.params;

    const [result] = await db.execute(
      `
      DELETE FROM financial_reports
      WHERE tahun = ? AND bulan = ?
      `,
      [tahun, bulan]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Laporan keuangan tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Laporan keuangan berhasil dihapus",
    });

  } catch (error) {
    console.log("ERROR DELETE FINANCIAL REPORT:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal menghapus laporan keuangan",
    });
  }
};

// ========================
// GET FINANCIAL SUMMARY
// ========================
exports.getFinancialSummary = async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT
        COUNT(*) AS total_bulan,
        SUM(pemasukan) AS total_pemasukan,
        SUM(pengeluaran) AS total_pengeluaran,
        SUM(profit) AS total_profit,
        SUM(total_transaksi) AS total_transaksi
      FROM financial_reports
    `);

    res.json({
      success: true,
      data: rows[0],
    });

  } catch (error) {
    console.log("ERROR GET FINANCIAL SUMMARY:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil summary keuangan",
    });
  }
};
