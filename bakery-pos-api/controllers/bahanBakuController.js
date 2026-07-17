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
  ROUND(stok * harga_satuan, 2) AS total_harga,
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
  ROUND(stok * harga_satuan, 2) AS total_harga,
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

    // Cascade delete: remove from detail_resep first
    await db.execute(
      `
      DELETE FROM detail_resep
      WHERE bahan_id = ?
      `,
      [id]
    );

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

// ========================
// CEK DIGUNAKAN DI RESEP
// ========================
exports.checkUsage = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await db.execute(
      `
      SELECT
        r.id,
        r.nama_resep
      FROM detail_resep dr
      JOIN resep r
      ON dr.resep_id = r.id
      WHERE dr.bahan_id = ?
      `,
      [id]
    );

    res.json({
      success: true,
      total_digunakan: rows.length,
      resep: rows,
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal cek penggunaan bahan",
    });
  }
};

// ========================
// GET STOK SUMMARY
// ========================
exports.getStockSummary = async (req, res) => {
  try {

    const [rows] = await db.execute(`
      SELECT
        COUNT(*) AS total_bahan,
        SUM(stok) AS total_stok,
        SUM(stok * harga_satuan) AS total_nilai
      FROM bahan_baku
      WHERE deleted_at IS NULL
    `);

    res.json({
      success: true,
      data: rows[0],
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil summary stok",
    });
  }
};

// ========================
// KONFIRMASI PENGAMBILAN BAHAN BERDASARKAN RESEP
// ========================
exports.konfirmasiPengambilanBahanResep = async (req, res) => {
  const connection = await db.getConnection();

  try {
    const { resep_id, jumlah_produksi } = req.body;

    if (!resep_id || !Number.isInteger(Number(resep_id))) {
      return res.status(422).json({
        success: false,
        message: "resep_id wajib ada dan harus integer"
      });
    }

    const qty = Number(jumlah_produksi);
    if (!Number.isInteger(qty) || qty <= 0) {
      return res.status(422).json({
        success: false,
        message: "Jumlah produksi harus lebih besar dari 0"
      });
    }

    await connection.beginTransaction();

    const [resepRows] = await connection.execute(
      `
      SELECT id, nama_resep
      FROM resep
      WHERE id = ?
      AND deleted_at IS NULL
      `,
      [resep_id]
    );

    if (resepRows.length === 0) {
      await connection.rollback();
      return res.status(404).json({
        success: false,
        message: "Resep tidak ditemukan"
      });
    }

    const [detailRows] = await connection.execute(
      `
      SELECT
        dr.bahan_id,
        dr.jumlah_bahan,
        bb.nama_bahan,
        bb.stok,
        bb.satuan
      FROM detail_resep dr
      JOIN bahan_baku bb
        ON dr.bahan_id = bb.id
      WHERE dr.resep_id = ?
      AND bb.deleted_at IS NULL
      `,
      [resep_id]
    );

    if (!detailRows || detailRows.length === 0) {
      await connection.rollback();
      return res.status(422).json({
        success: false,
        message: "Resep tidak memiliki bahan yang terdaftar"
      });
    }

    const bahanKurang = [];
    const bahanTerpakai = [];

    for (const item of detailRows) {
      const kebutuhan = Number(item.jumlah_bahan) * qty;

      if (Number(item.stok) < kebutuhan) {
        bahanKurang.push({
          bahan_baku_id: item.bahan_id,
          nama_bahan: item.nama_bahan,
          stok_tersedia: Number(item.stok),
          dibutuhkan: kebutuhan,
          kekurangan: kebutuhan - Number(item.stok)
        });
      }
    }

    if (bahanKurang.length > 0) {
      await connection.rollback();
      return res.status(422).json({
        success: false,
        message: "Stok bahan baku tidak mencukupi",
        data: {
          bahan_kurang: bahanKurang
        }
      });
    }

    for (const item of detailRows) {
      const kebutuhan = Number(item.jumlah_bahan) * qty;

      const [updateResult] = await connection.execute(
        `
        UPDATE bahan_baku
        SET stok = stok - ?
        WHERE id = ?
        AND deleted_at IS NULL
        AND stok >= ?
        `,
        [kebutuhan, item.bahan_id, kebutuhan]
      );

      if (updateResult.affectedRows === 0) {
        await connection.rollback();
        return res.status(422).json({
          success: false,
          message: `Gagal mengurangi stok bahan ${item.nama_bahan}`
        });
      }

      const [updatedRows] = await connection.execute(
        `
        SELECT stok, satuan
        FROM bahan_baku
        WHERE id = ?
        `,
        [item.bahan_id]
      );

      bahanTerpakai.push({
        bahan_baku_id: item.bahan_id,
        nama_bahan: item.nama_bahan,
        jumlah_dikurangi: kebutuhan,
        satuan: updatedRows[0]?.satuan || item.satuan,
        sisa_stok: Number(updatedRows[0]?.stok || 0)
      });
    }

    await connection.execute(
      `
      INSERT INTO dashboard_activities
      (jenis_aktivitas, deskripsi, icon, waktu)
      VALUES
      (?, ?, ?, NOW())
      `,
      [
        'Pengambilan Bahan Berdasarkan Resep',
        `🍞 Bakery mengambil bahan berdasarkan resep "${resepRows[0].nama_resep}" (${qty}x produksi)`,
        '📦'
      ]
    );

    for (const item of bahanTerpakai) {
      await connection.execute(
        `
        INSERT INTO dashboard_activities
        (jenis_aktivitas, deskripsi, icon, waktu)
        VALUES
        (?, ?, ?, NOW())
        `,
        [
          'Pengambilan Bahan Berdasarkan Resep',
          `📦 ${item.nama_bahan} dikurangi ${item.jumlah_dikurangi} ${item.satuan}`,
          '📦'
        ]
      );
    }

    await connection.commit();

    res.json({
      success: true,
      message: "Pengambilan bahan baku berdasarkan resep berhasil diproses",
      data: {
        resep_id: Number(resep_id),
        nama_resep: resepRows[0].nama_resep,
        jumlah_produksi: qty,
        bahan_terpakai: bahanTerpakai
      }
    });

  } catch (error) {
    await connection.rollback();

    console.log("ERROR KONFIRMASI PENGAMBILAN RESEP:", error);

    res.status(500).json({
      success: false,
      message: error.message || "Gagal memproses pengambilan bahan berdasarkan resep"
    });

  } finally {
    connection.release();
  }
};

