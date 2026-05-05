const express = require("express");
const router = express.Router();
const db = require("../config/db");

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
        barcode,
        image
      FROM products
      ORDER BY id DESC
    `);

    res.json(rows);
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
        barcode,
        image
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

    res.json(rows[0]);
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
      image,
    } = req.body;

    const [result] = await db.query(
      `
      INSERT INTO products
      (name, price, discount, stock, jenis, satuan, barcode, image)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [name, price, discount, stock, jenis, satuan, barcode, image]
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
      image,
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
        image = ?
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
        image,
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