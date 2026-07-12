const express = require("express");
const router = express.Router();

const bahanBakuController = require("../controllers/bahanBakuController");

// ========================
// KONFIRMASI PENGAMBILAN BAHAN BERDASARKAN RESEP
// ========================
router.post(
  "/resep",
  bahanBakuController.konfirmasiPengambilanBahanResep
);

module.exports = router;
