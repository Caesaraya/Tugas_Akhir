const db = require("../config/db");

// ========================
// AUTO IMAGE BY JENIS
// ========================
function getImageByJenis(jenis) {
  switch (jenis) {
    case "CAKE":
      return "cake.jpg";

    case "BREAD":
      return "bread.jpg";

    case "PASTA":
      return "pasta.jpg";

    case "KUE KERING":
      return "kue_kering.jpg";

    case "KONSINYASI":
      return "konsinyasi.jpg";

    case "MINUMAN":
      return "minuman.jpg";

    case "TART":
      return "tart.jpg";

    case "PASTRY":
      return "pastry.jpg";

    case "BASAHAN":
      return "basahan.jpg";

    case "HANTARAN":
      return "hantaran.jpg";

    case "PACKAGING":
      return "packaging.jpg";

    case "PUTUS":
      return "putus.jpg";

    case "GROSIR RESILEDO":
      return "grosir.jpg";

    default:
      return "default.jpg";
  }
}

// ========================
// GET ALL PRODUCTS
// ========================
exports.getProducts = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        id,
        name,
        price,
        discount,
        stock,
        jenis,
        satuan,
        barcode,
        resep_id
      FROM products
      ORDER BY id DESC
    `);

    const products = rows.map((product) => ({
      ...product,
      image:
        `https://oafishly-noncontagious-cali.ngrok-free.dev/images/` +
        getImageByJenis(product.jenis),
    }));

    res.json(products);
  } catch (error) {
    console.log(error);

    res.status(500).json({
      message: "Failed to load products",
      error: error.message,
    });
  }
};

// ========================
// GET PRODUCT BY ID
// ========================
exports.getProductById = async (req, res) => {
  try {
    const [rows] = await db.query(
      `
      SELECT
        id,
        name,
        price,
        discount,
        stock,
        jenis,
        satuan,
        barcode,
        resep_id
      FROM products
      WHERE id = ?
      `,
      [req.params.id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        message: "Product not found",
      });
    }

    const product = {
      ...rows[0],
      image:
        `https://oafishly-noncontagious-cali.ngrok-free.dev/images/` +
        getImageByJenis(rows[0].jenis),
    };

    res.json(product);
  } catch (error) {
    console.log(error);

    res.status(500).json({
      message: "Failed to load product",
      error: error.message,
    });
  }
};

// ========================
// CREATE PRODUCT
// ========================
exports.createProduct = async (req, res) => {
  try {
    const {
      name,
      price,
      discount = 0,
      stock,
      jenis,
      satuan,
      barcode,
      resep_id,
    } = req.body;

    const [result] = await db.query(
      `
      INSERT INTO products
      (
        name,
        price,
        discount,
        stock,
        jenis,
        satuan,
        barcode,
        resep_id
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        name,
        price,
        discount,
        stock,
        jenis,
        satuan,
        barcode,
        resep_id,
      ]
    );

    res.json({
      message: "Product created",
      id: result.insertId,
    });
  } catch (error) {
    console.log(error);

    res.status(500).json({
      message: "Failed to create product",
      error: error.message,
    });
  }
};

// ========================
// UPDATE PRODUCT
// ========================
exports.updateProduct = async (req, res) => {
  try {
    const {
      name,
      price,
      discount,
      stock,
      jenis,
      satuan,
      barcode,
      resep_id,
    } = req.body;

    await db.query(
      `
      UPDATE products
      SET
        name = ?,
        price = ?,
        discount = ?,
        stock = ?,
        jenis = ?,
        satuan = ?,
        barcode = ?,
        resep_id = ?
      WHERE id = ?
      `,
      [
        name,
        price,
        discount,
        stock,
        jenis,
        satuan,
        barcode,
        resep_id,
        req.params.id,
      ]
    );

    res.json({
      message: "Product updated",
    });
  } catch (error) {
    console.log(error);

    res.status(500).json({
      message: "Failed to update product",
      error: error.message,
    });
  }
};

// ========================
// DELETE PRODUCT
// ========================
exports.deleteProduct = async (req, res) => {
  try {
    await db.query(
      `DELETE FROM products WHERE id = ?`,
      [req.params.id]
    );

    res.json({
      message: "Product deleted",
    });
  } catch (error) {
    console.log(error);

    res.status(500).json({
      message: "Failed to delete product",
      error: error.message,
    });
  }
};