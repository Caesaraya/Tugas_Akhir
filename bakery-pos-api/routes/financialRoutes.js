const express = require("express");
const router = express.Router();

const financialController = require("../controllers/financialController");

// ========================
// FINANCIAL REPORTS ROUTES
// ========================
router.get("/", financialController.getAllFinancialReports);
router.get("/summary", financialController.getFinancialSummary);
router.get("/:tahun/:bulan", financialController.getFinancialReportByMonth);
router.post("/generate", financialController.generateFinancialReport);
router.delete("/:tahun/:bulan", financialController.deleteFinancialReport);

module.exports = router;
