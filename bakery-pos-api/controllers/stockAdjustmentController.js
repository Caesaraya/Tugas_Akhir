const db = require("../config/db");

// ========================
// CREATE STOCK ADJUSTMENT
// ========================
exports.createStockAdjustment = async (req, res) => {
  const connection = await db.getConnection();
  
  try {
    await connection.beginTransaction();

    const {
      local_id,
      product_id,
      old_stock,
      new_stock,
      difference,
      reason,
      note,
      created_by
    } = req.body;

    // ========================
    // 1. IDEMPOTENCY CHECK
    // ========================
    const [existingAdjustment] = await connection.execute(
      "SELECT id FROM stock_adjustments WHERE local_id = ?",
      [local_id]
    );

    if (existingAdjustment.length > 0) {
      await connection.rollback();
      return res.json({
        success: true,
        message: "Stock adjustment already processed (idempotent)",
        data: {
          id: existingAdjustment[0].id,
          product_id: product_id
        }
      });
    }

    // ========================
    // 2. VALIDATE PRODUCT EXISTS
    // ========================
    const [product] = await connection.execute(
      "SELECT id, name, stock FROM products WHERE id = ?",
      [product_id]
    );

    if (product.length === 0) {
      await connection.rollback();
      return res.status(404).json({
        success: false,
        message: "Product not found"
      });
    }

    // ========================
    // 3. INSERT INTO stock_adjustments
    // ========================
    const [result] = await connection.execute(
      `INSERT INTO stock_adjustments
      (local_id, product_id, old_stock, new_stock, difference, reason, note, created_by)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [local_id, product_id, old_stock, new_stock, difference, reason, note, created_by]
    );

    const adjustmentId = result.insertId;

    // ========================
    // 4. UPDATE products.stock
    // ========================
    await connection.execute(
      "UPDATE products SET stock = ? WHERE id = ?",
      [new_stock, product_id]
    );

    // ========================
    // 5. GET USER NAME FOR ACTIVITY LOG
    // ========================
    const [user] = await connection.execute(
      "SELECT name FROM users WHERE id = ?",
      [created_by]
    );

    const userName = user.length > 0 ? user[0].name : "Unknown";

    // ========================
    // 6. INSERT INTO dashboard_activities
    // ========================
    const activityDescription = `${userName} melakukan penyesuaian stok\n\nProduk: ${product[0].name}\n${old_stock} → ${new_stock}\n\nAlasan: ${reason}${note ? `\nCatatan: ${note}` : ""}`;

    await connection.execute(
      `INSERT INTO dashboard_activities
      (jenis_aktivitas, deskripsi, icon, waktu)
      VALUES (?, ?, ?, NOW())`,
      ["Penyesuaian Stok", activityDescription, "📦"]
    );

    await connection.commit();

    res.json({
      success: true,
      message: "Stock adjustment saved",
      data: {
        id: adjustmentId,
        product_id: product_id
      }
    });

  } catch (error) {
    await connection.rollback();
    console.error("ERROR CREATE STOCK ADJUSTMENT:");
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Failed to save stock adjustment",
      error: error.message
    });
  } finally {
    connection.release();
  }
};

// ========================
// GET ALL STOCK ADJUSTMENTS (OPTIONAL)
// ========================
exports.getStockAdjustments = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT
        sa.*,
        p.name as product_name,
        u.name as user_name
      FROM stock_adjustments sa
      JOIN products p ON sa.product_id = p.id
      JOIN users u ON sa.created_by = u.id
      ORDER BY sa.created_at DESC
    `);

    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error("ERROR GET STOCK ADJUSTMENTS:");
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Failed to get stock adjustments",
      error: error.message
    });
  }
};

// ========================
// GET STOCK ADJUSTMENTS BY PRODUCT ID (OPTIONAL)
// ========================
exports.getStockAdjustmentsByProduct = async (req, res) => {
  try {
    const productId = req.params.id;

    const [rows] = await db.query(`
      SELECT
        sa.*,
        u.name as user_name
      FROM stock_adjustments sa
      JOIN users u ON sa.created_by = u.id
      WHERE sa.product_id = ?
      ORDER BY sa.created_at DESC
    `, [productId]);

    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error("ERROR GET STOCK ADJUSTMENTS BY PRODUCT:");
    console.error(error);

    res.status(500).json({
      success: false,
      message: "Failed to get stock adjustments by product",
      error: error.message
    });
  }
};
