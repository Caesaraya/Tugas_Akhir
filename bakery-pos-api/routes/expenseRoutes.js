const express = require("express");
const router = express.Router();
const expenseController = require("../controllers/expenseController");

// ========================
// EXPENSE CATEGORIES ROUTES
// ========================

// Get all expense categories
router.get("/categories", expenseController.getAllExpenseCategories);

// Get expense category by id
router.get("/categories/:id", expenseController.getExpenseCategoryById);

// Create expense category
router.post("/categories", expenseController.createExpenseCategory);

// Update expense category
router.put("/categories/:id", expenseController.updateExpenseCategory);

// Delete expense category
router.delete("/categories/:id", expenseController.deleteExpenseCategory);

// ========================
// EXPENSES ROUTES
// ========================

// Get all expenses (with optional filters)
router.get("/", expenseController.getAllExpenses);

// Get expense by id
router.get("/:id", expenseController.getExpenseById);

// Create expense
router.post("/", expenseController.createExpense);

// Update expense
router.put("/:id", expenseController.updateExpense);

// Delete expense
router.delete("/:id", expenseController.deleteExpense);

// Get expense summary by month
router.get("/summary/:tahun/:bulan", expenseController.getExpenseSummaryByMonth);

module.exports = router;
