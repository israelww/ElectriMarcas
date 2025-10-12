// backend/routes/api.js
const express = require('express');
const router = express.Router();
//acceso al a bd
const db = require('../models/consumos.js'); 
const { formatDataForChartJS } = require('../utils/dataFormatter'); // Función de formato

// La ruta que tu frontend de Vue llamará: http://localhost:3000/api/data-grafica
router.get('/data-grafica', async (req, res) => {
  try {
    // 1. Obtención de datos brutos de la DB
    const datosRaw = await db.fetchConsumoData(); 
    // 2. Formateo de los datos para la librería de gráficas (Chart.js)
    const datosGrafico = formatDataForChartJS(datosRaw);

    // 3. Respuesta de éxito (Status 200 OK)
    res.status(200).json({
      success: true,
      data: datosGrafico // El objeto que Vue usará
    });

  } catch (error) {
    console.error('Error en la ruta /data-grafica:', error);
    // Respuesta de error (Status 500 Internal Server Error)
    res.status(500).json({ 
      success: false, 
      message: 'Error al procesar los datos del servidor.' 
    });
  }
});

module.exports = router;