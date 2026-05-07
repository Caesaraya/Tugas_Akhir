const db = require("../config/db");

// ========================
// GET ALL SUPPLIER
// ========================
exports.getSuppliers = async (req, res) => {
  try {

    const [rows] = await db.query(`
      SELECT *
      FROM supplier
      ORDER BY id DESC
    `);

    res.json(rows);

  } catch (error) {

    console.log(error);

    res.status(500).json({
      message: "Failed get supplier",
    });
  }
};

// ========================
// GET SINGLE SUPPLIER
// ========================
exports.getSupplierById = async (req, res) => {
  try {

    const [rows] = await db.query(
      `
      SELECT *
      FROM supplier
      WHERE id = ?
      `,
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: "Supplier not found",
      });
    }

    res.json(rows[0]);

  } catch (error) {

    console.log(error);

    res.status(500).json({
      message: "Failed get supplier",
    });
  }
};

// ========================
// CREATE SUPPLIER
// ========================
exports.createSupplier = async (req, res) => {
  try {

    const {
      nama_supplier,
      no_hp,
      alamat,
    } = req.body;

    const [result] = await db.query(
      `
      INSERT INTO supplier
      (nama_supplier, no_hp, alamat)
      VALUES (?, ?, ?)
      `,
      [
        nama_supplier,
        no_hp,
        alamat,
      ]
    );

    res.json({
      message: "Supplier created",
      id: result.insertId,
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      message: "Failed create supplier",
    });
  }
};

// ========================
// UPDATE SUPPLIER
// ========================
exports.updateSupplier = async (req, res) => {
  try {

    const {
      nama_supplier,
      no_hp,
      alamat,
    } = req.body;

    await db.query(
      `
      UPDATE supplier
      SET
        nama_supplier = ?,
        no_hp = ?,
        alamat = ?
      WHERE id = ?
      `,
      [
        nama_supplier,
        no_hp,
        alamat,
        req.params.id,
      ]
    );

    res.json({
      message: "Supplier updated",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      message: "Failed update supplier",
    });
  }
};

// ========================
// DELETE SUPPLIER
// ========================
exports.deleteSupplier = async (req, res) => {
  try {

    await db.query(
      `
      DELETE FROM supplier
      WHERE id = ?
      `,
      [req.params.id]
    );

    res.json({
      message: "Supplier deleted",
    });

  } catch (error) {

    console.log(error);

    res.status(500).json({
      message: "Failed delete supplier",
    });
  }
};