const express = require("express");
const router = express.Router();

const pembelianController = require("../controllers/pembelianController");

// ========================
// ROUTES PEMBELIAN
// ========================

router.get("/", pembelianController.getAllPembelian);

router.get("/:id", pembelianController.getDetailPembelian);

router.post("/", pembelianController.createPembelian);

router.delete("/:id", pembelianController.deletePembelian);

module.exports = router;