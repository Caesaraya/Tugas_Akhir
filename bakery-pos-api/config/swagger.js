const swaggerJsdoc = require('swagger-jsdoc');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Bakery POS API',
      version: '1.0.0',
      description: 'API documentation for Bakery POS System - Point of Sale for Bakery Business',
      contact: {
        name: 'Backend Developer',
        email: 'developer@example.com'
      }
    },
    servers: [
      {
        url: 'http://103.67.78.70',
        description: 'Production Server'
      },
      {
        url: 'http://localhost:3000',
        description: 'Development Server'
      }
    ],
    components: {
      schemas: {
        Product: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            price: { type: 'number' },
            discount: { type: 'number' },
            stock: { type: 'integer' },
            jenis: { type: 'string' },
            satuan: { type: 'string' },
            image: { type: 'string' },
            resep_id: { type: 'integer' }
          }
        },
        Transaction: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            tanggal: { type: 'string', format: 'date-time' },
            total_harga: { type: 'number' },
            metode_pembayaran: { type: 'string' },
            jumlah_bayar: { type: 'number' },
            kembalian: { type: 'number' }
          }
        },
        BahanBaku: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            nama_bahan: { type: 'string' },
            merk: { type: 'string' },
            satuan: { type: 'string' },
            stok: { type: 'number' },
            harga_satuan: { type: 'number' },
            total_harga: { type: 'number' }
          }
        },
        Resep: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            nama_resep: { type: 'string' },
            deskripsi: { type: 'string' }
          }
        },
        Produksi: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            product_id: { type: 'integer' },
            jumlah_produksi: { type: 'integer' },
            tanggal: { type: 'string', format: 'date-time' }
          }
        },
        User: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            email: { type: 'string' },
            role: { type: 'string' }
          }
        },
        Error: {
          type: 'object',
          properties: {
            success: { type: 'boolean' },
            message: { type: 'string' }
          }
        }
      }
    }
  },
  apis: ['./controllers/*.js', './routes/*.js']
};

const specs = swaggerJsdoc(options);

module.exports = specs;
