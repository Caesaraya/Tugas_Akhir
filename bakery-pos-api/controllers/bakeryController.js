const db = require("../config/db");

// ========================
// HITUNG KEBUTUHAN BAHAN
// ========================
exports.hitungKebutuhanBahan = async (req, res) => {
  try {
    const { produk_id, quantity } = req.query;

    if (!produk_id || !quantity) {
      return res.status(400).json({
        success: false,
        message: "produk_id dan quantity wajib diisi",
      });
    }

    const qty = parseInt(quantity);

    const query = `
      SELECT
        bb.id AS bahan_id,
        bb.nama_bahan,
        bb.merk,
        bb.satuan,
        bb.stok AS stok_tersedia,
        bb.harga_satuan,

        dr.jumlah_bahan AS kebutuhan_per_produk,

        (dr.jumlah_bahan * ?) AS total_dibutuhkan,

        (bb.stok - (dr.jumlah_bahan * ?)) AS sisa_stok,

        CASE
          WHEN bb.stok >= (dr.jumlah_bahan * ?)
          THEN 1
          ELSE 0
        END AS cukup,

        CASE
          WHEN bb.stok < (dr.jumlah_bahan * ?)
          THEN ((dr.jumlah_bahan * ?) - bb.stok)
          ELSE 0
        END AS kekurangan

      FROM products p

      JOIN resep r
        ON p.resep_id = r.id

      JOIN detail_resep dr
        ON r.id = dr.resep_id

      JOIN bahan_baku bb
        ON dr.bahan_id = bb.id

      WHERE p.id = ?
    `;

    const [rows] = await db.execute(query, [
      qty,
      qty,
      qty,
      qty,
      qty,
      produk_id,
    ]);

    const totalBiaya = rows.reduce((sum, item) => {
      return (
        sum +
        Number(item.total_dibutuhkan) *
          Number(item.harga_satuan)
      );
    }, 0);

    const semuaCukup = rows.every(
      (item) => item.cukup === 1
    );

    res.json({
      success: true,
      data: {
        produk_id: Number(produk_id),
        quantity: qty,
        bahan: rows,
        total_biaya: totalBiaya,
        semua_bahan_cukup: semuaCukup,
      },
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ========================
// CEK KETERSEDIAAN BAHAN
// ========================
exports.cekKetersediaanBahan = async (req, res) => {
  try {
    const { produk_id, quantity } = req.query;

    if (!produk_id || !quantity) {
      return res.status(400).json({
        success: false,
        message: "produk_id dan quantity wajib diisi",
      });
    }

    const qty = parseInt(quantity);

    const query = `
      SELECT
        COUNT(*) AS total_bahan,

        SUM(
          CASE
            WHEN bb.stok >= (dr.jumlah_bahan * ?)
            THEN 1
            ELSE 0
          END
        ) AS bahan_cukup,

        SUM(
          CASE
            WHEN bb.stok < (dr.jumlah_bahan * ?)
            THEN 1
            ELSE 0
          END
        ) AS bahan_kurang

      FROM products p

      JOIN resep r
        ON p.resep_id = r.id

      JOIN detail_resep dr
        ON r.id = dr.resep_id

      JOIN bahan_baku bb
        ON dr.bahan_id = bb.id

      WHERE p.id = ?
    `;

    const [rows] = await db.execute(query, [
      qty,
      qty,
      produk_id,
    ]);

    const result = rows[0];

    res.json({
      success: true,
      data: {
        ...result,
        semua_bahan_cukup:
          Number(result.bahan_kurang) === 0,
      },
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ========================
// HITUNG BIAYA PRODUKSI
// ========================
exports.hitungBiayaProduksi = async (req, res) => {
  try {
    const { produk_id, quantity } = req.query;

    if (!produk_id || !quantity) {
      return res.status(400).json({
        success: false,
        message: "produk_id dan quantity wajib diisi",
      });
    }

    const qty = parseInt(quantity);

    const query = `
      SELECT
        SUM(
          (dr.jumlah_bahan * ?)
          *
          bb.harga_satuan
        ) AS total_biaya

      FROM products p

      JOIN resep r
        ON p.resep_id = r.id

      JOIN detail_resep dr
        ON r.id = dr.resep_id

      JOIN bahan_baku bb
        ON dr.bahan_id = bb.id

      WHERE p.id = ?
    `;

    const [rows] = await db.execute(query, [
      qty,
      produk_id,
    ]);

    res.json({
      success: true,
      data: rows[0],
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ========================
// PRODUK YANG BISA DIPRODUKSI
// ========================
exports.getProduksiPossible = async (req, res) => {
  try {
    const qty = Number(req.query.quantity || 1);

    const [products] = await db.execute(`
      SELECT
        id,
        name,
        stock,
        resep_id
      FROM products
      WHERE resep_id IS NOT NULL
      AND deleted_at IS NULL
    `);

    const hasil = [];

    for (const product of products) {
      const [check] = await db.execute(
        `
        SELECT
          COUNT(*) AS total_bahan,

          SUM(
            CASE
              WHEN bb.stok >= (dr.jumlah_bahan * ?)
              THEN 1
              ELSE 0
            END
          ) AS bahan_cukup

        FROM detail_resep dr

        JOIN bahan_baku bb
          ON dr.bahan_id = bb.id

        WHERE dr.resep_id = ?
        `,
        [qty, product.resep_id]
      );

      const data = check[0];

      hasil.push({
        ...product,
        quantity: qty,
        bisa_diproduksi:
          Number(data.total_bahan) ===
          Number(data.bahan_cukup),
      });
    }

    res.json({
      success: true,
      data: hasil,
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};