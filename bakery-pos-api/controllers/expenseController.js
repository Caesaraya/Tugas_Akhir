const db = require("../config/db");

// ========================
// GET ALL EXPENSE CATEGORIES
// ========================
exports.getAllExpenseCategories = async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT
        id,
        name,
        description,
        created_at
      FROM expense_categories
      ORDER BY name ASC
    `);

    res.json({
      success: true,
      data: rows,
    });

  } catch (error) {
    console.log("ERROR GET EXPENSE CATEGORIES:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil kategori pengeluaran",
    });
  }
};

// ========================
// GET EXPENSE CATEGORY BY ID
// ========================
exports.getExpenseCategoryById = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await db.execute(
      `
      SELECT
        id,
        name,
        description,
        created_at
      FROM expense_categories
      WHERE id = ?
      `,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Kategori pengeluaran tidak ditemukan",
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });

  } catch (error) {
    console.log("ERROR GET EXPENSE CATEGORY BY ID:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil kategori pengeluaran",
    });
  }
};

// ========================
// CREATE EXPENSE CATEGORY
// ========================
exports.createExpenseCategory = async (req, res) => {
  try {
    const { name, description } = req.body;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: "Nama kategori harus diisi",
      });
    }

    const [result] = await db.execute(
      `
      INSERT INTO expense_categories (name, description)
      VALUES (?, ?)
      `,
      [name, description || null]
    );

    res.json({
      success: true,
      message: "Kategori pengeluaran berhasil dibuat",
      id: result.insertId,
    });

  } catch (error) {
    console.log("ERROR CREATE EXPENSE CATEGORY:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal membuat kategori pengeluaran",
    });
  }
};

// ========================
// UPDATE EXPENSE CATEGORY
// ========================
exports.updateExpenseCategory = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description } = req.body;

    if (!name) {
      return res.status(400).json({
        success: false,
        message: "Nama kategori harus diisi",
      });
    }

    const [result] = await db.execute(
      `
      UPDATE expense_categories
      SET name = ?, description = ?
      WHERE id = ?
      `,
      [name, description || null, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Kategori pengeluaran tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Kategori pengeluaran berhasil diupdate",
    });

  } catch (error) {
    console.log("ERROR UPDATE EXPENSE CATEGORY:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengupdate kategori pengeluaran",
    });
  }
};

// ========================
// DELETE EXPENSE CATEGORY
// ========================
exports.deleteExpenseCategory = async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await db.execute(
      `
      DELETE FROM expense_categories
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Kategori pengeluaran tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Kategori pengeluaran berhasil dihapus",
    });

  } catch (error) {
    console.log("ERROR DELETE EXPENSE CATEGORY:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal menghapus kategori pengeluaran",
    });
  }
};

// ========================
// GET ALL EXPENSES
// ========================
exports.getAllExpenses = async (req, res) => {
  try {
    const { category_id, start_date, end_date } = req.query;

    let query = `
      SELECT
        e.id,
        e.tanggal,
        e.category_id,
        ec.name as category_name,
        e.nominal,
        e.keterangan,
        e.created_at
      FROM expenses e
      LEFT JOIN expense_categories ec ON e.category_id = ec.id
      WHERE 1=1
    `;

    const params = [];

    if (category_id) {
      query += ` AND e.category_id = ?`;
      params.push(category_id);
    }

    if (start_date) {
      query += ` AND e.tanggal >= ?`;
      params.push(start_date);
    }

    if (end_date) {
      query += ` AND e.tanggal <= ?`;
      params.push(end_date);
    }

    query += ` ORDER BY e.tanggal DESC, e.created_at DESC`;

    const [rows] = await db.execute(query, params);

    res.json({
      success: true,
      data: rows,
    });

  } catch (error) {
    console.log("ERROR GET EXPENSES:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil pengeluaran",
    });
  }
};

// ========================
// GET EXPENSE BY ID
// ========================
exports.getExpenseById = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await db.execute(
      `
      SELECT
        e.id,
        e.tanggal,
        e.category_id,
        ec.name as category_name,
        e.nominal,
        e.keterangan,
        e.created_at
      FROM expenses e
      LEFT JOIN expense_categories ec ON e.category_id = ec.id
      WHERE e.id = ?
      `,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Pengeluaran tidak ditemukan",
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });

  } catch (error) {
    console.log("ERROR GET EXPENSE BY ID:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil pengeluaran",
    });
  }
};

// ========================
// CREATE EXPENSE
// ========================
exports.createExpense = async (req, res) => {
  try {
    const { tanggal, category_id, nominal, keterangan } = req.body;

    if (!tanggal || !category_id || !nominal) {
      return res.status(400).json({
        success: false,
        message: "Tanggal, kategori, dan nominal harus diisi",
      });
    }

    const [result] = await db.execute(
      `
      INSERT INTO expenses (tanggal, category_id, nominal, keterangan)
      VALUES (?, ?, ?, ?)
      `,
      [tanggal, category_id, nominal, keterangan || null]
    );

    res.json({
      success: true,
      message: "Pengeluaran berhasil dibuat",
      id: result.insertId,
    });

  } catch (error) {
    console.log("ERROR CREATE EXPENSE:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal membuat pengeluaran",
    });
  }
};

// ========================
// UPDATE EXPENSE
// ========================
exports.updateExpense = async (req, res) => {
  try {
    const { id } = req.params;
    const { tanggal, category_id, nominal, keterangan } = req.body;

    if (!tanggal || !category_id || !nominal) {
      return res.status(400).json({
        success: false,
        message: "Tanggal, kategori, dan nominal harus diisi",
      });
    }

    const [result] = await db.execute(
      `
      UPDATE expenses
      SET tanggal = ?, category_id = ?, nominal = ?, keterangan = ?
      WHERE id = ?
      `,
      [tanggal, category_id, nominal, keterangan || null, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Pengeluaran tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Pengeluaran berhasil diupdate",
    });

  } catch (error) {
    console.log("ERROR UPDATE EXPENSE:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengupdate pengeluaran",
    });
  }
};

// ========================
// DELETE EXPENSE
// ========================
exports.deleteExpense = async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await db.execute(
      `
      DELETE FROM expenses
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Pengeluaran tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Pengeluaran berhasil dihapus",
    });

  } catch (error) {
    console.log("ERROR DELETE EXPENSE:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal menghapus pengeluaran",
    });
  }
};

// ========================
// GET EXPENSE SUMMARY BY MONTH
// ========================
exports.getExpenseSummaryByMonth = async (req, res) => {
  try {
    const { tahun, bulan } = req.params;

    const [rows] = await db.execute(
      `
      SELECT
        ec.name as category_name,
        COALESCE(SUM(e.nominal), 0) as total_nominal,
        COUNT(e.id) as total_count
      FROM expense_categories ec
      LEFT JOIN expenses e ON ec.id = e.category_id
        AND YEAR(e.tanggal) = ?
        AND MONTH(e.tanggal) = ?
      GROUP BY ec.id, ec.name
      ORDER BY total_nominal DESC
      `,
      [tahun, bulan]
    );

    const [totalRow] = await db.execute(
      `
      SELECT COALESCE(SUM(nominal), 0) as grand_total
      FROM expenses
      WHERE YEAR(tanggal) = ? AND MONTH(tanggal) = ?
      `,
      [tahun, bulan]
    );

    res.json({
      success: true,
      data: {
        by_category: rows,
        grand_total: totalRow[0].grand_total,
      },
    });

  } catch (error) {
    console.log("ERROR GET EXPENSE SUMMARY BY MONTH:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil summary pengeluaran",
    });
  }
};
