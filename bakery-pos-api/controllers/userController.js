const db = require("../config/db");

// ========================
// GET ALL USERS
// ========================
exports.getAllUsers = async (req, res) => {
  try {
    // Nama tabel diganti menjadi 'users'
    const [rows] = await db.execute("SELECT id, name, email, role FROM users ORDER BY id DESC");
    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error("ERROR GET ALL USERS:", error.message);
    res.status(500).json({
      success: false,
      message: "Gagal mengambil data user",
      error_detail: error.message
    });
  }
};

// ========================
// GET DETAIL USER
// ========================
exports.getUserById = async (req, res) => {
  try {
    const { id } = req.params;

    const [rows] = await db.execute(
      "SELECT id, name, email, role FROM users WHERE id = ?", 
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: "User tidak ditemukan",
      });
    }

    res.json({
      success: true,
      data: rows[0],
    });
  } catch (error) {
    console.error("ERROR DETAIL USER:", error.message);
    res.status(500).json({
      success: false,
      message: "Gagal mengambil detail user",
      error_detail: error.message
    });
  }
};

// ========================
// CREATE USER
// ========================
exports.createUser = async (req, res) => {
  try {
    const { id, name, email, password, role } = req.body;

    await db.execute(
      "INSERT INTO users (id, name, email, password, role) VALUES (?, ?, ?, ?, ?)",
      [id, name, email, password, role]
    );

    res.json({
      success: true,
      message: "User berhasil dibuat",
    });
  } catch (error) {
    console.error("ERROR CREATE USER:", error.message);
    res.status(500).json({
      success: false,
      message: "Gagal membuat user",
      error_detail: error.message
    });
  }
};

// ========================
// UPDATE USER
// ========================
exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, role } = req.body;

    await db.execute(
      "UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?",
      [name, email, role, id]
    );

    res.json({
      success: true,
      message: "User berhasil diperbarui",
    });
  } catch (error) {
    console.error("ERROR UPDATE USER:", error.message);
    res.status(500).json({
      success: false,
      message: "Gagal update user",
      error_detail: error.message
    });
  }
};

// ========================
// DELETE USER
// ========================
exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    await db.execute("DELETE FROM users WHERE id = ?", [id]);
    res.json({
      success: true,
      message: "User berhasil dihapus",
    });
  } catch (error) {
    console.error("ERROR DELETE USER:", error.message);
    res.status(500).json({
      success: false,
      message: "Gagal menghapus user",
      error_detail: error.message
    });
  }
};