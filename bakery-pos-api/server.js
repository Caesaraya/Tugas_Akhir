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
const bakeryRoutes = require("./routes/bakeryRoutes");

app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/bahan-baku", bahanBakuRoutes);
app.use("/api/resep", resepRoutes);
app.use("/api/produksi", produksiRoutes);
app.use("/api/supplier", supplierRoutes);
app.use("/api/diskon", diskonRoutes);
app.use("/api/users", userRoutes);
app.use("/api/bakery", bakeryRoutes);

// ======================
// AUTO CLEANUP SOFT DELETE
// ======================
cron.schedule("0 0 * * *", async () => {
  try {
    console.log("Running auto cleanup deleted records...");

    // Cleanup products (cascade delete from produksi first)
    const [productIds] = await db.query(`
      SELECT id FROM products
      WHERE deleted_at IS NOT NULL
      AND deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
    `);

    if (productIds.length > 0) {
      const ids = productIds.map(p => p.id);
      await db.query(`
        DELETE FROM produksi
        WHERE product_id IN (${ids.join(',')})
      `);
    }

    const [productsResult] = await db.query(`
      DELETE FROM products
      WHERE deleted_at IS NOT NULL
      AND deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
    `);
    console.log(`Auto cleanup: Deleted ${productsResult.affectedRows} products`);

    // Cleanup bahan_baku
    const [bahanBakuResult] = await db.query(`
      DELETE FROM bahan_baku
      WHERE deleted_at IS NOT NULL
      AND deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
    `);
    console.log(`Auto cleanup: Deleted ${bahanBakuResult.affectedRows} bahan_baku`);

    // Cleanup resep (cascade delete detail_resep)
    const [resepIds] = await db.query(`
      SELECT id FROM resep
      WHERE deleted_at IS NOT NULL
      AND deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
    `);

    if (resepIds.length > 0) {
      const ids = resepIds.map(r => r.id);
      await db.query(`
        DELETE FROM detail_resep
        WHERE resep_id IN (${ids.join(',')})
      `);
    }

    const [resepResult] = await db.query(`
      DELETE FROM resep
      WHERE deleted_at IS NOT NULL
      AND deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
    `);
    console.log(`Auto cleanup: Deleted ${resepResult.affectedRows} resep`);

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