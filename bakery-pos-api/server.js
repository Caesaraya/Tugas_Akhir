const express = require("express");
const cors = require("cors");

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

// API PREFIX
app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);
app.use("/api/bahan-baku", bahanBakuRoutes);
app.use("/api/resep", resepRoutes);
app.use("/api/produksi", produksiRoutes);
app.use("/api/supplier", supplierRoutes);
app.use("/api/diskon", diskonRoutes);
app.use("/api/users", userRoutes);

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