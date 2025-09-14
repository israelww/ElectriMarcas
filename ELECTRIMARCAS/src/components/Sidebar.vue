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
            <router-link class="button" to="/inicio">
                <span class="material-icons">home</span>
                <span class="text">Inicio</span>
            </router-link>

            <router-link class="button" to="/mis-dispositivos">
                <span class="material-icons">devices</span>
                <span class="text">Mis Dispositivos</span>
            </router-link>

            <router-link class="button" to="/acerca-de">
                <span class="material-icons">description</span>
                <span class="text">Acerca de la app</span>
            </router-link>

            <router-link class="button" to="/Acerca-de">
                <span class="material-icons">group</span>
                <span class="text">Acerca de la app</span>
            </router-link>

            <router-link class="button" to="/Acerca-de">
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
			background-color: var(--dark);
			color: var(--light);
			width: calc(2rem + 32px);
			overflow: hidden;
			min-height: 100vh;
			padding: 1rem;
			transition: width 0.2s ease-in-out;
			position: static;

			&.is-expanded {
				width: var(--sidebar-width);
			}

			@media (max-width: 1024px) {
				position: fixed;
				top: 0;
				left: 0;
				z-index: 99;
				height: 100vh;
				width: calc(2rem + 32px);
				&.is-expanded {
					width: var(--sidebar-width);
					box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
				}
			}
			@media (max-width: 768px) {
				&.is-expanded {
					width: 280px;
				}
			}
			@media (max-width: 480px) {
				&.is-expanded {
					width: 100vw;
				}
			}

		.flex {
			flex: 1 1 0%;
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
		transition: 0.2s ease-in-out;

		.menu-toggle {
			transition: 0.2s ease-in-out;
			.material-icons {
				font-size: 2rem;
				color: var(--light);
				transition: 0.2s ease-out;
			}
			
			&:hover {
				.material-icons {
					color: var(--primary);
					transform: translateX(0.5rem);
				}
			}
		}
	}

	h3, .button .text {
		opacity: 0;
		transition: opacity 0.3s ease-in-out;
	}

	h3 {
		color: var(--grey);
		font-size: 0.875rem;
		margin-bottom: 0.5rem;
		text-transform: uppercase;
	}

	.menu {
		margin: 0 -1rem;

		.button {
			display: flex;
			align-items: center;
			text-decoration: none;

			transition: 0.2s ease-in-out;
			padding: 0.5rem 1rem;

			.material-icons {
				font-size: 2rem;
				color: var(--light);
				transition: 0.2s ease-in-out;
			}
			.text {
				color: var(--light);
				transition: 0.2s ease-in-out;
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

	.footer {
		opacity: 0;
		transition: opacity 0.3s ease-in-out;

		p {
			font-size: 0.875rem;
			color: var(--grey);
		}
	}

	&.is-expanded {
		width: var(--sidebar-width);

		.menu-toggle-wrap {
			top: -3rem;
			
			.menu-toggle {
				transform: rotate(-180deg);
			}
		}

		h3, .button .text {
			opacity: 1;
		}

		.button {
			.material-icons {
				margin-right: 1rem;
			}
		}

		.footer {
			opacity: 0;
		}
	}

	@media (max-width: 1024px) {
		position: absolute;
		z-index: 99;
	}
}
</style>
