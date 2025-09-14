// Importaciones necesarias para el router de Vue
import {createRouter, createWebHistory} from 'vue-router'
import Inicio from '../views/Inicio.vue'

/**
 * Configuración del router de Vue
 * Define las rutas de la aplicación y su comportamiento
 */
const router = createRouter({
  // Usa el historial del navegador para la navegación
  history: createWebHistory(),
  
  // Array de rutas de la aplicación
  routes: [
    {
      path: '/',           // Ruta raíz de la aplicación
      name: 'Inicio',      // Nombre identificador de la ruta
      component: Inicio    // Componente a renderizar en esta ruta
    },
    // Aquí se pueden agregar más rutas según sea necesario
  ]
})

// Exporta la instancia del router para ser utilizada en main.js
export default router