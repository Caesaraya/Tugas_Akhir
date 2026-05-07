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
        deskripsi
      FROM resep
      ORDER BY id DESC
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
        deskripsi
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

        (dr.jumlah_bahan * bb.harga_satuan)
        AS total_harga_bahan

      FROM detail_resep dr

      JOIN bahan_baku bb
      ON dr.bahan_id = bb.id

      WHERE dr.resep_id = ?
      `,
      [id]
    );

    res.json({
      success: true,
      resep: resepRows[0],
      bahan: detailRows,
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
// DELETE RESEP
// ========================
exports.deleteResep = async (req, res) => {
  const connection = await db.getConnection();

  try {

    const { id } = req.params;

    await connection.beginTransaction();

    // HAPUS DETAIL
    await connection.execute(
      `
      DELETE FROM detail_resep
      WHERE resep_id = ?
      `,
      [id]
    );

    // HAPUS RESEP
    await connection.execute(
      `
      DELETE FROM resep
      WHERE id = ?
      `,
      [id]
    );

    await connection.commit();

    res.json({
      success: true,
      message: "Resep berhasil dihapus",
    });

  } catch (error) {

    await connection.rollback();

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal hapus resep",
    });

  } finally {

    connection.release();
  }
};