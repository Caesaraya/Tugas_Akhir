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
            resep_id: { type: 'integer' },
            alasan_stock: { type: 'string' }
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
            deskripsi: { type: 'string' },
            bahan: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  bahan_id: { type: 'integer' },
                  jumlah_bahan: { type: 'number' }
                }
              }
            }
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
        Supplier: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            nama: { type: 'string' },
            alamat: { type: 'string' },
            telepon: { type: 'string' }
          }
        },
        Diskon: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            nama: { type: 'string' },
            persentase: { type: 'number' },
            berlaku_mulai: { type: 'string', format: 'date' },
            berlaku_selesai: { type: 'string', format: 'date' }
          }
        },
        ExpenseCategory: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            description: { type: 'string' }
          }
        },
        Expense: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            tanggal: { type: 'string', format: 'date' },
            category_id: { type: 'integer' },
            nominal: { type: 'number' },
            keterangan: { type: 'string' }
          }
        },
        FinancialReport: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            tahun: { type: 'integer' },
            bulan: { type: 'integer' },
            pemasukan: { type: 'number' },
            pengeluaran: { type: 'number' },
            profit: { type: 'number' }
          }
        },
        Pembelian: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            tanggal: { type: 'string', format: 'date' },
            supplier_id: { type: 'integer' },
            total: { type: 'number' }
          }
        },
        DashboardActivity: {
          type: 'object',
          properties: {
            jenis_aktivitas: { type: 'string' },
            deskripsi: { type: 'string' },
            icon: { type: 'string' },
            waktu: { type: 'string', format: 'date-time' }
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
    },
    paths: {
      '/api/products': {
        get: {
          summary: 'Get all products',
          tags: ['Products'],
          responses: {
            '200': {
              description: 'List of products',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Product' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new product',
          tags: ['Products'],
          requestBody: {
            required: true,
            content: {
              'multipart/form-data': {
                schema: {
                  type: 'object',
                  properties: {
                    name: { type: 'string' },
                    price: { type: 'number' },
                    discount: { type: 'number' },
                    stock: { type: 'integer' },
                    jenis: { type: 'string' },
                    satuan: { type: 'string' },
                    resep_id: { type: 'integer' },
                    image: { type: 'string', format: 'binary' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Product created' }
          }
        }
      },
      '/api/products/{id}': {
        get: {
          summary: 'Get product by ID',
          tags: ['Products'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Product details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Product' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update product',
          tags: ['Products'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'multipart/form-data': {
                schema: {
                  type: 'object',
                  properties: {
                    name: { type: 'string' },
                    price: { type: 'number' },
                    discount: { type: 'number' },
                    stock: { type: 'integer' },
                    jenis: { type: 'string' },
                    satuan: { type: 'string' },
                    resep_id: { type: 'integer' },
                    alasan_stock: { type: 'string' },
                    image: { type: 'string', format: 'binary' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Product updated' }
          }
        }
      },
      '/api/products/{id}/delete': {
        patch: {
          summary: 'Soft delete product',
          tags: ['Products'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Product soft deleted' }
          }
        }
      },
      '/api/products/{id}/restore': {
        patch: {
          summary: 'Restore soft deleted product',
          tags: ['Products'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Product restored' }
          }
        }
      },
      '/api/products/{id}/force': {
        delete: {
          summary: 'Force delete product permanently',
          tags: ['Products'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Product permanently deleted' }
          }
        }
      },
      '/api/transactions': {
        get: {
          summary: 'Get all transactions',
          tags: ['Transactions'],
          responses: {
            '200': {
              description: 'List of transactions',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Transaction' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new transaction',
          tags: ['Transactions'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    items: {
                      type: 'array',
                      items: {
                        type: 'object',
                        properties: {
                          product_id: { type: 'integer' },
                          quantity: { type: 'integer' }
                        }
                      }
                    },
                    metode_pembayaran: { type: 'string' },
                    jumlah_bayar: { type: 'number' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Transaction created' }
          }
        }
      },
      '/api/transactions/{id}': {
        get: {
          summary: 'Get transaction detail by ID',
          tags: ['Transactions'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Transaction details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Transaction' }
                }
              }
            }
          }
        }
      },
      '/api/bahan-baku': {
        get: {
          summary: 'Get all bahan baku',
          tags: ['Bahan Baku'],
          responses: {
            '200': {
              description: 'List of bahan baku',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/BahanBaku' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new bahan baku',
          tags: ['Bahan Baku'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/BahanBaku' }
              }
            }
          },
          responses: {
            '200': { description: 'Bahan baku created' }
          }
        }
      },
      '/api/bahan-baku/{id}': {
        get: {
          summary: 'Get bahan baku by ID',
          tags: ['Bahan Baku'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Bahan baku details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/BahanBaku' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update bahan baku',
          tags: ['Bahan Baku'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/BahanBaku' }
              }
            }
          },
          responses: {
            '200': { description: 'Bahan baku updated' }
          }
        }
      },
      '/api/bahan-baku/{id}/delete': {
        patch: {
          summary: 'Soft delete bahan baku',
          tags: ['Bahan Baku'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Bahan baku soft deleted' }
          }
        }
      },
      '/api/bahan-baku/{id}/restore': {
        patch: {
          summary: 'Restore soft deleted bahan baku',
          tags: ['Bahan Baku'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Bahan baku restored' }
          }
        }
      },
      '/api/bahan-baku/{id}/force': {
        delete: {
          summary: 'Force delete bahan baku permanently',
          tags: ['Bahan Baku'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Bahan baku permanently deleted' }
          }
        }
      },
      '/api/bahan-baku/{id}/check-usage': {
        get: {
          summary: 'Check if bahan baku is used in recipes',
          tags: ['Bahan Baku'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Usage check result' }
          }
        }
      },
      '/api/bahan-baku/summary/stock': {
        get: {
          summary: 'Get stock summary',
          tags: ['Bahan Baku'],
          responses: {
            '200': { description: 'Stock summary' }
          }
        }
      },
      '/api/bahan-baku/pengambilan-manual': {
        post: {
          summary: 'Manual bahan pengambilan',
          tags: ['Bahan Baku'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    bahan_id: { type: 'integer' },
                    jumlah: { type: 'number' },
                    alasan: { type: 'string' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Pengambilan recorded' }
          }
        }
      },
      '/api/resep': {
        get: {
          summary: 'Get all resep',
          tags: ['Resep'],
          responses: {
            '200': {
              description: 'List of resep',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Resep' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new resep',
          tags: ['Resep'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Resep' }
              }
            }
          },
          responses: {
            '200': { description: 'Resep created' }
          }
        }
      },
      '/api/resep/{id}': {
        get: {
          summary: 'Get resep detail by ID',
          tags: ['Resep'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Resep details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Resep' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update resep',
          tags: ['Resep'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Resep' }
              }
            }
          },
          responses: {
            '200': { description: 'Resep updated' }
          }
        }
      },
      '/api/resep/{id}/delete': {
        patch: {
          summary: 'Soft delete resep',
          tags: ['Resep'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Resep soft deleted' }
          }
        }
      },
      '/api/resep/{id}/restore': {
        patch: {
          summary: 'Restore soft deleted resep',
          tags: ['Resep'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Resep restored' }
          }
        }
      },
      '/api/resep/{id}/force': {
        delete: {
          summary: 'Force delete resep permanently',
          tags: ['Resep'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Resep permanently deleted' }
          }
        }
      },
      '/api/produksi': {
        get: {
          summary: 'Get all produksi',
          tags: ['Produksi'],
          responses: {
            '200': {
              description: 'List of produksi',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Produksi' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new produksi',
          tags: ['Produksi'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Produksi' }
              }
            }
          },
          responses: {
            '200': { description: 'Produksi created' }
          }
        }
      },
      '/api/produksi/{id}': {
        get: {
          summary: 'Get produksi by ID',
          tags: ['Produksi'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Produksi details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Produksi' }
                }
              }
            }
          }
        }
      },
      '/api/suppliers': {
        get: {
          summary: 'Get all suppliers',
          tags: ['Suppliers'],
          responses: {
            '200': {
              description: 'List of suppliers',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Supplier' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new supplier',
          tags: ['Suppliers'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Supplier' }
              }
            }
          },
          responses: {
            '200': { description: 'Supplier created' }
          }
        }
      },
      '/api/suppliers/{id}': {
        get: {
          summary: 'Get supplier by ID',
          tags: ['Suppliers'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Supplier details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Supplier' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update supplier',
          tags: ['Suppliers'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Supplier' }
              }
            }
          },
          responses: {
            '200': { description: 'Supplier updated' }
          }
        },
        delete: {
          summary: 'Delete supplier',
          tags: ['Suppliers'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Supplier deleted' }
          }
        }
      },
      '/api/diskon': {
        get: {
          summary: 'Get all diskon',
          tags: ['Diskon'],
          responses: {
            '200': {
              description: 'List of diskon',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Diskon' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new diskon',
          tags: ['Diskon'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Diskon' }
              }
            }
          },
          responses: {
            '200': { description: 'Diskon created' }
          }
        }
      },
      '/api/diskon/{id}': {
        get: {
          summary: 'Get diskon by ID',
          tags: ['Diskon'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Diskon details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Diskon' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update diskon',
          tags: ['Diskon'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Diskon' }
              }
            }
          },
          responses: {
            '200': { description: 'Diskon updated' }
          }
        },
        delete: {
          summary: 'Delete diskon',
          tags: ['Diskon'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Diskon deleted' }
          }
        }
      },
      '/api/users/login': {
        post: {
          summary: 'User login',
          tags: ['Users'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    email: { type: 'string' },
                    password: { type: 'string' }
                  }
                }
              }
            }
          },
          responses: {
            '200': {
              description: 'Login successful',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/User' }
                }
              }
            }
          }
        }
      },
      '/api/users': {
        get: {
          summary: 'Get all users',
          tags: ['Users'],
          responses: {
            '200': {
              description: 'List of users',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/User' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create new user',
          tags: ['Users'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/User' }
              }
            }
          },
          responses: {
            '200': { description: 'User created' }
          }
        }
      },
      '/api/users/{id}': {
        get: {
          summary: 'Get user by ID',
          tags: ['Users'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'User details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/User' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update user',
          tags: ['Users'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/User' }
              }
            }
          },
          responses: {
            '200': { description: 'User updated' }
          }
        },
        delete: {
          summary: 'Delete user',
          tags: ['Users'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'User deleted' }
          }
        }
      },
      '/api/users/{id}/reset-password': {
        put: {
          summary: 'Reset user password',
          tags: ['Users'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    new_password: { type: 'string' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Password reset' }
          }
        }
      },
      '/api/bakery/hitung-kebutuhan': {
        get: {
          summary: 'Calculate ingredient requirements',
          tags: ['Bakery'],
          parameters: [
            { name: 'produk_id', in: 'query', required: true, schema: { type: 'integer' } },
            { name: 'quantity', in: 'query', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Ingredient requirements calculated' }
          }
        }
      },
      '/api/bakery/cek-ketersediaan': {
        get: {
          summary: 'Check ingredient availability',
          tags: ['Bakery'],
          parameters: [
            { name: 'produk_id', in: 'query', required: true, schema: { type: 'integer' } },
            { name: 'quantity', in: 'query', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Ingredient availability checked' }
          }
        }
      },
      '/api/bakery/hitung-biaya': {
        get: {
          summary: 'Calculate production cost',
          tags: ['Bakery'],
          parameters: [
            { name: 'produk_id', in: 'query', required: true, schema: { type: 'integer' } },
            { name: 'quantity', in: 'query', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Production cost calculated' }
          }
        }
      },
      '/api/bakery/produksi-possible': {
        get: {
          summary: 'Get possible production items',
          tags: ['Bakery'],
          parameters: [
            { name: 'quantity', in: 'query', required: false, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Possible production items' }
          }
        }
      },
      '/api/financial': {
        get: {
          summary: 'Get all financial reports',
          tags: ['Financial'],
          responses: {
            '200': {
              description: 'List of financial reports',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/FinancialReport' }
                  }
                }
              }
            }
          }
        }
      },
      '/api/financial/generate': {
        post: {
          summary: 'Generate financial report',
          tags: ['Financial'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    tahun: { type: 'integer' },
                    bulan: { type: 'integer' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Financial report generated' }
          }
        }
      },
      '/api/financial/summary': {
        get: {
          summary: 'Get financial summary',
          tags: ['Financial'],
          responses: {
            '200': { description: 'Financial summary' }
          }
        }
      },
      '/api/financial/{tahun}/{bulan}': {
        get: {
          summary: 'Get financial report by month',
          tags: ['Financial'],
          parameters: [
            { name: 'tahun', in: 'path', required: true, schema: { type: 'integer' } },
            { name: 'bulan', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Financial report details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/FinancialReport' }
                }
              }
            }
          }
        },
        delete: {
          summary: 'Delete financial report',
          tags: ['Financial'],
          parameters: [
            { name: 'tahun', in: 'path', required: true, schema: { type: 'integer' } },
            { name: 'bulan', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Financial report deleted' }
          }
        }
      },
      '/api/expenses/categories': {
        get: {
          summary: 'Get all expense categories',
          tags: ['Expenses'],
          responses: {
            '200': {
              description: 'List of expense categories',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/ExpenseCategory' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create expense category',
          tags: ['Expenses'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/ExpenseCategory' }
              }
            }
          },
          responses: {
            '200': { description: 'Expense category created' }
          }
        }
      },
      '/api/expenses/categories/{id}': {
        get: {
          summary: 'Get expense category by ID',
          tags: ['Expenses'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Expense category details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/ExpenseCategory' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update expense category',
          tags: ['Expenses'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/ExpenseCategory' }
              }
            }
          },
          responses: {
            '200': { description: 'Expense category updated' }
          }
        },
        delete: {
          summary: 'Delete expense category',
          tags: ['Expenses'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Expense category deleted' }
          }
        }
      },
      '/api/expenses': {
        get: {
          summary: 'Get all expenses',
          tags: ['Expenses'],
          parameters: [
            { name: 'category_id', in: 'query', required: false, schema: { type: 'integer' } },
            { name: 'start_date', in: 'query', required: false, schema: { type: 'string' } },
            { name: 'end_date', in: 'query', required: false, schema: { type: 'string' } }
          ],
          responses: {
            '200': {
              description: 'List of expenses',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Expense' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create expense',
          tags: ['Expenses'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Expense' }
              }
            }
          },
          responses: {
            '200': { description: 'Expense created' }
          }
        }
      },
      '/api/expenses/{id}': {
        get: {
          summary: 'Get expense by ID',
          tags: ['Expenses'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Expense details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Expense' }
                }
              }
            }
          }
        },
        put: {
          summary: 'Update expense',
          tags: ['Expenses'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Expense' }
              }
            }
          },
          responses: {
            '200': { description: 'Expense updated' }
          }
        },
        delete: {
          summary: 'Delete expense',
          tags: ['Expenses'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Expense deleted' }
          }
        }
      },
      '/api/expenses/summary/{tahun}/{bulan}': {
        get: {
          summary: 'Get expense summary by month',
          tags: ['Expenses'],
          parameters: [
            { name: 'tahun', in: 'path', required: true, schema: { type: 'integer' } },
            { name: 'bulan', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Expense summary' }
          }
        }
      },
      '/api/pembelian': {
        get: {
          summary: 'Get all pembelian',
          tags: ['Pembelian'],
          responses: {
            '200': {
              description: 'List of pembelian',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/Pembelian' }
                  }
                }
              }
            }
          }
        },
        post: {
          summary: 'Create pembelian',
          tags: ['Pembelian'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Pembelian' }
              }
            }
          },
          responses: {
            '200': { description: 'Pembelian created' }
          }
        }
      },
      '/api/pembelian/{id}': {
        get: {
          summary: 'Get pembelian by ID',
          tags: ['Pembelian'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'Pembelian details',
              content: {
                'application/json': {
                  schema: { $ref: '#/components/schemas/Pembelian' }
                }
              }
            }
          }
        },
        delete: {
          summary: 'Delete pembelian',
          tags: ['Pembelian'],
          parameters: [
            { name: 'id', in: 'path', required: true, schema: { type: 'integer' } }
          ],
          responses: {
            '200': { description: 'Pembelian deleted' }
          }
        }
      },
      '/api/dashboard/summary': {
        get: {
          summary: 'Get dashboard summary',
          tags: ['Dashboard'],
          responses: {
            '200': { description: 'Dashboard summary' }
          }
        }
      },
      '/api/dashboard/activities': {
        get: {
          summary: 'Get dashboard activities',
          tags: ['Dashboard'],
          parameters: [
            { name: 'limit', in: 'query', required: false, schema: { type: 'integer' } }
          ],
          responses: {
            '200': {
              description: 'List of activities',
              content: {
                'application/json': {
                  schema: {
                    type: 'array',
                    items: { $ref: '#/components/schemas/DashboardActivity' }
                  }
                }
              }
            }
          }
        }
      },
      '/api/pengambilan-bahan/resep': {
        post: {
          summary: 'Confirm bahan pengambilan based on resep',
          tags: ['Pengambilan Bahan'],
          requestBody: {
            required: true,
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    resep_id: { type: 'integer' },
                    quantity: { type: 'integer' }
                  }
                }
              }
            }
          },
          responses: {
            '200': { description: 'Pengambilan confirmed' }
          }
        }
      }
    }
  },
  apis: ['./controllers/*.js', './routes/*.js']
};

const specs = swaggerJsdoc(options);

module.exports = specs;

