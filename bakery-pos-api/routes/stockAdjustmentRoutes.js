const express = require("express");
const router = express.Router();
const stockAdjustmentController = require("../controllers/stockAdjustmentController");

// ========================
// CREATE STOCK ADJUSTMENT
// ========================
router.post("/", stockAdjustmentController.createStockAdjustment);

// ========================
// GET ALL STOCK ADJUSTMENTS (OPTIONAL)
// ========================
router.get("/", stockAdjustmentController.getStockAdjustments);

// ========================
// GET STOCK ADJUSTMENTS BY PRODUCT ID (OPTIONAL)
// ========================
router.get("/product/:id", stockAdjustmentController.getStockAdjustmentsByProduct);

module.exports = router;
