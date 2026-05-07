const db = require("../config/db");

// ========================
// GET ALL DISKON
// ========================
exports.getAllDiskon = async (req, res) => {
  try {
    const [rows] = await db.execute("SELECT * FROM diskon ORDER BY id DESC");
    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error("ERROR GET ALL DISKON:", error);
    res.status(500).json({
      success: false,
      message: "Gagal mengambil data diskon",
    });
  }
};

// ========================
// GET DETAIL DISKON
// ========================
exports.getDiskonById = async (req, res) => {
  try {
    const { id } = req.params;

    // Nama kolom disesuaikan menjadi 'id' sesuai field kamu
    const [rows] = await db.execute(
      "SELECT * FROM diskon WHERE id = ?", 
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Diskon tidak ditemukan",
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });
  } catch (error) {
    console.error("ERROR DETAIL DISKON:", error);
    res.status(500).json({
      success: false,
      message: "Gagal mengambil detail diskon",
      error_debug: error.message // Membantu debugging jika ada error lain
    });
  }
};

// ========================
// CREATE DISKON
// ========================
exports.createDiskon = async (req, res) => {
  try {
    const { id, nama_diskon, persen_diskon, tanggal_mulai, tanggal_selesai, status } = req.body;

    await db.execute(
      `INSERT INTO diskon (id, nama_diskon, persen_diskon, tanggal_mulai, tanggal_selesai, status) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [id, nama_diskon, persen_diskon, tanggal_mulai, tanggal_selesai, status]
    );

    res.json({
      success: true,
      message: "Diskon berhasil ditambahkan",
    });
  } catch (error) {
    console.error("ERROR CREATE DISKON:", error);
    res.status(500).json({
      success: false,
      message: "Gagal menambah diskon",
    });
  }
};

// ========================
// UPDATE DISKON
// ========================
exports.updateDiskon = async (req, res) => {
  try {
    const { id } = req.params;
    const { nama_diskon, persen_diskon, tanggal_mulai, tanggal_selesai, status } = req.body;

    await db.execute(
      `UPDATE diskon 
       SET nama_diskon = ?, persen_diskon = ?, tanggal_mulai = ?, tanggal_selesai = ?, status = ? 
       WHERE id = ?`,
      [nama_diskon, persen_diskon, tanggal_mulai, tanggal_selesai, status, id]
    );

    res.json({
      success: true,
      message: "Diskon berhasil diperbarui",
    });
  } catch (error) {
    console.error("ERROR UPDATE DISKON:", error);
    res.status(500).json({
      success: false,
      message: "Gagal memperbarui diskon",
    });
  }
};

// ========================
// DELETE DISKON
// ========================
exports.deleteDiskon = async (req, res) => {
  try {
    const { id } = req.params;
    await db.execute("DELETE FROM diskon WHERE id = ?", [id]);
    res.json({
      success: true,
      message: "Diskon berhasil dihapus",
    });
  } catch (error) {
    console.error("ERROR DELETE DISKON:", error);
    res.status(500).json({
      success: false,
      message: "Gagal menghapus diskon",
    });
  }
};