const express = require("express");
const router = express.Router();

const transactionController = require("../controllers/transactionController");

// 🔥 PASTIKAN INI FUNCTION SEMUA
router.get("/", transactionController.getTransactions);
router.get("/:id", transactionController.getTransactionDetail);
router.post("/", transactionController.createTransaction);

module.exports = router;