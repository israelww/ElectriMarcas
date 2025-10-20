// src/services/dataService.js
import axios from 'axios';

// Define la URL base de la API de Node.js
const API_URL = 'http://localhost:3000/api'; 

/**
 * Función para obtener los datos de la gráfica desde el backend.
 * @returns {Promise<Object>} Promesa que resuelve con los datos de la gráfica (formato Chart.js).
 */
export async function getChartData() {
  try {
    // La ruta que definiste en tu backend de Node.js/Express
    const response = await axios.get(`${API_URL}/data-grafica`);
     // Axios parsea el JSON automáticamente.
    return response.data.data; 


  } catch (error) {
    //manejar el error a nivel de servicio y lanzarlo para que el componente (UI) decida cómo mostrarlo.
    console.error("Error al obtener datos de la API:", error);
    throw new Error("No se pudo conectar o procesar los datos del servidor.");
  }
}

export async function getDispositivosList() {
    try {
        const response = await axios.get(`${API_URL}/dispositivos-lista`);
        
        // Devolvemos el array de objetos Card listos para ser usados
        return response.data.data; 

    } catch (error) {
        console.error("Error al obtener la lista de dispositivos:", error);
        throw new Error("No se pudo cargar la lista de dispositivos desde el servidor.");
    }
}