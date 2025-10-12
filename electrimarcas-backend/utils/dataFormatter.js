// backend/utils/dataFormatter.js
function formatDataForChartJS(datosRaw) {
  // Extraer las etiquetas (eje X) y los valores (eje Y)
  const labels = datosRaw.map(item => item.nombre_electrodomestico);
  const values = datosRaw.map(item => item.consumo_total_kwh);

  return {
    labels: labels, //
    datasets: [
      {
        label: 'Consumo kWh',
        backgroundColor: '#42b883', // Color de la barra/línea
        data: values, // [40, 60, 35, 75]
      }
    ]
  };
}
module.exports = { formatDataForChartJS };