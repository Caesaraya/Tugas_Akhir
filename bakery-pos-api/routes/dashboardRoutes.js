const express = require("express");
const router = express.Router();
const dashboardController = require("../controllers/dashboardController");

// ========================
// DASHBOARD ROUTES
// ========================

// Get dashboard summary
router.get("/summary", dashboardController.getDashboardSummary);

// Get dashboard activities
router.get("/activities", dashboardController.getDashboardActivities);

module.exports = router;
