const mysql = require("mysql2/promise");

const db = mysql.createPool({
  host: "localhost",
  user: "bakery_user",
  password: "BakeryPos2024!",
  database: "bakery_pos",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = db;