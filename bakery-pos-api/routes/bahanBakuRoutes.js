const express = require("express");
const router = express.Router();

const bahanBakuController = require(
  "../controllers/bahanBakuController"
);

// ========================
// GET ALL
// ========================
router.get(
  "/",
  bahanBakuController.getAllBahanBaku
);

// ========================
// GET DETAIL
// ========================
router.get(
  "/:id",
  bahanBakuController.getBahanBakuById
);

// ========================
// CREATE
// ========================
router.post(
  "/",
  bahanBakuController.createBahanBaku
);

// ========================
// UPDATE
// ========================
router.put(
  "/:id",
  bahanBakuController.updateBahanBaku
);

// ========================
// DELETE
// ========================
router.delete(
  "/:id",
  bahanBakuController.deleteBahanBaku
);

module.exports = router;