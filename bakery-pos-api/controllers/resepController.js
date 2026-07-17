const db = require("../config/db");

// ========================
// GET ALL RESEP
// ========================
exports.getAllResep = async (req, res) => {
  try {

    const [rows] = await db.execute(`
  SELECT
    id,
    nama_resep,
    deskripsi,
    deleted_at
  FROM resep
  ORDER BY (deleted_at IS NOT NULL) ASC, id DESC
`);

    res.json({
      success: true,
      data: rows,
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil resep",
    });
  }
};

// ========================
// GET DETAIL RESEP
// ========================
exports.getDetailResep = async (req, res) => {
  try {

    const { id } = req.params;

    // HEADER RESEP
    const [resepRows] = await db.execute(
      `
  SELECT
    id,
    nama_resep,
    deskripsi,
    deleted_at
  FROM resep
  WHERE id = ?
  `,
      [id]
    );

    if (resepRows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Resep tidak ditemukan",
      });
    }

    // DETAIL BAHAN
    const [detailRows] = await db.execute(
      `
      SELECT
        dr.id,
        dr.resep_id,
        dr.bahan_id,
        dr.jumlah_bahan,

        bb.nama_bahan,
        bb.merk,
        bb.satuan,
        bb.harga_satuan,

        ROUND(dr.jumlah_bahan * bb.harga_satuan, 2)
        AS total_harga_bahan

      FROM detail_resep dr

      JOIN bahan_baku bb
      ON dr.bahan_id = bb.id

      WHERE dr.resep_id = ?
      `,
      [id]
    );

    // PRODUK YANG MENGGUNAKAN RESEP
    const [productRows] = await db.execute(
      `
      SELECT
        id,
        name,
        stock
      FROM products
      WHERE resep_id = ?
      `,
      [id]
    );

    res.json({
      success: true,
      resep: resepRows[0],
      bahan: detailRows,
      products: productRows,
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil detail resep",
    });
  }
};

// ========================
// CREATE RESEP
// ========================
exports.createResep = async (req, res) => {
  const connection = await db.getConnection();

  try {

    const {
      nama_resep,
      deskripsi,
      bahan,
    } = req.body;

    if (!bahan || bahan.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Minimal harus ada 1 bahan",
      });
    }

    await connection.beginTransaction();

    // INSERT RESEP
    const [resepResult] = await connection.execute(
      `
      INSERT INTO resep
      (
        nama_resep,
        deskripsi
      )
      VALUES
      (
        ?, ?
      )
      `,
      [
        nama_resep,
        deskripsi,
      ]
    );

    const resepId = resepResult.insertId;

    // INSERT DETAIL RESEP
    for (const item of bahan) {

      await connection.execute(
        `
        INSERT INTO detail_resep
        (
          resep_id,
          bahan_id,
          jumlah_bahan
        )
        VALUES
        (
          ?, ?, ?
        )
        `,
        [
          resepId,
          item.bahan_id,
          item.jumlah_bahan,
        ]
      );
    }

    await connection.commit();

    res.json({
      success: true,
      message: "Resep berhasil dibuat",
      resep_id: resepId,
    });

  } catch (error) {

    await connection.rollback();

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal membuat resep",
    });

  } finally {

    connection.release();
  }
};

// ========================
// UPDATE RESEP
// ========================
exports.updateResep = async (req, res) => {
  const connection = await db.getConnection();

  try {

    const { id } = req.params;

    const {
      nama_resep,
      deskripsi,
      bahan,
    } = req.body;

    if (!bahan || bahan.length === 0) {
      return res.status(400).json({
        success: false,
        message: "Minimal harus ada 1 bahan",
      });
    }

    await connection.beginTransaction();

    // UPDATE HEADER
    await connection.execute(
      `
      UPDATE resep
      SET
        nama_resep = ?,
        deskripsi = ?
      WHERE id = ?
      `,
      [
        nama_resep,
        deskripsi,
        id,
      ]
    );

    // HAPUS DETAIL LAMA
    await connection.execute(
      `
      DELETE FROM detail_resep
      WHERE resep_id = ?
      `,
      [id]
    );

    // INSERT ULANG DETAIL
    for (const item of bahan) {

      await connection.execute(
        `
        INSERT INTO detail_resep
        (
          resep_id,
          bahan_id,
          jumlah_bahan
        )
        VALUES
        (
          ?, ?, ?
        )
        `,
        [
          id,
          item.bahan_id,
          item.jumlah_bahan,
        ]
      );
    }

    await connection.commit();

    res.json({
      success: true,
      message: "Resep berhasil diupdate",
    });

  } catch (error) {

    await connection.rollback();

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal update resep",
    });

  } finally {

    connection.release();
  }
};

// ========================
// SOFT DELETE RESEP
// ========================
exports.deleteResep = async (req, res) => {
  try {

    const { id } = req.params;

    const [result] = await db.execute(
      `
      UPDATE resep
      SET deleted_at = NOW()
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Resep tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Resep berhasil dihapus",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal menghapus resep",
    });
  }
};

// ========================
// RESTORE RESEP
// ========================
exports.restoreResep = async (req, res) => {
  try {

    const { id } = req.params;

    const [result] = await db.execute(
      `
      UPDATE resep
      SET deleted_at = NULL
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Resep tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Resep berhasil direstore",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal restore resep",
    });
  }
};

// ========================
// FORCE DELETE RESEP
// ========================
exports.forceDeleteResep = async (req, res) => {
  try {

    const { id } = req.params;

    const [usedByProduct] = await db.execute(
      `
      SELECT id
      FROM products
      WHERE resep_id = ?
      AND deleted_at IS NULL
      LIMIT 1
      `,
      [id]
    );

    if (usedByProduct.length > 0) {
      return res.status(400).json({
        success: false,
        message:
          "Resep tidak bisa dihapus karena masih digunakan pada produk",
      });
    }

    await db.execute(
      `
      DELETE FROM detail_resep
      WHERE resep_id = ?
      `,
      [id]
    );

    const [result] = await db.execute(
      `
      DELETE FROM resep
      WHERE id = ?
      `,
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: "Resep tidak ditemukan",
      });
    }

    res.json({
      success: true,
      message: "Resep berhasil dihapus permanen",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal force delete resep",
    });
  }
};