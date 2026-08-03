USE bakery_pos;

-- Tabel untuk menyimpan riwayat penyesuaian stok
CREATE TABLE IF NOT EXISTS stock_adjustments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  local_id VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID dari frontend untuk idempotency',
  product_id INT NOT NULL,
  old_stock INT NOT NULL,
  new_stock INT NOT NULL,
  difference INT NOT NULL,
  reason VARCHAR(50) NOT NULL COMMENT 'Stock Opname / Barang Rusak / Barang Hilang / Koreksi Data',
  note TEXT,
  created_by INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Index untuk mempercepat query berdasarkan local_id
CREATE INDEX idx_local_id ON stock_adjustments(local_id);

-- Index untuk query riwayat penyesuaian per produk
CREATE INDEX idx_product_id ON stock_adjustments(product_id);
