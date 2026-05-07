const db = require("../config/db");

// ========================
// GET ALL PEMBELIAN
// ========================
exports.getAllPembelian = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        pb.id,
        pb.tanggal,
        pb.total,
        s.nama_supplier
      FROM pembelian_bahan pb
      JOIN supplier s
      ON pb.supplier_id = s.id
      ORDER BY pb.id DESC
    `);

    res.json(rows);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Failed get pembelian" });
  }
};

// ========================
// GET DETAIL PEMBELIAN
// ========================
exports.getDetailPembelian = async (req, res) => {
  try {
    const [rows] = await db.query(
      `
      SELECT
        pb.id,
        pb.tanggal,
        pb.total,
        s.nama_supplier,
        s.no_hp,
        s.alamat
      FROM pembelian_bahan pb
      JOIN supplier s
      ON pb.supplier_id = s.id
      WHERE pb.id = ?
      `,
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ message: "Data not found" });
    }

    res.json(rows[0]);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Failed get detail" });
  }
};

// ========================
// CREATE PEMBELIAN
// ========================
exports.createPembelian = async (req, res) => {
  try {
    const { supplier_id, total } = req.body;

    const [result] = await db.query(
      `
      INSERT INTO pembelian_bahan
      (supplier_id, tanggal, total)
      VALUES (?, NOW(), ?)
      `,
      [supplier_id, total]
    );

    res.json({
      message: "Pembelian created",
      id: result.insertId,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Failed create pembelian" });
  }
};

// ========================
// DELETE PEMBELIAN
// ========================
exports.deletePembelian = async (req, res) => {
  try {
    await db.query(
      `
      DELETE FROM pembelian_bahan
      WHERE id = ?
      `,
      [req.params.id]
    );

    res.json({ message: "Pembelian deleted" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Failed delete pembelian" });
  }
};