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

function formatDataForCardList(datosRaw) {
    if (!Array.isArray(datosRaw) || datosRaw.length === 0) {
        return []; 
    }

    // Mapeamos los datos de la DB al formato que espera el componente Card
    return datosRaw.map(item => ({
        id: item.id,
        // CRÍTICO: Usar el nombre exacto de la columna de la DB para el título
        title: item.nombre_electrodomestico, 
        // Usamos la descripción si existe, sino usamos la potencia
        description: item.descripcion || `Potencia: ${item.potencia}W`, 
        image: null, // Dejamos la imagen en null (se gestionará en Vue)
        backgroundColor1: "#005CB3", // Colores de ejemplo
        backgroundColor2: "#0084FF"
    }));
}
module.exports = { formatDataForChartJS };