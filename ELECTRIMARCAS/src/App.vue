

<template>
  <!-- Contenedor principal de la aplicación -->
  <nav class="app">
    <!-- Componente de navegación lateral -->
    <Sidebar />
    
    <!-- Área principal de contenido donde se renderizan las vistas -->
    <main>
      <router-view />
    </main>
  </nav>
</template>

<script setup>
// Importación del componente Sidebar
import Sidebar from './components/Sidebar.vue'
</script>
<style lang="scss">
/* ===========================================
   VARIABLES CSS GLOBALES
   =========================================== */
:root {
  --primary: #92c83c;        /* Color primario de la aplicación */
  --grey: #6b7280;           /* Color gris para texto secundario */
  --dark: #1e293b;           /* Color oscuro para el sidebar */
  --dark-alt: #334155;       /* Color oscuro alternativo para hover */
  --light: #f1f5f9;          /* Color claro para texto en sidebar */
  --sidebar-width: 300px;    /* Ancho del sidebar cuando está expandido */
}

/* ===========================================
   RESET CSS Y ESTILOS BASE
   =========================================== */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Fira sans', sans-serif;
}

body {
  background-color: white;
  color: #333;
}

/* Estilos base para botones */
button {
  cursor: pointer;
  appearance: none;
  border: none;
  outline: none;
  background: none;
}

/* ===========================================
   LAYOUT PRINCIPAL DE LA APLICACIÓN
   =========================================== */
.app {
  display: flex;
  min-height: 100vh;
  width: 100%;
}

/* Área principal de contenido */
main {
  flex: 1 1 0;
  padding: 2rem;
  background-color: white;
  min-height: 100vh;
  transition: margin-left 0.2s ease-in-out;
}

/* ===========================================
   RESPONSIVE DESIGN
   =========================================== */

/* Tablets y pantallas medianas */
@media (max-width: 1024px) {
  .app {
    flex-direction: row;
  }
  
  main {
    padding: 1rem;
    margin-left: calc(2rem + 32px); /* Espacio para el sidebar contraído */
  }
}

/* Móviles grandes */
@media (max-width: 768px) {
  main {
    padding: 1rem;
    margin-left: calc(2rem + 32px); /* Espacio para el sidebar contraído */
  }
}
</style>