// ========================
// PENGAMBILAN BAHAN MANUAL
// ========================
exports.pengambilanBahanManual = async (req, res) => {
  const connection = await db.getConnection();

  try {
    const { items } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(422).json({
        success: false,
        message: "Items tidak valid atau kosong"
      });
    }

    await connection.beginTransaction();

    // Validasi dan kurangi stok untuk setiap item
    for (const item of items) {
      const { bahan_baku_id, qty } = item;

      if (!bahan_baku_id || !qty || qty <= 0) {
        return res.status(422).json({
          success: false,
          message: "Data item tidak valid"
        });
      }

      // Cek stok bahan
      const [bahanRows] = await connection.execute(
        `
        SELECT
          id,
          nama_bahan,
          stok,
          satuan
        FROM bahan_baku
        WHERE id = ?
        AND deleted_at IS NULL
        `,
        [bahan_baku_id]
      );

      if (bahanRows.length === 0) {
        throw new Error(`Bahan baku dengan ID ${bahan_baku_id} tidak ditemukan`);
      }

      const bahan = bahanRows[0];

      if (bahan.stok < qty) {
        throw new Error(`Stok bahan ${bahan.nama_bahan} tidak cukup. Sisa: ${bahan.stok}, Diminta: ${qty}`);
      }

      // Kurangi stok
      const [updateResult] = await connection.execute(
        `
        UPDATE bahan_baku
        SET stok = stok - ?
        WHERE id = ?
        AND stok >= ?
        `,
        [qty, bahan_baku_id, qty]
      );

      if (updateResult.affectedRows === 0) {
        throw new Error(`Gagal mengurangi stok bahan ${bahan.nama_bahan}`);
      }

      // Insert log activity
      await connection.execute(
        `
        INSERT INTO dashboard_activities
        (jenis_aktivitas, deskripsi, icon, waktu)
        VALUES
        (?, ?, ?, NOW())
        `,
        [
          'Pengambilan Bahan Manual',
          `📦 Bakery mengambil ${bahan.nama_bahan} sebanyak ${qty} ${bahan.satuan}.`,
          '📦'
        ]
      );
    }

    await connection.commit();

    res.json({
      success: true,
      message: "Pengambilan bahan manual berhasil",
    });

  } catch (error) {
    await connection.rollback();

    console.log("ERROR PENGAMBILAN MANUAL:", error);

    res.status(500).json({
      success: false,
      message: error.message || "Gagal melakukan pengambilan bahan manual",
    });

  } finally {
    connection.release();
  }
};