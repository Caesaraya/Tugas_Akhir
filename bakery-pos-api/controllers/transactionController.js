const db = require("../config/db");

// ========================
// CREATE TRANSACTION
// ========================
exports.createTransaction = async (req, res) => {
  try {
    const {
      total_harga,
      metode_pembayaran,
      jumlah_bayar,
      kembalian,
      items
    } = req.body;

    // INSERT TRANSAKSI
    const [result] = await db.execute(
      `INSERT INTO transactions 
      (tanggal, total_harga, metode_pembayaran, jumlah_bayar, kembalian)
      VALUES (NOW(), ?, ?, ?, ?)`,
      [total_harga, metode_pembayaran, jumlah_bayar, kembalian]
    );

    const transactionId = result.insertId;

    // INSERT DETAIL
    for (let item of items) {
      await db.execute(
        `INSERT INTO transaction_details 
        (transaction_id, product_id, quantity, price, subtotal)
        VALUES (?, ?, ?, ?, ?)`,
        [
          transactionId,
          item.product_id,
          item.qty,
          item.price,        // 🔥 WAJIB ADA
          item.subtotal
        ]
      );
    }

    res.json({
      message: "Transaksi berhasil",
      transaction_id: transactionId
    });

  } catch (error) {
    console.log("ERROR:", error);
    res.status(500).json({ message: "Error server" });
  }
};



// ========================
// GET TRANSACTIONS
// ========================
exports.getTransactions = async (req, res) => {
  try {
    const [rows] = await db.execute(
      `SELECT * FROM transactions ORDER BY tanggal DESC`
    );

    res.json(rows);

  } catch (error) {
    res.status(500).json({ message: "Error server" });
  }
};


// ========================
// GET DETAIL TRANSACTION
// ========================
exports.getTransactionDetail = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await db.execute(
      `SELECT 
        td.id,
        td.transaction_id,
        td.product_id,
        td.quantity,
        td.price,
        td.subtotal,
        p.name,
        p.discount
      FROM transaction_details td
      JOIN products p ON td.product_id = p.id
      WHERE td.transaction_id = ?`,
      [id]
    );

    res.json(rows);

  } catch (error) {
    console.log("ERROR DETAIL:", error);
    res.status(500).json({ message: "Error server" });
  }
};