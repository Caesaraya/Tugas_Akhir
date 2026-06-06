const express = require("express");
const router = express.Router();

const bakeryController = require("../controllers/bakeryController");

// ========================
// HITUNG KEBUTUHAN BAHAN
// ========================
router.get(
  "/hitung-kebutuhan",
  bakeryController.hitungKebutuhanBahan
);

// ========================
// CEK KETERSEDIAAN BAHAN
// ========================
router.get(
  "/cek-ketersediaan",
  bakeryController.cekKetersediaanBahan
);

// ========================
// HITUNG BIAYA PRODUKSI
// ========================
router.get(
  "/hitung-biaya",
  bakeryController.hitungBiayaProduksi
);

// ========================
// PRODUK YANG BISA DIPRODUKSI
// ========================
router.get(
  "/produksi-possible",
  bakeryController.getProduksiPossible
);

module.exports = router;