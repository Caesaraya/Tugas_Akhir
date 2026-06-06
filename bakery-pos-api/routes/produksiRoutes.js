const express = require("express");
const router = express.Router();

const produksiController = require(
  "../controllers/produksiController"
);

// ========================
// GET ALL PRODUKSI
// ========================
router.get(
  "/",
  produksiController.getProduksi
);

// ========================
// CREATE PRODUKSI
// ========================
router.post(
  "/",
  produksiController.createProduksi
);

// ========================
// GET PRODUKSI BY ID
// ========================
router.get(
  "/:id",
  produksiController.getProduksiById
);

module.exports = router;