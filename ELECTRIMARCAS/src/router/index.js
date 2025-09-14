// Importaciones necesarias para el router de Vue
import {createRouter, createWebHistory} from 'vue-router'
import Inicio from '../views/Inicio.vue'
import Acercade from '../views/Acercade.vue'
import Mis_dispositivos from '../views/Mis_dispositivos.vue'
import Estadisticas from '../views/Estadisticas.vue'
import Consejos_ahorro from '../views/Consejos_ahorro.vue'

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
      path: '/Inicio',           // Ruta raíz de la aplicación
      name: 'Inicio',      // Nombre identificador de la ruta
      component: Inicio    // Componente a renderizar en esta ruta
    },

    {
      path: '/Acerca-de',  // Ruta para la página de Acerca de
      name: 'Acerca de',    // Nombre identificador de la ruta
      component: Acercade   // Componente a renderizar en esta ruta
    },

    {
      path: '/Mis-dispositivos',  // Ruta para la página de Mis Dispositivos
      name: 'Mis Dispositivos',    // Nombre identificador de la ruta
      component: Mis_dispositivos  // Componente a renderizar en esta ruta
    },

    {
      path: '/Estadisticas',  // Ruta para la página de Estadísticas
      name: 'Estadísticas',    // Nombre identificador de la ruta
      component: Estadisticas  // Componente a renderizar en esta ruta
    },

    {
      path: '/Consejos-de-ahorro',  // Ruta para la página de Consejos de Ahorro
      name: 'Consejos de Ahorro',    // Nombre identificador de la ruta
      component: Consejos_ahorro     // Componente a renderizar en esta ruta
    },

    // Aquí se pueden agregar más rutas según sea necesario
  ]
})

// Exporta la instancia del router para ser utilizada en main.js
export default router