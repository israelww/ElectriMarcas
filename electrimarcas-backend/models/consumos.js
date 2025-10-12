const { pool } = require('../src/db');

/**
 * Obtiene los totales de ventas agrupados por mes.
 * @returns {Promise<Array>} Datos brutos de la DB.
 */
async function fetchConsumoData() {
    try {
        const query = "select TOP 5 nombre_electrodomestico,SUM(potencia)/ 1000.0 AS consumo_total_kwh FROM electrodomestico	Group By nombre_electrodomestico order by  consumo_total_kwh  ";
        const result = await pool.query(query);
        return result && result.recordset ? result.recordset : []; 
 
    } catch (error) {
        console.error("Error en la consulta de ventas:", error);
        throw error; // Lanza el error para que la ruta lo maneje
    }
}

module.exports = { fetchConsumoData };