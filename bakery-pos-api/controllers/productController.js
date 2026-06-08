const db = require("../config/db");
const fs = require("fs");
const path = require("path");

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
// CHECK DEFAULT IMAGE
// ========================
function isDefaultImage(imageName) {
  const defaultImages = [
    "cake.jpg",
    "bread.jpg",
    "pasta.jpg",
    "kue_kering.jpg",
    "konsinyasi.jpg",
    "minuman.jpg",
    "tart.jpg",
    "pastry.jpg",
    "basahan.jpg",
    "hantaran.jpg",
    "packaging.jpg",
    "putus.jpg",
    "grosir.jpg",
    "default.jpg",
  ];

  return defaultImages.includes(imageName);
}

// ========================
// BUILD IMAGE URL
// ========================
function buildImageUrl(product) {
  const baseUrl = "https://porthole-popcorn-winter.ngrok-free.dev";

  if (!product.image) {
    return `${baseUrl}/images/${getImageByJenis(product.jenis)}`;
  }

  if (isDefaultImage(product.image)) {
    return `${baseUrl}/images/${product.image}`;
  }

  return `${baseUrl}/uploads/${product.image}`;
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
        (price - (price * discount / 100)) AS price_after_discount,
        stock,
        jenis,
        satuan,

        image,
        resep_id,
        deleted_at
      FROM products
      ORDER BY (deleted_at IS NOT NULL) ASC, id DESC
    `);

    const products = rows.map((product) => ({
      ...product,
      price_after_discount: Math.round(
        product.price_after_discount
      ),
      image: buildImageUrl(product),
    }));

    res.json(products);
  } catch (error) {
    console.error(error);

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
        (price - (price * discount / 100)) AS price_after_discount,
        stock,
        jenis,
        satuan,

        image,
        resep_id,
        deleted_at
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
      price_after_discount: Math.round(
        rows[0].price_after_discount
      ),
      image: buildImageUrl(rows[0]),
    };

    res.json(product);
  } catch (error) {
    console.error(error);

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
    let {
      name,
      price,
      discount,
      stock,
      jenis,
      satuan,

      resep_id,
    } = req.body;

    price = parseInt(price);
    discount = parseInt(discount || 0);
    stock = parseInt(stock || 0);
    resep_id = resep_id ? parseInt(resep_id) : null;

    const image = req.file
      ? req.file.filename
      : getImageByJenis(jenis);

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

        image,
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

        image,
        resep_id,
      ]
    );

    res.status(201).json({
      id: result.insertId,
      name,
      price,
      discount,
      stock,
      jenis,
      satuan,

      image,
      resep_id,
      deleted_at: null,
    });
  } catch (error) {
    console.error(error);

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
    let {
      name,
      price,
      discount,
      stock,
      jenis,
      satuan,

      resep_id,
    } = req.body;

    price = parseInt(price);
    discount = parseInt(discount || 0);
    stock = parseInt(stock || 0);
    resep_id = resep_id ? parseInt(resep_id) : null;

    let image;

    if (req.file) {
      image = req.file.filename;
    } else {
      const [existingProduct] = await db.query(
        "SELECT image FROM products WHERE id = ?",
        [req.params.id]
      );

      image =
        existingProduct[0]?.image ||
        getImageByJenis(jenis);
    }

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
        image = ?,
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

        image,
        resep_id,
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
};

// ========================
// SOFT DELETE PRODUCT
// ========================
exports.deleteProduct = async (req, res) => {
  try {
    const [result] = await db.query(
      `
      UPDATE products
      SET deleted_at = NOW()
      WHERE id = ?
      `,
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Product not found",
      });
    }

    res.json({
      message: "Product soft deleted",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Failed to delete product",
      error: error.message,
    });
  }
};

// ========================
// RESTORE PRODUCT
// ========================
exports.restoreProduct = async (req, res) => {
  try {
    const [result] = await db.query(
      `
      UPDATE products
      SET deleted_at = NULL
      WHERE id = ?
      `,
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Product not found",
      });
    }

    res.json({
      message: "Product restored",
    });
  } catch (error) {
    console.error(error);

    res.status(500).json({
      message: "Failed to restore product",
      error: error.message,
    });
  }
};

// ========================
// FORCE DELETE PRODUCT
// ========================
exports.forceDeleteProduct = async (req, res) => {
  try {
    // Get product image before deletion
    const [product] = await db.query(
      "SELECT image FROM products WHERE id = ?",
      [req.params.id]
    );

    if (product.length === 0) {
      return res.status(404).json({
        message: "Product not found",
      });
    }

    const [result] = await db.query(
      "DELETE FROM products WHERE id = ?",
      [req.params.id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: "Product not found",
      });
    }

    // Delete image file if it's not a default image
    const imageName = product[0].image;
    if (imageName && !isDefaultImage(imageName)) {
      const imagePath = path.join(__dirname, "../uploads", imageName);
      if (fs.existsSync(imagePath)) {
        fs.unlinkSync(imagePath);
      }
    }

    res.json({
      message: "Product permanently deleted",
    });
  } catch (error) {
    console.error(error);

    if (error.code === "ER_ROW_IS_REFERENCED_2") {
      return res.status(400).json({
        message:
          "Product tidak bisa dihapus karena sudah dipakai pada transaksi",
      });
    }

    res.status(500).json({
      message: "Failed to force delete product",
      error: error.message,
    });
  }
};
