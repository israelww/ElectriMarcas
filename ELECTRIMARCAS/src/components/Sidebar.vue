<template>
    <!-- Sidebar principal de la aplicación -->
    <aside :class="`${is_expanded && 'is-expanded'}`">
        <!-- Header con el logo de la aplicación -->
        <header class="logo">
            <img src="../assets/vue.svg" alt="Electri Marcas Logo">
        </header>

        <!-- Botón para expandir/contraer el menú -->
        <nav class="menu-toggle-wrap">
            <button class="menu-toggle" @click="ToggleMenu">
                <span class="material-icons">double_arrow</span>
            </button>
        </nav>

        <!-- Título de la sección de menú -->
        <h3>Menu</h3>
        
        <!-- Navegación principal con enlaces a las diferentes secciones -->
        <nav class="menu">
            <!-- Enlace a la página de inicio -->
            <router-link class="button" to="/Inicio">
                <span class="material-icons">home</span>
                <span class="text">Inicio</span>
            </router-link>

            <!-- Enlace a la sección de dispositivos del usuario -->
            <router-link class="button" to="/mis-dispositivos">
                <span class="material-icons">devices</span>
                <span class="text">Mis Dispositivos</span>
            </router-link>

            <!-- Enlace a información sobre la aplicación -->
            <router-link class="button" to="/estadisticas">
                <span class="material-icons">description</span>
                <span class="text">Estadisticas</span>
            </router-link>

            <!-- Enlace duplicado - necesita corrección -->
            <router-link class="button" to="/Consejos-de-Ahorro">
                <span class="material-icons">group</span>
                <span class="text">Consejos de Ahorro</span>
            </router-link>

            <!-- Enlace duplicado - necesita corrección -->
            <router-link class="button" to="/Acerca-de">
                <span class="material-icons">dehaze</span>
                <span class="text">Acerca de la app</span>
            </router-link>
        </nav>
    </aside>
</template>

<script setup>
// Importación de la función reactiva de Vue
import { ref } from 'vue'

/**
 * Estado reactivo que controla si el sidebar está expandido o contraído
 * @type {Ref<boolean>}
 */
const is_expanded = ref(false)

/**
 * Función para alternar el estado de expansión del sidebar
 * Cambia el valor de is_expanded entre true y false
 */
const ToggleMenu = () => {
    is_expanded.value = !is_expanded.value
}
</script>
    
