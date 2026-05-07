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
// DELETE
// ========================
router.delete(
  "/:id",
  resepController.deleteResep
);

module.exports = router;