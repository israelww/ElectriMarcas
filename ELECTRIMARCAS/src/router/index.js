import { createRouter, createWebHistory } from 'vue-router'
import Inicio from '../views/Inicio/Inicio.vue'
import IniciodeSesion from '../views/IniciodeSesion/Inicio_de_Sesion.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      name: 'Inicio',
      component: Inicio
    },
    {
      path: '/inicio_de_sesion',
      name: 'IniciodeSesion',
      component: IniciodeSesion
    },
  ]
})

export default router