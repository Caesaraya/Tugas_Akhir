const db = require("../config/db");

// ========================
// CREATE TRANSACTION
// ========================
exports.createTransaction = async (req, res) => {
  const connection = await db.getConnection();

  try {
    const {
      total_harga,
      metode_pembayaran,
      jumlah_bayar,
      kembalian,
      items,
    } = req.body;

    if (!items || items.length === 0) {
      return res.status(400).json({
        message: "Item transaksi kosong",
      });
    }

    await connection.beginTransaction();

    const [transactionResult] = await connection.execute(
      `
      INSERT INTO transactions
      (
        tanggal,
        total_harga,
        metode_pembayaran,
        jumlah_bayar,
        kembalian
      )
      VALUES
      (
        NOW(),
        ?,
        ?,
        ?,
        ?
      )
      `,
      [
        total_harga,
        metode_pembayaran,
        jumlah_bayar,
        kembalian,
      ]
    );

    const transactionId = transactionResult.insertId;

    for (const item of items) {
      const [productRows] = await connection.execute(
        `
        SELECT
          id,
          stock,
          discount
        FROM products
        WHERE id = ?
        `,
        [item.product_id]
      );

      if (productRows.length === 0) {
        throw new Error(
          `Produk ID ${item.product_id} tidak ditemukan`
        );
      }

      const product = productRows[0];

      if (product.stock < item.qty) {
        throw new Error(
          `Stok produk ID ${item.product_id} tidak cukup`
        );
      }

      await connection.execute(
        `
        INSERT INTO transaction_details
        (
          transaction_id,
          product_id,
          quantity,
          price,
          subtotal,
          discount
        )
        VALUES
        (
          ?,
          ?,
          ?,
          ?,
          ?,
          ?
        )
        `,
        [
          transactionId,
          item.product_id,
          item.qty,
          item.price,
          item.subtotal,
          item.discount || 0,
        ]
      );

      await connection.execute(
        `
        UPDATE products
        SET stock = stock - ?
        WHERE id = ?
        `,
        [
          item.qty,
          item.product_id,
        ]
      );
    }

    await connection.commit();

    res.json({
      success: true,
      message: "Transaksi berhasil",
      transaction_id: transactionId,
    });

  } catch (error) {
    await connection.rollback();

    console.log("ERROR CREATE TRANSACTION:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: error.message,
    });

  } finally {
    connection.release();
  }
};

// ========================
// GET ALL TRANSACTIONS
// ========================
exports.getTransactions = async (req, res) => {
  try {
    const [rows] = await db.execute(
      `
      SELECT
        id,
        tanggal,
        total_harga,
        metode_pembayaran,
        jumlah_bayar,
        kembalian
      FROM transactions
      ORDER BY tanggal DESC
      `
    );

    res.json(rows);

  } catch (error) {
    console.log("ERROR GET TRANSACTIONS:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Error server",
    });
  }
};

// ========================
// GET TRANSACTION DETAIL
// ========================
exports.getTransactionDetail = async (req, res) => {
  try {
    const { id } = req.params;

    const [transactionRows] = await db.execute(
      `
      SELECT
        id,
        tanggal,
        total_harga,
        metode_pembayaran,
        jumlah_bayar,
        kembalian
      FROM transactions
      WHERE id = ?
      `,
      [id]
    );

    if (transactionRows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Transaksi tidak ditemukan",
      });
    }

    const [detailRows] = await db.execute(
      `
      SELECT
        td.id,
        td.transaction_id,
        td.product_id,
        td.quantity,
        td.price,
        td.subtotal,
        td.discount,

        COALESCE(p.name, 'Produk sudah dihapus') AS name,
        COALESCE(p.jenis, '-') AS jenis,
        COALESCE(p.satuan, '-') AS satuan,
        CASE
          WHEN p.image IS NOT NULL
          THEN CONCAT('https://oafishly-noncontagious-cali.ngrok-free.dev/uploads/', p.image)
          ELSE NULL
        END AS image

      FROM transaction_details td

      LEFT JOIN products p
      ON td.product_id = p.id

      WHERE td.transaction_id = ?
      `,
      [id]
    );

    res.json({
      success: true,
      transaction: transactionRows[0],
      items: detailRows,
    });

  } catch (error) {
    console.log("ERROR GET DETAIL:");
    console.log(error);

    res.status(500).json({
      success: false,
      message: "Error server",
    });
  }
};