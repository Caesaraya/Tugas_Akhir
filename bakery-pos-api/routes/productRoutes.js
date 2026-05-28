const express = require("express");
const router = express.Router();
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const productController = require("../controllers/productController");

// ========================
// UPLOAD DIRECTORY
// ========================
const uploadDir = path.join(__dirname, "..", "uploads");

if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// ========================
// MULTER STORAGE
// ========================
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir);
  },

  filename: function (req, file, cb) {
    const uniqueSuffix =
      Date.now() + "-" + Math.round(Math.random() * 1e9);

    cb(
      null,
      "image-" + uniqueSuffix + path.extname(file.originalname)
    );
  },
});

const upload = multer({ storage });

// ========================
// GET ALL PRODUCTS
// ========================
router.get("/", productController.getProducts);

// ========================
// CREATE PRODUCT
// ========================
router.post(
  "/",
  upload.single("image"),
  productController.createProduct
);

// ========================
// UPDATE PRODUCT
// ========================
router.put(
  "/:id",
  upload.single("image"),
  productController.updateProduct
);

// ========================
// SOFT DELETE PRODUCT
// ========================
router.patch(
  "/:id/delete",
  productController.deleteProduct
);

// ========================
// RESTORE PRODUCT
// ========================
router.patch(
  "/:id/restore",
  productController.restoreProduct
);

// ========================
// FORCE DELETE PRODUCT
// ========================
router.delete(
  "/:id/force",
  productController.forceDeleteProduct
);

// ========================
// GET PRODUCT BY ID
// HARUS PALING BAWAH
// ========================
router.get("/:id", productController.getProductById);

module.exports = router;
router.get("/:id/force", (req, res) => {
  res.json({
    message: "FORCE ROUTE WORKING",
  });
});