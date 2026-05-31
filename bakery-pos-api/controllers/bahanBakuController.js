const db = require("../config/db");

// ========================
// GET ALL BAHAN BAKU
// ========================
exports.getAllBahanBaku = async (req, res) => {
  try {

    const [rows] = await db.execute(`
 SELECT
  id,
  nama_bahan,
  merk,
  satuan,
  stok,
  harga_satuan,
  (stok * harga_satuan) AS total_harga,
  created_at,
  deleted_at
FROM bahan_baku
ORDER BY (deleted_at IS NOT NULL) ASC, id DESC
    `);

    res.json({
      success: true,
      data: rows,
    });

  } catch (error) {

    console.log("ERROR GET BAHAN:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil bahan baku",
    });
  }
};

// ========================
// GET DETAIL BAHAN BAKU
// ========================
exports.getBahanBakuById = async (req, res) => {
  try {

    const { id } = req.params;

    const [rows] = await db.execute(
      `
SELECT
  id,
  nama_bahan,
  merk,
  satuan,
  stok,
  harga_satuan,
  (stok * harga_satuan) AS total_harga,
  created_at,
  deleted_at
FROM bahan_baku
WHERE id = ?
      `,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Bahan baku tidak ditemukan",
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });

  } catch (error) {

    console.log("ERROR DETAIL BAHAN:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil detail bahan",
    });
  }
};

// ========================
// CREATE BAHAN BAKU
// ========================
exports.createBahanBaku = async (req, res) => {
  try {

    const {
      nama_bahan,
      merk,
      satuan,
      stok,
      harga_satuan,
    } = req.body;

    if (
      !nama_bahan ||
      !merk ||
      !satuan
    ) {
      return res.status(400).json({
        success: false,
        message: "Data belum lengkap",
      });
    }

    const [result] = await db.execute(
      `
      INSERT INTO bahan_baku
      (
        nama_bahan,
        merk,
        satuan,
        stok,
        harga_satuan
      )
      VALUES
      (
        ?, ?, ?, ?, ?
      )
      `,
      [
        nama_bahan,
        merk,
        satuan,
        stok || 0,
        harga_satuan || 0,
      ]
    );

    res.json({
      success: true,
      message: "Bahan baku berhasil ditambahkan",
      id: result.insertId,
    });

  } catch (error) {

    console.log("ERROR CREATE BAHAN:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal menambah bahan baku",
    });
  }
};

// ========================
// UPDATE BAHAN BAKU
// ========================
exports.updateBahanBaku = async (req, res) => {
  try {

    const { id } = req.params;

    const {
      nama_bahan,
      merk,
      satuan,
      stok,
      harga_satuan,
    } = req.body;

    await db.execute(
      `
      UPDATE bahan_baku
      SET
        nama_bahan = ?,
        merk = ?,
        satuan = ?,
        stok = ?,
        harga_satuan = ?
      WHERE id = ?
      `,
      [
        nama_bahan,
        merk,
        satuan,
        stok,
        harga_satuan,
        id,
      ]
    );

    res.json({
      success: true,
      message: "Bahan baku berhasil diupdate",
    });

  } catch (error) {

    console.log("ERROR UPDATE BAHAN:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal update bahan baku",
    });
  }
};

// ========================
// SOFT DELETE BAHAN BAKU
// ========================
exports.deleteBahanBaku = async (req, res) => {
  try {

    const { id } = req.params;

    const [result] = await db.execute(
      `
      UPDATE bahan_baku
      SET deleted_at = NOW()
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Bahan baku tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Bahan baku berhasil dihapus",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal menghapus bahan baku",
    });
  }
};
// ========================
// RESTORE BAHAN BAKU
// ========================
exports.restoreBahanBaku = async (req, res) => {
  try {

    const { id } = req.params;

    const [result] = await db.execute(
      `
      UPDATE bahan_baku
      SET deleted_at = NULL
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Bahan baku tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Bahan baku berhasil direstore",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal restore bahan baku",
    });
  }
};
// ========================
// FORCE DELETE BAHAN BAKU
// ========================
exports.forceDeleteBahanBaku = async (req, res) => {
  try {

    const { id } = req.params;

    const [usedByRecipe] = await db.execute(
      `
      SELECT id
      FROM detail_resep
      WHERE bahan_id = ?
      LIMIT 1
      `,
      [id]
    );

    if (usedByRecipe.length > 0) {
      return res.status(400).json({
        success: false,
        message:
          "Bahan baku tidak bisa dihapus karena masih digunakan pada resep",
      });
    }

    const [result] = await db.execute(
      `
      DELETE FROM bahan_baku
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Bahan baku tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Bahan baku berhasil dihapus permanen",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal force delete bahan baku",
    });
  }
};