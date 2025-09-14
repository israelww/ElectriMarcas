

<template>
    <span class="app">
      <!--Sidebar-->
      <Sidebar></Sidebar>
        <router-view></router-view>
    </span>
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

  main {
    flex: 1 1 0;
    padding: 2rem;
    background-color: white;
    min-height: 100vh;
  }

  @media(max-width: 768px) {
    padding-left: calc(2rem + 32px);
    padding-top: 6rem;
  }
}


</style>
