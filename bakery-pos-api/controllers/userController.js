const db = require("../config/db");

// ========================
// LOGIN
// ========================
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const [rows] = await db.execute(
      "SELECT id, name, email, role FROM users WHERE email = ? AND password = ?",
      [email, password]
    );

    if (rows.length === 0) {
      return res.status(401).json({
        success: false,
        message: "Email atau password salah",
      });
    }

    res.json({
      success: true,
      message: "Login berhasil",
      user: rows[0],
    });
  } catch (error) {
    console.error("ERROR LOGIN:", error.message);

    res.status(500).json({
      success: false,
      message: "Gagal login",
      error_detail: error.message,
    });
  }
};

// ========================
// GET ALL USERS
// ========================
exports.getAllUsers = async (req, res) => {
  try {
    const [rows] = await db.execute(
      "SELECT id, name, email, role FROM users ORDER BY id DESC"
    );

    res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error("ERROR GET USERS:", error.message);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil data user",
      error_detail: error.message,
    });
  }
};

// ========================
// GET USER BY ID
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
    console.error("ERROR GET USER:", error.message);

    res.status(500).json({
      success: false,
      message: "Gagal mengambil user",
      error_detail: error.message,
    });
  }
};

// ========================
// CREATE USER
// ========================
exports.createUser = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;

    // cek email
    const [checkEmail] = await db.execute(
      "SELECT * FROM users WHERE email = ?",
      [email]
    );

    if (checkEmail.length > 0) {
      return res.status(400).json({
        success: false,
        message: "Email sudah digunakan",
      });
    }

    await db.execute(
      "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)",
      [name, email, password, role]
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
      error_detail: error.message,
    });
  }
};

// ========================
// UPDATE USER
// ========================
exports.updateUser = async (req, res) => {
  try {
    const { id } = req.params;

    const { name, email, role, password } = req.body;

    // kalau password diisi
    if (password && password !== "") {
      await db.execute(
        "UPDATE users SET name = ?, email = ?, role = ?, password = ? WHERE id = ?",
        [name, email, role, password, id]
      );
    } else {
      await db.execute(
        "UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?",
        [name, email, role, id]
      );
    }

    res.json({
      success: true,
      message: "User berhasil diperbarui",
    });
  } catch (error) {
    console.error("ERROR UPDATE USER:", error.message);

    res.status(500).json({
      success: false,
      message: "Gagal update user",
      error_detail: error.message,
    });
  }
};

// ========================
// DELETE USER
// ========================
exports.deleteUser = async (req, res) => {
  try {
    const { id } = req.params;

    await db.execute(
      "DELETE FROM users WHERE id = ?",
      [id]
    );

    res.json({
      success: true,
      message: "User berhasil dihapus",
    });
  } catch (error) {
    console.error("ERROR DELETE USER:", error.message);

    res.status(500).json({
      success: false,
      message: "Gagal menghapus user",
      error_detail: error.message,
    });
  }
};