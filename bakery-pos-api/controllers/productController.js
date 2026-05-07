const db = require("../config/db");

exports.getProducts = async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM products");
    res.json(rows);
  } catch (error) {
    res.status(500).json(error);
  }
};

exports.createProduct = async (req, res) => {
  try {
    const { name, price, discount, stock, category_id, image } = req.body;

    const [result] = await db.query(
      "INSERT INTO products (name, price, discount, stock, category_id, image) VALUES (?, ?, ?, ?, ?, ?)",
      [name, price, discount, stock, category_id, image]
    );

    res.json({
      message: "Product created",
      id: result.insertId
    });

  } catch (error) {
    res.status(500).json(error);
  }
};