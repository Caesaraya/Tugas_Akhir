const express = require("express");
const router = express.Router();

const stockAdjustmentRequestController = require("../controllers/stockAdjustmentRequestController");

// ========================
// STOCK ADJUSTMENT REQUEST ROUTES
// ========================

// Create stock adjustment request (Kasir)
router.post("/", stockAdjustmentRequestController.createStockAdjustmentRequest);

// Get stock adjustment requests by user (Kasir)
router.get("/", stockAdjustmentRequestController.getStockAdjustmentRequests);

// Get all stock adjustment requests (Admin)
router.get("/all", stockAdjustmentRequestController.getAllStockAdjustmentRequests);

// Approve stock adjustment request (Admin)
router.put("/:id/approve", stockAdjustmentRequestController.approveStockAdjustmentRequest);

// Reject stock adjustment request (Admin)
router.put("/:id/reject", stockAdjustmentRequestController.rejectStockAdjustmentRequest);

module.exports = router;
