const db = require("../config/db");

// ========================
// CREATE STOCK ADJUSTMENT REQUEST
// ========================
exports.createStockAdjustmentRequest = async (req, res) => {
  try {
    const { product_id, new_stock, reason } = req.body;
    const user_id = req.user?.id || 1; // Default to 1 if no auth

    if (!product_id || !new_stock) {
      return res.status(400).json({
        success: false,
        message: "Product ID dan new_stock harus diisi",
      });
    }

    // Get current stock
    const [product] = await db.query(
      "SELECT id, name, stock FROM products WHERE id = ?",
      [product_id]
    );

    if (product.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Product tidak ditemukan",
      });
    }

    const old_stock = product[0].stock;

    // Check if new_stock is same as old_stock
    if (old_stock === parseInt(new_stock)) {
      return res.status(400).json({
        success: false,
        message: "Stock baru sama dengan stock saat ini",
      });
    }

    // Create stock adjustment request
    const [result] = await db.query(
      `
      INSERT INTO stock_adjustment_requests
      (product_id, user_id, old_stock, new_stock, reason, status)
      VALUES (?, ?, ?, ?, ?, 'pending')
      `,
      [product_id, user_id, old_stock, new_stock, reason]
    );

    // Activity log
    await db.query(
      `
      INSERT INTO dashboard_activities (jenis_aktivitas, deskripsi, icon, waktu)
      VALUES ('stock_adjustment', ?, 'alert', NOW())
      `,
      [`Request stock adjustment: ${product[0].name} dari ${old_stock} ke ${new_stock}`]
    );

    res.status(201).json({
      success: true,
      message: "Request stock adjustment berhasil dibuat",
      data: {
        id: result.insertId,
        product_id,
        product_name: product[0].name,
        old_stock,
        new_stock,
        reason,
        status: "pending",
      },
    });
  } catch (error) {
    console.error("ERROR CREATE STOCK ADJUSTMENT REQUEST:", error);
    res.status(500).json({
      success: false,
      message: "Gagal membuat request stock adjustment",
      error: error.message,
    });
  }
};

// ========================
// GET STOCK ADJUSTMENT REQUESTS (BY USER)
// ========================
exports.getStockAdjustmentRequests = async (req, res) => {
  try {
    const user_id = req.user?.id || 1; // Default filtering by user

    const [rows] = await db.query(
      `
      SELECT
        sar.id,
        sar.product_id,
        p.name as product_name,
        sar.user_id,
        u.name as user_name,
        sar.old_stock,
        sar.new_stock,
        sar.reason,
        sar.status,
        sar.approved_by,
        au.name as approved_by_name,
        sar.created_at,
        sar.updated_at
      FROM stock_adjustment_requests sar
      JOIN products p ON sar.product_id = p.id
      JOIN users u ON sar.user_id = u.id
      LEFT JOIN users au ON sar.approved_by = au.id
      WHERE sar.user_id = ?
      ORDER BY sar.created_at DESC
      `,
      [user_id]
    );

    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error("ERROR GET STOCK ADJUSTMENT REQUESTS:", error);
    res.status(500).json({
      success: false,
      message: "Gagal mengambil request stock adjustment",
      error: error.message,
    });
  }
};

// ========================
// GET ALL STOCK ADJUSTMENT REQUESTS (ADMIN)
// ========================
exports.getAllStockAdjustmentRequests = async (req, res) => {
  try {
    const { status } = req.query;
    let query = `
      SELECT
        sar.id,
        sar.product_id,
        p.name as product_name,
        sar.user_id,
        u.name as user_name,
        sar.old_stock,
        sar.new_stock,
        sar.reason,
        sar.status,
        sar.approved_by,
        au.name as approved_by_name,
        sar.created_at,
        sar.updated_at
      FROM stock_adjustment_requests sar
      JOIN products p ON sar.product_id = p.id
      JOIN users u ON sar.user_id = u.id
      LEFT JOIN users au ON sar.approved_by = au.id
    `;
    const params = [];

    if (status) {
      query += " WHERE sar.status = ?";
      params.push(status);
    }

    query += " ORDER BY sar.created_at DESC";

    const [rows] = await db.query(query, params);

    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error("ERROR GET ALL STOCK ADJUSTMENT REQUESTS:", error);
    res.status(500).json({
      success: false,
      message: "Gagal mengambil semua request stock adjustment",
      error: error.message,
    });
  }
};

// ========================
// APPROVE STOCK ADJUSTMENT REQUEST
// ========================
exports.approveStockAdjustmentRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const admin_id = req.user?.id || 1; // Default admin

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
      // Get request details
      const [request] = await connection.query(
        "SELECT * FROM stock_adjustment_requests WHERE id = ? AND status = 'pending'",
        [id]
      );

      if (request.length === 0) {
        await connection.rollback();
        return res.status(404).json({
          success: false,
          message: "Request tidak ditemukan atau sudah diproses",
        });
      }

      const reqData = request[0];

      // Update product stock
      await connection.query(
        "UPDATE products SET stock = ? WHERE id = ?",
        [reqData.new_stock, reqData.product_id]
      );

      // Update request status
      await connection.query(
        "UPDATE stock_adjustment_requests SET status = 'approved', approved_by = ? WHERE id = ?",
        [admin_id, id]
      );

      // Activity log
      await connection.query(
        `
        INSERT INTO dashboard_activities (jenis_aktivitas, deskripsi, icon, waktu)
        VALUES ('stock_adjustment', ?, 'check', NOW())
        `,
        [`Approved stock adjustment: Product ID ${reqData.product_id} dari ${reqData.old_stock} ke ${reqData.new_stock}`]
      );

      await connection.commit();

      res.json({
        success: true,
        message: "Request stock adjustment berhasil diapprove",
        data: {
          id: reqData.id,
          product_id: reqData.product_id,
          old_stock: reqData.old_stock,
          new_stock: reqData.new_stock,
          status: "approved",
        },
      });
    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }
  } catch (error) {
    console.error("ERROR APPROVE STOCK ADJUSTMENT REQUEST:", error);
    res.status(500).json({
      success: false,
      message: "Gagal approve request stock adjustment",
      error: error.message,
    });
  }
};

// ========================
// REJECT STOCK ADJUSTMENT REQUEST
// ========================
exports.rejectStockAdjustmentRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const admin_id = req.user?.id || 1; // Default admin

    const [request] = await db.query(
      "SELECT * FROM stock_adjustment_requests WHERE id = ? AND status = 'pending'",
      [id]
    );

    if (request.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Request tidak ditemukan atau sudah diproses",
      });
    }

    const reqData = request[0];

    // Update request status
    await db.query(
      "UPDATE stock_adjustment_requests SET status = 'rejected', approved_by = ? WHERE id = ?",
      [admin_id, id]
    );

    // Activity log
    await db.query(
      `
      INSERT INTO dashboard_activities (jenis_aktivitas, deskripsi, icon, waktu)
      VALUES ('stock_adjustment', ?, 'x', NOW())
      `,
      [`Rejected stock adjustment: Product ID ${reqData.product_id} dari ${reqData.old_stock} ke ${reqData.new_stock}`]
    );

    res.json({
      success: true,
      message: "Request stock adjustment berhasil direject",
      data: {
        id: reqData.id,
        product_id: reqData.product_id,
        old_stock: reqData.old_stock,
        new_stock: reqData.new_stock,
        status: "rejected",
      },
    });
  } catch (error) {
    console.error("ERROR REJECT STOCK ADJUSTMENT REQUEST:", error);
    res.status(500).json({
      success: false,
      message: "Gagal reject request stock adjustment",
      error: error.message,
    });
  }
};
