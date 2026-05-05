const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors()); // 🔥 penting
app.use(express.json());

// routes
const productRoutes = require("./routes/productRoutes");
const transactionRoutes = require("./routes/transactionRoutes");

app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);

app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});