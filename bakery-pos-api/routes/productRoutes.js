const express = require("express");
const router = express.Router();
const multer = require("multer");
const path = require("path");
const fs = require("fs");

const productController = require("../controllers/productController");

const uploadDir = path.join(__dirname, "..", "uploads");

if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

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

router.get("/", productController.getProducts);
router.get("/:id", productController.getProductById);

router.post(
  "/",
  upload.single("image"),
  productController.createProduct
);

router.put(
  "/:id",
  upload.single("image"),
  productController.updateProduct
);

router.delete("/:id", productController.deleteProduct);

module.exports = router;