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

        <h3>Menu</h3>
        <nav class="menu">
            <router-link class="button" to="/">
                <span class="material-icons">home</span>
                <span class="text">Inicio</span>
            </router-link>
            
            <router-link class="button" to="/">
                <span class="material-icons">devices</span>
                <span class="text">Mis Dispositivos</span>
            </router-link>
        
            <router-link class="button" to="/">
                <span class="material-icons">description</span>
                <span class="text">Acerca de la app</span>
            </router-link>
           
            <router-link class="button" to="/">
                <span class="material-icons">group</span>
                <span class="text">Acerca de la app</span>
            </router-link>
            
            <router-link class="button" to="/">
                <span class="material-icons">dehaze</span>
                <span class="text">Acerca de la app</span>
            </router-link>
            
            

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
        height: 100%;
        overflow: hidden;
        position: sticky;
        top: 0;
        left: 0;

        background-color: var(--dark);
        color: var(--light);

        transition: 0.2s ease-out;

        @media (max-width: 768px) {
            position: fixed;
            top: 0;
            left: 0;
            z-index: 99;
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

    h3, .button .text {
        opacity: 0;
        visibility: hidden;
        display: none;
        transition: 0.3s ease-out;
    }

    h3 {
        padding: 0 0.8rem;
        margin-bottom: 1rem;
        font-size: 1rem;
    }

    .menu {
        flex: 1 1 0;
        .button {
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            padding: 0.8rem;
            color: var(--light);
            transition: 0.2s ease-out;

            &:not(.is-expanded) {
                padding: 0.8rem 0.15rem;
            }

            .material-icons {
                font-size: 2rem;
                transition: 0.2s ease-out;
                margin-right: 0;
                width: 2rem;
                text-align: center;
            }

            .text {
                transition: 0.3s ease-out;
            }

            &:hover {
                background-color: var(--dark-alt);
                .material-icons, .text {
                    color: var(--primary);
                }
            }

            &.router-link-exact-active {
                background-color: var(--dark-alt);
                border-right: 5px solid var(--primary);
                .material-icons, .text {
                    color: var(--primary);
                }
            }
        }
    }

    &.is-expanded {
        width: var(--sidebar-width);
        
        h3, .button .text {
            opacity: 1;
            align-items: center;
            justify-content: center;
            visibility: visible;
            display: block;
        }

        .button {
            justify-content: flex-start;
            align-items: center;
            width: 100%;
            box-sizing: border-box;
            padding: 0.8rem 1rem 0.8rem 1.5rem;
            gap: 1rem;
            .material-icons {
                min-width: 2rem;
                text-align: center;
                margin: 0;
            }
        }
        
        .menu-toggle-wrap {
            top: -3rem;
            .menu-toggle {
                transform: rotate(-180deg);
            }
        }
    }

    .menu{
        margin: 0 -1rem;
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

    h3, .button .text{
        opacity: 1;
       
    }

    @media (max-width: 768px) {
        position: fixed;
        z-index: 99;
    }
}
</style>
