const express = require("express");
const router = express.Router();

const resepController = require(
  "../controllers/resepController"
);

// ========================
// GET ALL
// ========================
router.get(
  "/",
  resepController.getAllResep
);

// ========================
// GET DETAIL
// ========================
router.get(
  "/:id",
  resepController.getDetailResep
);

// ========================
// CREATE
// ========================
router.post(
  "/",
  resepController.createResep
);

// ========================
// UPDATE
// ========================
router.put(
  "/:id",
  resepController.updateResep
);

// ========================
// SOFT DELETE
// ========================
router.patch(
  "/:id/delete",
  resepController.deleteResep
);

// ========================
// RESTORE
// ========================
router.patch(
  "/:id/restore",
  resepController.restoreResep
);

// ========================
// FORCE DELETE
// ========================
router.delete(
  "/:id/force",
  resepController.forceDeleteResep
);

module.exports = router;