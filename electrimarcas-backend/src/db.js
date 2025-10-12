// src/db.js
require('dotenv').config();
const sql = require('mssql');

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  server: process.env.DB_SERVER,      // p.ej. 'localhost'
  database: process.env.DB_NAME,      // 'ELECTRIMARCAS'
  port: Number(process.env.DB_PORT) || 1433,
  options: {
    encrypt: false,
    trustServerCertificate: true,
    instanceName: process.env.DB_INSTANCE || undefined
  }
};

const pool = new sql.ConnectionPool(config);
const poolConnect = pool.connect()
  .then(() => console.log('✅ Conectado a SQL Server'))
  .catch(err => {
    console.error('❌ Error conectando a SQL Server:', err);
    process.exit(1);
  });

module.exports = { sql, pool, poolConnect };


