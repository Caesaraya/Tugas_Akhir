const mysql = require("mysql2/promise");

const db = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "Arfa0109!",
  database: "bakery_pos",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = db;