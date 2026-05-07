const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

// ======================
// IMAGE FOLDER
// ======================
app.use("/images", express.static("public/images"));

const productRoutes = require("./routes/productRoutes");
const transactionRoutes = require("./routes/transactionRoutes");

app.use("/api/products", productRoutes);
app.use("/api/transactions", transactionRoutes);

app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});