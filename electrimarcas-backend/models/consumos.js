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

/**
 * Obtiene la lista COMPLETA de electrodomésticos registrados (para la vista de tarjetas).
 * @returns {Promise<Array>} Array de todos los electrodomésticos con sus datos clave.
 */
async function fetchElectrodomesticosList() {
    // Consulta simple: Obtener todos los campos necesarios para la Card.
    const query = `
        SELECT 
            id_electrodomestico, 
            nombre_electrodomestico, 
            descripcion, 
            potencia 
        FROM 
            electrodomestico 
        ORDER BY 
            nombre_electrodomestico;
    `;
    try {
        const result = await pool.query(query);
        // Usamos result.recordset para SQL Server. Cambia a result.rows si usas PostgreSQL/MySQL.
        return result.recordset || result.rows || []; 
    } catch (error) {
        console.error("❌ Error en la consulta fetchElectrodomesticosList:", error);
        throw error;
    }
}

module.exports = { fetchConsumoData, fetchElectrodomesticosList };