<style lang="scss" scoped>
    /* ===========================================
       CONTENEDOR PRINCIPAL DEL SIDEBAR
       =========================================== */
		aside {
			/* Layout flexbox vertical para organizar elementos */
			display: flex;
			flex-direction: column;
			
			/* Colores de fondo y texto */
			background-color: var(--dark);
			color: var(--light);
			
			/* Ancho inicial del sidebar (contraído) */
			width: calc(2rem + 32px);
			
			/* Ocultar contenido que se desborde */
			overflow: hidden;
			
			/* Altura mínima de toda la pantalla */
			min-height: 100vh;
			
			/* Espaciado interno */
			padding: 1rem;
			
			/* Transición suave para el cambio de ancho */
			transition: width 0.2s ease-in-out;
			
			/* Posicionamiento estático por defecto */
			position: static;

			/* Estado expandido del sidebar */
			&.is-expanded {
				width: var(--sidebar-width);
			}

			/* ===========================================
			   RESPONSIVE DESIGN - TABLETS
			   =========================================== */
			@media (max-width: 1024px) {
				/* En tablets, el sidebar se vuelve fijo */
				position: fixed;
				top: 0;
				left: 0;
				z-index: 99;
				height: 100vh;
				width: calc(2rem + 32px);
				
				/* Estado expandido en tablets */
				&.is-expanded {
					width: var(--sidebar-width);
					/* Sombra para dar profundidad */
					box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
				}
			}
			
			/* ===========================================
			   RESPONSIVE DESIGN - MÓVILES GRANDES
			   =========================================== */
			@media (max-width: 768px) {
				&.is-expanded {
					width: 280px;
				}
			}
			
			/* ===========================================
			   RESPONSIVE DESIGN - MÓVILES PEQUEÑOS
			   =========================================== */
			@media (max-width: 480px) {
				&.is-expanded {
					/* En móviles pequeños, ocupa toda la pantalla */
					width: 100vw;
				}
			}
			/* ===========================================
			   ELEMENTOS FLEXIBLES
			   =========================================== */
			.flex {
				/* Permite que el elemento crezca y se contraiga */
				flex: 1 1 0%;
			}

			/* ===========================================
			   LOGO DEL SIDEBAR
			   =========================================== */
			.logo {
				/* Espacio inferior para separar del siguiente elemento */
				margin-bottom: 1rem;

				img {
					/* Tamaño fijo para el logo */
					width: 2rem;
				}
			}

			/* ===========================================
			   BOTÓN DE TOGGLE (EXPANDIR/CONTRAR)
			   =========================================== */
			.menu-toggle-wrap {
				/* Layout flexbox para alinear el botón a la derecha */
				display: flex;
				justify-content: flex-end;
				margin-bottom: 1rem;

				/* Posicionamiento relativo para animaciones */
				position: relative;
				top: 0;
				transition: 0.2s ease-in-out;

				.menu-toggle {
					/* Transición suave para el botón */
					transition: 0.2s ease-in-out;
					
					.material-icons {
						/* Estilos para el icono de doble flecha */
						font-size: 2rem;
						color: var(--light);
						transition: 0.2s ease-out;
					}
					
					/* Efecto hover: cambia color y se mueve */
					&:hover {
						.material-icons {
							color: var(--primary);
							transform: translateX(0.5rem);
						}
					}
				}
			}

			/* ===========================================
			   TÍTULO Y TEXTO DE LOS BOTONES
			   =========================================== */
			h3, .button .text {
				/* Inicialmente ocultos (se muestran al expandir) */
				opacity: 0;
				transition: opacity 0.3s ease-in-out;
			}

			h3 {
				/* Estilos para el título "Menu" */
				color: var(--grey);
				font-size: 0.875rem;
				margin-bottom: 0.5rem;
				text-transform: uppercase;
			}

			/* ===========================================
			   MENÚ DE NAVEGACIÓN
			   =========================================== */
			.menu {
				/* Margen negativo para que los botones toquen los bordes */
				margin: 0 -1rem;

				.button {
					/* Layout flexbox para alinear icono y texto */
					display: flex;
					align-items: center;
					text-decoration: none;

					/* Transición suave para todos los cambios */
					transition: 0.2s ease-in-out;
					padding: 0.5rem 1rem;

					.material-icons {
						/* Estilos para los iconos de Material Design */
						font-size: 2rem;
						color: var(--light);
						transition: 0.2s ease-in-out;
					}
					
					.text {
						/* Estilos para el texto de los botones */
						color: var(--light);
						transition: 0.2s ease-in-out;
					}

					/* Efecto hover: cambia fondo y colores */
					&:hover {
						background-color: var(--dark-alt);

						.material-icons, .text {
							color: var(--primary);
						}
					}

					/* Estado activo: indica la página actual */
					&.router-link-exact-active {
						background-color: var(--dark-alt);
						border-right: 5px solid var(--primary);

						.material-icons, .text {
							color: var(--primary);
						}
					}
				}
			}

			/* ===========================================
			   FOOTER (NO UTILIZADO ACTUALMENTE)
			   =========================================== */
			.footer {
				/* Oculto por defecto */
				opacity: 0;
				transition: opacity 0.3s ease-in-out;

				p {
					font-size: 0.875rem;
					color: var(--grey);
				}
			}

			/* ===========================================
			   ESTADOS ESPECIALES DEL SIDEBAR EXPANDIDO
			   =========================================== */
			&.is-expanded {
				/* Ancho completo cuando está expandido */
				width: var(--sidebar-width);

				.menu-toggle-wrap {
					/* Mueve el botón hacia arriba */
					top: -3rem;
					
					.menu-toggle {
						/* Rota el icono 180 grados */
						transform: rotate(-180deg);
					}
				}

				/* Muestra el título y texto de los botones */
				h3, .button .text {
					opacity: 1;
				}

				.button {
					.material-icons {
						/* Añade margen derecho para separar icono del texto */
						margin-right: 1rem;
					}
				}

				.footer {
					/* Mantiene el footer oculto */
					opacity: 0;
				}
			}

			/* ===========================================
			   RESPONSIVE ESPECÍFICO
			   =========================================== */
			@media (max-width: 1024px) {
				/* En tablets, posicionamiento absoluto */
				position: absolute;
				z-index: 99;
			}
		}
	
</style>
