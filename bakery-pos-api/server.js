const express = require("express");
const cors = require("cors");
const cron = require("node-cron");
const fs = require("fs");
const path = require("path");

const db = require("./config/db");

// ========================
// HELPER: CHECK DEFAULT IMAGE
// ========================
function isDefaultImage(imageName) {
  const defaultImages = [
    "cake.jpg",
    "bread.jpg",
    "pasta.jpg",
    "kue_kering.jpg",
    "konsinyasi.jpg",
    "minuman.jpg",
    "tart.jpg",
    "pastry.jpg",
    "basahan.jpg",
    "hantaran.jpg",
    "packaging.jpg",
    "putus.jpg",
    "grosir.jpg",
    "default.jpg",
  ];
  return defaultImages.includes(imageName);
}

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
const financialRoutes = require("./routes/financialRoutes");
const expenseRoutes = require("./routes/expenseRoutes");
const pembelianRoutes = require("./routes/pembelianRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");
const pengambilanBahanRoutes = require("./routes/pengambilanBahanRoutes");

app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/bahan-baku", bahanBakuRoutes);
app.use("/api/resep", resepRoutes);
app.use("/api/produksi", produksiRoutes);
app.use("/api/supplier", supplierRoutes);
app.use("/api/diskon", diskonRoutes);
app.use("/api/users", userRoutes);
app.use("/api/bakery", bakeryRoutes);
app.use("/api/financial", financialRoutes);
app.use("/api/expenses", expenseRoutes);
app.use("/api/pembelian", pembelianRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/pengambilan-bahan", pengambilanBahanRoutes);

// ======================
// AUTO CLEANUP SOFT DELETE
// ======================
cron.schedule("0 0 * * *", async () => {
  try {
    console.log("Running auto cleanup deleted records...");

    // Cleanup products (cascade delete from produksi first + delete image files)
    const [productsToDelete] = await db.query(`
      SELECT id, image FROM products
      WHERE deleted_at IS NOT NULL
      AND deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
    `);

    if (productsToDelete.length > 0) {
      const ids = productsToDelete.map(p => p.id);

      // Delete from produksi first
      await db.query(`
        DELETE FROM produksi
        WHERE product_id IN (${ids.join(',')})
      `);

      // Delete image files from uploads folder
      const uploadsDir = path.join(__dirname, "uploads");
      productsToDelete.forEach((product) => {
        const imageName = product.image;
        if (imageName && !isDefaultImage(imageName)) {
          const imagePath = path.join(uploadsDir, imageName);
          if (fs.existsSync(imagePath)) {
            try {
              fs.unlinkSync(imagePath);
              console.log(`  Deleted image file: ${imageName}`);
            } catch (err) {
              console.error(`  Failed to delete image ${imageName}:`, err.message);
            }
          }
        }
      });

      // Delete from database
      const [productsResult] = await db.query(`
        DELETE FROM products
        WHERE id IN (${ids.join(',')})
      `);
      console.log(`Auto cleanup: Deleted ${productsResult.affectedRows} products`);
    }

    // Cleanup bahan_baku (cascade delete from detail_resep first)
    const [bahanBakuIds] = await db.query(`
      SELECT id FROM bahan_baku
      WHERE deleted_at IS NOT NULL
      AND deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
    `);

    if (bahanBakuIds.length > 0) {
      const ids = bahanBakuIds.map(b => b.id);

      // Delete from detail_resep first
      await db.query(`
        DELETE FROM detail_resep
        WHERE bahan_id IN (${ids.join(',')})
      `);

      // Delete from database
      const [bahanBakuResult] = await db.query(`
        DELETE FROM bahan_baku
        WHERE id IN (${ids.join(',')})
      `);
      console.log(`Auto cleanup: Deleted ${bahanBakuResult.affectedRows} bahan_baku`);
    }

    // Cleanup resep (check if used by active products first)
    const [resepToDelete] = await db.query(`
      SELECT r.id FROM resep r
      WHERE r.deleted_at IS NOT NULL
      AND r.deleted_at <= DATE_SUB(NOW(), INTERVAL 30 DAY)
      AND NOT EXISTS (
        SELECT 1 FROM products p
        WHERE p.resep_id = r.id
        AND p.deleted_at IS NULL
      )
    `);

    if (resepToDelete.length > 0) {
      const ids = resepToDelete.map(r => r.id);

      // Delete from detail_resep first
      await db.query(`
        DELETE FROM detail_resep
        WHERE resep_id IN (${ids.join(',')})
      `);

      // Delete from database
      const [resepResult] = await db.query(`
        DELETE FROM resep
        WHERE id IN (${ids.join(',')})
      `);
      console.log(`Auto cleanup: Deleted ${resepResult.affectedRows} resep`);
    } else {
      console.log(`Auto cleanup: Skipped resep deletion (some are still used by active products)`);
    }

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