<template>
    <aside :class="`${is_expanded && 'is-expanded'}`">
        <header class="logo">
            <img src="../assets/vue.svg" alt="Electri Marcas Logo">
        </header>

        <nav class="menu-toggle-wrap">
            <!-- Aquí irá el contenido del menú -->
             <button class="menu-toggle" @click="ToggleMenu">
                <span class="material-icons">double_arrow</span>
             </button>
        </nav>
    </aside>
</template>

<script setup>
import { ref } from 'vue'

const is_expanded = ref(false)

const ToggleMenu = () => {
    is_expanded.value = !is_expanded.value
}
</script>
    
<style lang="scss" scoped>
    /* Estilos para el Sidebar */
    aside {
        display: flex;
        flex-direction: column;
        width: calc(2rem + 32px);
        min-height: 100vh;
        overflow: hidden;

        background-color: var(--dark);
        color: var(--light);

        transition: 0.2s ease-out;

        @media (max-width: 768px) {
            position: fixed;
            z-index: 10;
        }

    

    .logo {
        margin-bottom: 1rem;

        img {
            width: 2rem;
            
        }
    }

    .menu-toggle-wrap {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 1rem;

        position: relative;
        top: 0;
        transition: 0.2s ease-out;

        .menu-toggle{
            transition: 0.2s ease-out;

            .material-icons{
                font-size: 2rem;
                color: var(--light);
                
            }
        }
        
        
    }


    &.is-expanded {
        width: var(--sidebar-width);
        .menu-toggle-wrap {
            top: -3rem ;
            .menu-toggle {
                transform: rotate(-180deg);
            }

        }

    }

    @media (max-width: 768px) {
        position: fixed;
        z-index: 99;
    }
}
</style>
