# PANDUAN PRESENTASI BACKEND BAKERY POS API

## 📋 RINGKASAN ARSITEKTUR BACKEND

### 🏗️ Teknologi yang Digunakan
- **Framework**: Node.js dengan Express.js
- **Database**: MySQL dengan mysql2 (connection pooling)
- **File Upload**: Multer
- **Security**: bcryptjs (password hashing), JWT (authentication)
- **CORS**: Cross-Origin Resource Sharing enabled
- **Static Files**: Express static untuk images dan uploads

### 📁 Struktur Project
```
bakery-pos-api/
├── config/
│   └── db.js              # Koneksi database MySQL
├── controllers/           # Logika bisnis (9 controller)
│   ├── productController.js
│   ├── transactionController.js
│   ├── bahanBakuController.js
│   ├── resepController.js
│   ├── produksiController.js
│   ├── supplierController.js
│   ├── diskonController.js
│   ├── userController.js
│   └── pembelianController.js
├── routes/                 # API endpoints (9 route files)
│   ├── productRoutes.js
│   ├── transactionRoutes.js
│   ├── bahanBakuRoutes.js
│   ├── resepRoutes.js
│   ├── produksiRoutes.js
│   ├── supplierRoutes.js
│   ├── diskonRoutes.js
│   ├── userRoutes.js
│   └── pembelianRoutes.js
├── public/
│   └── images/            # Default images
├── uploads/               # Uploaded product images
├── server.js              # Entry point
└── package.json           # Dependencies
```

### 🔌 API Endpoints
```
GET  /api/products           - Get all products
GET  /api/products/:id       - Get product by ID
POST /api/products           - Create product (with image)
PUT  /api/products/:id       - Update product (with image)
DELETE /api/products/:id     - Delete product

GET  /api/transactions       - Get all transactions
GET  /api/transactions/:id   - Get transaction detail
POST /api/transactions       - Create transaction

GET  /api/bahan-baku         - Get all raw materials
POST /api/bahan-baku         - Create raw material
PUT  /api/bahan-baku/:id     - Update raw material
DELETE /api/bahan-baku/:id   - Delete raw material

GET  /api/resep              - Get all recipes
POST /api/resep              - Create recipe
PUT  /api/resep/:id          - Update recipe
DELETE /api/resep/:id        - Delete recipe

GET  /api/produksi           - Get all production records
POST /api/produksi           - Create production record
PUT  /api/produksi/:id       - Update production record
DELETE /api/produksi/:id     - Delete production record

GET  /api/supplier           - Get all suppliers
POST /api/supplier           - Create supplier
PUT  /api/supplier/:id       - Update supplier
DELETE /api/supplier/:id     - Delete supplier

GET  /api/diskon             - Get all discounts
POST /api/diskon             - Create discount
PUT  /api/diskon/:id         - Update discount
DELETE /api/diskon/:id       - Delete discount

GET  /api/users              - Get all users
POST /api/users              - Create user
PUT  /api/users/:id          - Update user
DELETE /api/users/:id        - Delete user
```

### 🗄️ Database Schema (MySQL)
- **products**: id, name, price, discount, stock, jenis, satuan, barcode, image, resep_id
- **transactions**: id, total_harga, metode_pembayaran, jumlah_bayar, kembalian, tanggal
- **transaction_details**: id, transaction_id, product_id, product_name, product_jenis, product_satuan, product_image, quantity, price, subtotal, discount
- **bahan_baku**: id, nama, stok, satuan, harga_per_satuan
- **resep**: id, produk_id, bahan_baku_id, jumlah
- **produksi**: id, produk_id, tanggal, jumlah
- **supplier**: id, nama, kontak, alamat
- **diskon**: id, nama, persentase, tanggal_mulai, tanggal_selesai
- **users**: id, username, password, role

### 🔐 Security Features
1. **Password Hashing**: bcryptjs untuk menyimpan password dengan aman
2. **JWT Authentication**: JSON Web Token untuk user authentication
3. **CORS**: Cross-Origin Resource Sharing untuk frontend-backend communication
4. **Input Validation**: Validasi data sebelum disimpan ke database
5. **SQL Injection Prevention**: Menggunakan parameterized queries dengan mysql2

