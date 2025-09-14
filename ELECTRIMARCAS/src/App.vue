

<template>
  <div class="app">
    <Sidebar />
    <main>
      <router-view />
    </main>
  </div>
</template>
<script setup>
import Sidebar from './components/Sidebar.vue'
</script>
<style lang="scss">
:root {
  --primary: #4ade80;
  --grey: #6b7280;
  --dark: #1e293b;
  --dark-alt: #334155;
  --light: #f1f5f9;
  --sidebar-width: 300px;
}
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
button {
  cursor: pointer;
  appearance: none;
  border: none;
  outline: none;
  background: none;
}


.app {
  display: flex;
  min-height: 100vh;
  width: 100%;
}

main {
  flex: 1 1 0;
  padding: 2rem;
  background-color: white;
  min-height: 100vh;
  transition: margin-left 0.2s ease-in-out;
}

@media (max-width: 1024px) {
  .app {
    flex-direction: row;
  }
  main {
    padding: 1rem;
    margin-left: calc(2rem + 32px);
  }
}

@media (max-width: 768px) {
  main {
    padding: 1rem;
    margin-left: calc(2rem + 32px);
  }
}


</style>
