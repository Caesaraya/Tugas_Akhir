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
// SOFT DELETE
// ========================
router.patch(
  "/:id/delete",
  bahanBakuController.deleteBahanBaku
);

// ========================
// RESTORE
// ========================
router.patch(
  "/:id/restore",
  bahanBakuController.restoreBahanBaku
);

// ========================
// FORCE DELETE
// ========================
router.delete(
  "/:id/force",
  bahanBakuController.forceDeleteBahanBaku
);

module.exports = router;