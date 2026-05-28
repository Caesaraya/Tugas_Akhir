const express = require("express");
const cors = require("cors");
const cron = require("node-cron");

const db = require("./config/db");

const app = express();

// ======================
// MIDDLEWARE
// ======================
app.use(cors());
app.use(express.json());

// ======================
// STATIC FILES
// ======================
app.use("/images", express.static("public/images"));
app.use("/uploads", express.static("uploads"));

// ======================
// ROUTES
// ======================
const productRoutes = require("./routes/productRoutes");
const transactionRoutes = require("./routes/transactionRoutes");
const bahanBakuRoutes = require("./routes/bahanBakuRoutes");
const resepRoutes = require("./routes/resepRoutes");
const produksiRoutes = require("./routes/produksiRoutes");
const supplierRoutes = require("./routes/supplierRoutes");
const diskonRoutes = require("./routes/diskonRoutes");
const userRoutes = require("./routes/userRoutes");

app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/bahan-baku", bahanBakuRoutes);
app.use("/api/resep", resepRoutes);
app.use("/api/produksi", produksiRoutes);
app.use("/api/supplier", supplierRoutes);
app.use("/api/diskon", diskonRoutes);
app.use("/api/users", userRoutes);

// ======================
// AUTO CLEANUP SOFT DELETE
// ======================
cron.schedule("0 0 * * *", async () => {
  try {
    console.log("Running auto cleanup deleted products...");

    const [result] = await db.query(`
      DELETE FROM products
      WHERE deleted_at IS NOT NULL
      AND deleted_at < NOW() - INTERVAL 14 DAY
    `);

    console.log(
      `Auto cleanup success. Deleted ${result.affectedRows} products`
    );
  } catch (error) {
    console.error("Auto cleanup failed:", error.message);
  }
});

// ======================
// HEALTH CHECK
// ======================
app.get("/", (req, res) => {
  res.json({ message: "API is running 🚀" });
});

// ======================
// HANDLE 404
// ======================
app.use((req, res) => {
  res.status(404).json({ message: "Route not found" });
});

// ======================
// RUN SERVER
// ======================
const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});