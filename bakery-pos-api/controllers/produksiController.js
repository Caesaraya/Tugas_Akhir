const db = require("../config/db");

// ========================
// GET ALL PRODUKSI
// ========================
exports.getProduksi = async (req, res) => {
  try {

    const [rows] = await db.execute(
      `
      SELECT
        pr.id,
        pr.product_id,
        pr.jumlah_produksi,
        pr.tanggal,

        p.name,
        p.jenis,
        p.satuan

      FROM produksi pr

      JOIN products p
      ON pr.product_id = p.id

      ORDER BY pr.id DESC
      `
    );

    res.json({
      success: true,
      data: rows,
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil data produksi",
    });
  }
};

// ========================
// CREATE PRODUKSI
// ========================
exports.createProduksi = async (req, res) => {

  const connection = await db.getConnection();

  try {

    const {
      product_id,
      jumlah_produksi,
    } = req.body;

    if (!jumlah_produksi || jumlah_produksi <= 0) {
      throw new Error(
        "Jumlah produksi harus lebih dari 0"
      );
    }

    await connection.beginTransaction();

    // ========================
    // AMBIL PRODUK
    // ========================
    const [productRows] = await connection.execute(
      `
      SELECT
        id,
        name,
        stock,
        resep_id
      FROM products
      WHERE id = ?
      `,
      [product_id]
    );

    if (productRows.length === 0) {
      throw new Error("Produk tidak ditemukan");
    }

    const product = productRows[0];

    // ========================
    // VALIDASI RESEP
    // ========================
    if (!product.resep_id) {
      throw new Error(
        "Produk belum memiliki resep"
      );
    }

    // ========================
    // AMBIL DETAIL RESEP
    // ========================
    const [resepRows] = await connection.execute(
      `
      SELECT
        dr.id,
        dr.bahan_id,
        dr.jumlah_bahan,

        bb.nama_bahan,
        bb.stok

      FROM detail_resep dr

      JOIN bahan_baku bb
      ON dr.bahan_id = bb.id

      WHERE dr.resep_id = ?
      AND bb.deleted_at IS NULL
      `,
      [product.resep_id]
    );

    // ========================
    // VALIDASI STOK BAHAN
    // ========================
    for (const item of resepRows) {

      const totalKebutuhan =
        item.jumlah_bahan * jumlah_produksi;

      if (item.stok < totalKebutuhan) {

        throw new Error(
          `Stok bahan ${item.nama_bahan} tidak cukup`
        );
      }
    }

    // ========================
    // KURANGI STOK BAHAN
    // ========================
    for (const item of resepRows) {

      const totalKebutuhan =
        item.jumlah_bahan * jumlah_produksi;

      const [updateResult] =
        await connection.execute(
          `
        UPDATE bahan_baku
        SET stok = stok - ?
        WHERE id = ?
        AND stok >= ?
        `,
          [
            totalKebutuhan,
            item.bahan_id,
            totalKebutuhan,
          ]
        );

      if (updateResult.affectedRows === 0) {
        throw new Error(
          `Stok bahan ${item.nama_bahan} tidak cukup`
        );
      }
    }

    // ========================
    // TAMBAH STOK PRODUK
    // ========================
    await connection.execute(
      `
      UPDATE products
      SET stock = stock + ?
      WHERE id = ?
      `,
      [
        jumlah_produksi,
        product_id,
      ]
    );

    // ========================
    // INSERT PRODUKSI
    // ========================
    const [result] = await connection.execute(
      `
      INSERT INTO produksi
      (
        product_id,
        jumlah_produksi,
        tanggal
      )
      VALUES
      (
        ?, ?, NOW()
      )
      `,
      [
        product_id,
        jumlah_produksi,
      ]
    );

    await connection.commit();

    res.json({
      success: true,
      message: "Produksi berhasil",
      produksi_id: result.insertId,
      product_id,
      nama_produk: product.name,
      jumlah_produksi,
    });

  } catch (error) {

    await connection.rollback();

    console.log(error);

    res.status(500).json({
      success: false,
      message: error.message,
    });

  } finally {

    connection.release();
  }
};

// ========================
// GET PRODUKSI BY ID
// ========================
exports.getProduksiById = async (req, res) => {
  try {

    const { id } = req.params;

    const [rows] = await db.execute(
      `
      SELECT
        pr.*,
        p.name,
        p.jenis,
        p.satuan
      FROM produksi pr
      JOIN products p
      ON pr.product_id = p.id
      WHERE pr.id = ?
      `,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message:
          "Data produksi tidak ditemukan",
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message:
        "Gagal mengambil detail produksi",
    });
  }
};