### 📤 File Upload System
- **Library**: Multer
- **Storage**: Local storage di folder `uploads/`
- **Naming**: Unique filename dengan timestamp dan random number
- **URL Building**: Base URL VPS production server (http://103.67.78.70) untuk image access
- **Default Images**: Auto-assign default images berdasarkan jenis produk

---

## 🎯 JAWABAN PERTANYAAN PRESENTASI

### Q1: "Kenapa memilih Node.js dan Express.js untuk backend?"

**Jawaban:**
"Kami memilih Node.js dengan Express.js karena:
1. **Performance**: Node.js menggunakan event-driven, non-blocking I/O yang sangat cocok untuk aplikasi real-time seperti POS
2. **JavaScript Ecosystem**: Sama dengan frontend (Flutter/Dart), memudahkan maintenance karena tim bisa fokus pada satu bahasa pemrograman
3. **Scalability**: Express.js ringan dan mudah di-scale untuk menangani banyak transaksi simultan
4. **Rich Ecosystem**: Banyak npm packages yang tersedia untuk kebutuhan seperti file upload (multer), authentication (JWT), dan database (mysql2)
5. **Community Support**: Komunitas yang besar dan aktif untuk troubleshooting"

### Q2: "Bagaimana cara backend menangani file upload gambar produk?"

**Jawaban:**
"Backend menggunakan library **Multer** untuk menangani file upload:
1. **Storage Configuration**: File disimpan di folder `uploads/` dengan unique filename (timestamp + random number)
2. **Image URL Building**: Backend membangun URL lengkap menggunakan base URL VPS production server untuk frontend access
3. **Default Images**: Jika produk tidak memiliki gambar, backend otomatis menetapkan default image berdasarkan jenis produk (cake.jpg untuk CAKE, bread.jpg untuk BREAD, dll)
4. **Validation**: File hanya diterima jika format sesuai dan ukuran reasonable
5. **Static Files**: Express static middleware digunakan untuk serve images di `/uploads` dan `/images` endpoints"

### Q3: "Bagaimana backend menghitung diskon dan subtotal dalam transaksi?"

**Jawaban:**
"Backend menggunakan logika perhitungan yang konsisten:
1. **Price Field**: Menyimpan harga asli produk
2. **Discount Field**: Menyimpan persentase diskon (misal: 30 untuk 30%)
3. **Subtotal Calculation**: Backend menghitung subtotal berdasarkan harga setelah diskon × quantity
   - Formula: `price × (1 - discount/100) × quantity`
4. **Transaction Storage**: Backend menyimpan:
   - `price`: harga asli
   - `discount`: persentase diskon
   - `subtotal`: harga setelah diskon × quantity
5. **Total Calculation**: Total harga transaksi = sum dari semua item subtotal
6. **Kembalian**: Jumlah bayar - total harga"

### Q4: "Bagaimana backend mengelola koneksi database?"

**Jawaban:**
"Backend menggunakan **MySQL Connection Pooling** dengan mysql2:
1. **Connection Pool**: Membuat pool koneksi dengan limit 10 connections
2. **Efficiency**: Koneksi bisa di-reuse untuk multiple queries, mengurangi overhead
3. **Scalability**: QueueLimit 0 berarti unlimited queue untuk menangani high traffic
4. **Configuration**: 
   - Host: localhost
   - Database: bakery_pos
   - Connection Limit: 10
   - Wait for Connections: true
5. **Performance**: Connection pooling lebih efisien daripada membuat koneksi baru untuk setiap query"

### Q5: "Bagaimana backend menangani error dan validation?"

**Jawaban:**
"Backend memiliki mekanisme error handling yang robust:
1. **Try-Catch Blocks**: Semua controller functions dibungkus dalam try-catch untuk menangani error
2. **HTTP Status Codes**: Menggunakan status codes yang appropriate:
   - 200: Success
   - 400: Bad Request (validation error)
   - 404: Not Found
   - 500: Internal Server Error
3. **Error Messages**: Mengirim error messages yang clear ke frontend
4. **Input Validation**: Validasi data sebelum database operations
5. **404 Handler**: Global handler untuk routes yang tidak ditemukan
6. **Database Error Handling**: Menangani database connection errors dan query errors"

### Q6: "Apa keuntungan menggunakan REST API untuk sistem POS?"

**Jawaban:**
"REST API memberikan beberapa keuntungan:
1. **Stateless**: Setiap request mengandung semua informasi yang diperlukan, tidak ada session state di server
2. **Scalability**: Mudah di-scale karena stateless nature
3. **Separation of Concerns**: Backend dan frontend terpisah, bisa dikembangkan secara independent
4. **Standard Methods**: Menggunakan HTTP methods standar (GET, POST, PUT, DELETE)
5. **JSON Format**: Data exchange menggunakan JSON yang lightweight dan easy to parse
6. **Platform Independent**: Bisa diakses dari berbagai platform (mobile, web, desktop)
7. **Caching**: HTTP caching bisa dimanfaatkan untuk improve performance"

### Q7: "Bagaimana backend mengelola relationship antara produk dan bahan baku?"

**Jawaban:**
"Backend menggunakan sistem recipe (resep) untuk mengelola relationship:
1. **Resep Table**: Menyimpan relationship antara produk dan bahan baku
   - `produk_id`: ID produk
   - `bahan_baku_id`: ID bahan baku
   - `jumlah`: Jumlah bahan baku yang dibutuhkan
2. **Production Tracking**: Produksi controller mencatat produksi produk dan mengurangi stok bahan baku secara otomatis
3. **Stock Management**: Bahan baku controller mengelola stok bahan baku
4. **Supplier Management**: Supplier controller mengelola informasi supplier untuk pembelian bahan baku
5. **Integration**: Sistem terintegrasi untuk memastikan stok bahan baku cukup untuk produksi"

### Q8: "Bagaimana backend menangani authentication dan authorization?"

**Jawaban:**
"Backend menggunakan JWT (JSON Web Token) untuk authentication:
1. **Password Hashing**: Password di-hash menggunakan bcryptjs sebelum disimpan ke database
2. **JWT Token**: Setelah login, user mendapatkan JWT token
3. **Token Validation**: Token divalidasi pada setiap protected route
4. **Role-Based Access**: User memiliki role (admin, kasir, dll) untuk authorization
5. **Middleware**: JWT middleware digunakan untuk protect sensitive routes
6. **Security**: Token memiliki expiration time untuk security"

### Q9: "Bagaimana backend menangani concurrent transactions?"

**Jawaban:**
"Backend menggunakan beberapa strategi untuk menangani concurrent transactions:
1. **Connection Pooling**: MySQL connection pool memastikan koneksi yang efisien
2. **Async/Await**: Semua database operations menggunakan async/await untuk non-blocking
3. **Transaction Isolation**: MySQL transaction isolation level untuk data consistency
4. **Queue System**: Connection pool queue untuk menangani request overflow
5. **Error Handling**: Proper error handling untuk rollback jika transaction gagal
6. **Atomic Operations**: Transaction creation dan detail insertion dilakukan secara atomic"

### Q10: "Apa challenges yang dihadapi selama pengembangan backend?"

**Jawaban:**
"Beberapa challenges yang kami hadapi:
1. **Image URL Management**: Mengelola base URL untuk image access dengan production environment yang stabil
2. **Discount Calculation Logic**: Memastikan perhitungan diskon konsisten antara frontend dan backend
3. **File Upload Handling**: Menangani file upload dengan Multer dan memastikan storage yang efisien
4. **Database Relationship**: Mengelola complex relationship antara produk, bahan baku, dan resep
5. **Error Handling**: Menangani berbagai jenis error dengan proper HTTP status codes
6. **Security**: Implementasi password hashing dan JWT authentication
7. **Performance**: Optimasi query dan connection pooling untuk handle high traffic"

---

## 💡 TIPS PRESENTASI

### 🎯 Points Utama untuk Ditekankan
1. **Scalability**: Backend dirancang untuk scale dan handle banyak transaksi
2. **Security**: Implementasi security best practices (password hashing, JWT)
3. **Performance**: Connection pooling dan async operations untuk optimal performance
4. **Maintainability**: Struktur MVC yang clean dan mudah di-maintain
5. **Integration**: Backend terintegrasi dengan frontend Flutter dan database MySQL

### 📊 Demo yang Bisa Ditunjukkan
1. **API Testing**: Show API endpoints dengan Postman atau browser
2. **Database Operations**: Show data di database MySQL
3. **File Upload**: Demo upload gambar produk
4. **Transaction Flow**: Demo flow dari cart ke transaction completion
5. **Error Handling**: Show proper error responses

### 🔧 Technical Details untuk Dibahas
1. **Connection Pooling**: Explain mengapa menggunakan connection pool
2. **Async/Await**: Explain non-blocking operations
3. **REST Principles**: Explain REST API design principles
4. **Security**: Explain password hashing dan JWT
5. **File Upload**: Explain Multer dan static file serving

---

## 🚀 CONCLUSION

Backend Bakery POS API adalah sistem yang:
- **Robust**: Menangani error dengan baik dan memiliki proper error handling
- **Scalable**: Dirancang untuk scale dengan connection pooling dan async operations
- **Secure**: Implementasi security best practices
- **Maintainable**: Struktur MVC yang clean dan easy to maintain
- **Integrated**: Terintegrasi dengan frontend Flutter dan database MySQL

Backend ini menyediakan foundation yang solid untuk sistem POS yang bisa menangani banyak transaksi dengan performance yang baik dan security yang terjamin.
