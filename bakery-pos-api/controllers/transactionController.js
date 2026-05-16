const db = require("../config/db");

// ========================
// BUILD IMAGE URL
// ========================
function buildImageUrl(image) {
  const baseUrl =
    "https://porthole-popcorn-winter.ngrok-free.dev";

  if (!image) return null;

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

  if (defaultImages.includes(image)) {
    return `${baseUrl}/images/${image}`;
  }

  return `${baseUrl}/uploads/${image}`;
}

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
          name,
          jenis,
          satuan,
          image,
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
    product_name,
    product_jenis,
    product_satuan,
    product_image,
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
          product.name,
          product.jenis,
          product.satuan,
          product.image,
          item.qty,
          item.price,
          item.subtotal,
          product.discount || 0,
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
        td.product_name,
        td.product_jenis,
        td.product_satuan,
        td.product_image,
        td.quantity,
        td.price,
        td.subtotal,
        td.discount
      FROM transaction_details td
      WHERE td.transaction_id = ?
      `,
      [id]
    );

    const items = detailRows.map((item) => ({
      ...item,
      image: buildImageUrl(item.product_image),
    }));

    res.json({
      success: true,
      transaction: transactionRows[0],
      items,
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