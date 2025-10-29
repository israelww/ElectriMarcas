// src/services/dataService.js
import axios from 'axios';
import authService from './authService.js';

// Define la URL base de la API de Node.js
const API_URL = 'http://localhost:3001/api';

// Configurar axios para incluir el token de autenticación automáticamente
axios.interceptors.request.use(
  (config) => {
    const token = authService.getAuthHeader();
    if (token) {
      config.headers.Authorization = token;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor para manejar respuestas 401 (no autorizado)
axios.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expirado o inválido, cerrar sesión
      authService.logout();
      window.location.href = '/inicio-sesion';
    }
    return Promise.reject(error);
  }
); 

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

export async function getDispositivosByCategoria(categoriaId) {
    try {
        const response = await axios.get(`${API_URL}/dispositivos-lista/${categoriaId}`);
        
        // Devolvemos el array de objetos Card listos para ser usados
        return response.data.data; 

    } catch (error) {
        console.error("Error al obtener la lista de dispositivos por categoría:", error);
        throw new Error("No se pudo cargar la lista de dispositivos de la categoría desde el servidor.");
    }
}

// Lee los dispositivos guardados en localStorage y devuelve un resumen kWh
export function getConsumoResumen() {
  try {
    const saved = localStorage.getItem('categoriasCards');
    if (!saved) return { diarioKWh: 0, semanalKWh: 0, mensualKWh: 0, anualKWh: 0 };
    const map = JSON.parse(saved);
    const resumen = { diarioKWh: 0, semanalKWh: 0, mensualKWh: 0, anualKWh: 0 };
    Object.values(map || {}).forEach(arr => {
      (arr || []).forEach(d => {
        const cantidad = d.cantidad ?? 1;
        const horas = d.horasUsoPorDia ?? 0;
        const diasSemana = d.diasUsoPorSemana ?? 7;
        const potencia = d.potencia ?? 0;
        const diario = (potencia * horas * cantidad) / 1000;
        resumen.diarioKWh += diario;
        resumen.semanalKWh += diario * diasSemana;
        resumen.mensualKWh += diario * 30;
        resumen.anualKWh += diario * 365;
      });
    });
    return resumen;
  } catch {
    return { diarioKWh: 0, semanalKWh: 0, mensualKWh: 0, anualKWh: 0 };
  }
}