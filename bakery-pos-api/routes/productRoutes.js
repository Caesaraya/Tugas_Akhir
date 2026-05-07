const express = require("express");
const router = express.Router();
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
router.get("/", async (req, res) => {
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
        barcode
      FROM products
      ORDER BY id DESC
    `);

    const products = rows.map((product) => ({
      ...product,
      image: `https://oafishly-noncontagious-cali.ngrok-free.dev/images/${getImageByJenis(product.jenis)}`
    }));

    res.json(products);

  } catch (error) {

    console.error(error);

    res.status(500).json({
      message: "Failed to load products",
      error: error.message,
    });
  }
});

// ========================
// GET SINGLE PRODUCT
// ========================
router.get("/:id", async (req, res) => {
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
        barcode
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
      image: `http://192.168.1.8:3000/images/${getImageByJenis(rows[0].jenis)}`
    };

    res.json(product);

  } catch (error) {

    console.error(error);

    res.status(500).json({
      message: "Failed to load product",
      error: error.message,
    });
  }
});

// ========================
// CREATE PRODUCT
// ========================
router.post("/", async (req, res) => {
  try {

    const {
      name,
      price,
      discount = 0,
      stock,
      jenis,
      satuan,
      barcode,
    } = req.body;

    const [result] = await db.query(
      `
      INSERT INTO products
      (name, price, discount, stock, jenis, satuan, barcode)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      `,
      [
        name,
        price,
        discount,
        stock,
        jenis,
        satuan,
        barcode,
      ]
    );

    res.json({
      message: "Product added",
      id: result.insertId,
    });

  } catch (error) {

    console.error(error);

    res.status(500).json({
      message: "Failed to create product",
      error: error.message,
    });
  }
});

// ========================
// UPDATE PRODUCT
// ========================
router.put("/:id", async (req, res) => {
  try {

    const {
      name,
      price,
      discount = 0,
      stock,
      jenis,
      satuan,
      barcode,
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
        barcode = ?
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
        req.params.id,
      ]
    );

    res.json({
      message: "Product updated",
    });

  } catch (error) {

    console.error(error);

    res.status(500).json({
      message: "Failed to update product",
      error: error.message,
    });
  }
});

// ========================
// DELETE PRODUCT
// ========================
router.delete("/:id", async (req, res) => {
  try {

    await db.query(
      `DELETE FROM products WHERE id = ?`,
      [req.params.id]
    );

    res.json({
      message: "Product deleted",
    });

  } catch (error) {

    console.error(error);

    res.status(500).json({
      message: "Failed to delete product",
      error: error.message,
    });
  }
});

module.exports = router;