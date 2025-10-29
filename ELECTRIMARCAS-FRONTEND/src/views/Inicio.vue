<script>
// Componente de vista de categorías de electrodomésticos.
// Falta hacer un panel a la izquierda en añadir dispositivo que acumule los dispositivos añadidos y al dar click en guardar
// se añadan todos a la categoría correspondiente y con sus respectivos datos (voltaje, potencia, etc.)
import Card from '../components/Card.vue'
import Formulario from '../components/formulario.vue'
// import { getDispositivosList } from '../services/dataService.js'
// import Refrigerador from '../assets/refrigerator.png' 
// import Lavadora from '../assets/lavadora.png'
// import Tv from '../assets/tv.png'
// import Aire from '../assets/aire.png'
// import Plancha from '../assets/plancha.png'

export default {
    name: 'Inicio',
    components: { Card, Formulario },
    data() {
        return {
            categorias: [
                {
                    id: 1,
                    nombre: 'Cocina',
                    descripcion: 'Electrodomésticos para cocinar y preparar alimentos.',
                    cards:[
                        // {title:"Refrigerador", description:"Descripcion del refrigerador", image:Refrigerador, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        // {title:"Refrigerador 2", description:"Descripcion del refrigerador", image:Refrigerador,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        // {title:"Refrigerador 3", description:"Descripcion del refrigerador", image:Refrigerador,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 2,
                    nombre: 'Limpieza',
                    descripcion: 'Aparatos para limpieza del hogar y ropa.',
                    cards:[
                        // {title:"Lavadora", description:"Descripcion de la lavadora", image:Lavadora, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        // {title:"Lavadora 2", description:"Descripcion de la lavadora", image:Lavadora,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        // {title:"Lavadora 3", description:"Descripcion de la lavadora", image:Lavadora,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 3,
                    nombre: 'Entretenimiento',
                    descripcion: 'Dispositivos para ocio y entretenimiento.',
                    cards:[
                        // {title:"Television", description:"Descripcion de la Television", image:Tv, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        // {title:"Television 2", description:"Descripcion de la Television", image:Tv,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        // {title:"Television 3", description:"Descripcion de la Television", image:Tv,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 4,
                    nombre: 'Climatización',
                    descripcion: 'Equipos para regular la temperatura y el ambiente.',
                    cards:[
                        // {title:"Aire acondicionado", description:"Descripcion del aire acondicionado", image:Aire, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        // {title:"Aire acondicionado 2", description:"Descripcion del aire acondicionado", image:Aire,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        // {title:"Aire acondicionado 3", description:"Descripcion del aire acondicionado", image:Aire,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 5,
                    nombre: 'Cuidado Personal',
                    descripcion: 'Electrodomésticos para el cuidado y bienestar personal.',
                    cards:[
                    //     {title:"Plancha", description:"Descripcion de la plancha", image:Plancha, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                    //     {title:"Plancha 2", description:"Descripcion de la plancha", image:Plancha,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                    //     {title:"Plancha 3", description:"Descripcion de la plancha", image:Plancha,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                // Se pueden agregar más categorías aquí
            ],

            // Estado para mostrar el formulario y categoría seleccionada
            showForm: false,
            categoriaSeleccionada: null,
        };
    },
    async created() {
        // Consumir selección desde Nuevo_dispositivo (sessionStorage)
        try {
            const stored = sessionStorage.getItem('selectedDevice');
            if (stored) {
                const { card, categoriaId } = JSON.parse(stored);
                const categoria = this.categorias.find(c => c.id === categoriaId);
                if (categoria && card) {
                    categoria.cards.push({
                        title: card.title,
                        description: card.description,
                        image: card.image || '',
                        backgroundColor1: card.backgroundColor1,
                        backgroundColor2: card.backgroundColor2,
                        buttonText: "Eliminar"
                    });
                }
                sessionStorage.removeItem('selectedDevice');
            }
        } catch (e) {
            console.error(e);
            sessionStorage.removeItem('selectedDevice');
        }
    },
    methods: {
        removeCard(categoriaId, cardIndex) {
            const categoria = this.categorias.find(c => c.id === categoriaId);
            if (categoria) {
                categoria.cards.splice(cardIndex, 1);
            }
        },
        abrirSelector(categoriaId) {
            // Navega a la pantalla Nuevo_dispositivo con la categoría seleccionada
            this.$router.push({ path: '/Nuevo_dispositivo', query: { categoriaId } });
        },
        cerrarFormulario() {
            this.showForm = false;
            this.categoriaSeleccionada = null;
        },
        agregarDispositivo(dispositivo) {
            // Añade el dispositivo a la categoría seleccionada
            const categoria = this.categorias.find(c => c.id === this.categoriaSeleccionada);
            if (categoria) {
                categoria.cards.push({
                    title: dispositivo.nombre,
                    description: dispositivo.descripcion,
                    image: '', // Puedes pedir imagen en el formulario si lo deseas
                    backgroundColor1: '#B31C00',
                    backgroundColor2: '#FF2B00',
                    voltaje: dispositivo.voltaje,
                    potencia: dispositivo.potencia,
                });
            }
            this.cerrarFormulario();
        },
        // Método para ir a inicio de sesión
        irAInicioSesion() {
            this.$router.push('/Inicio-Sesion');
        },
    },
};
</script>

<template>
    <!--
        Vista de categorías de electrodomésticos.
        Cada categoría se muestra como una tarjeta.
        Los electrodomésticos de cada categoría se cargarán dinámicamente desde la base de datos.
    -->
    <section class="inicio">
        <!-- Botón para ir a inicio de sesión -->
        <!-- <button @click="irAInicioSesion" class="login-test-btn">
            Ir a Inicio de Sesión
        </button> -->

        <h1>Categorías de Electrodomésticos</h1>
        <p>Añade un electrodoméstico a su respectiva categoría con sus datos para su calcular su consumo.</p>
        <nav class="categorias-lista">
            <!-- Lista de categorías fijas -->
            <nav
                v-for="categoria in categorias"
                :key="categoria.id"
                class="categoria-card">
                <h2>{{ categoria.nombre }}</h2>
                <p class="categoria-descripcion">{{ categoria.descripcion }}</p>
                <Card
                    v-for="(card, idx) in categoria.cards"
                    :key="idx"
                    :title="card.title"
                    :description="card.description"
                    :buttonText="card.buttonText"
                    :image="card.image"
                    :backgroundColor1="card.backgroundColor1"
                    :backgroundColor2="card.backgroundColor2"
                    @eliminar="removeCard(categoria.id,idx)"
                />
                <br>
                <button class="add-button" @click="abrirSelector(categoria.id)">
                    <span class="textoBotonAniadir">Añadir dispositivo</span>
                </button>
                <br>
                <!-- Botón para abrir el formulario modal -->

            </nav>
        </nav>
    <!-- Formulario modal -->
    <Formulario
      :visible="showForm"
      :categorias="categorias.map(c => c.nombre)"
      @close="cerrarFormulario"
      @submit="agregarDispositivo"
    />
    </section>
</template>

<style scoped>
/* Botón de prueba para ir a inicio de sesión */
.login-test-btn {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 0.75rem 1.25rem;
    background: linear-gradient(135deg, #66ea9d 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 0.9rem;
    font-weight: 500;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    z-index: 1000;
}

.login-test-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(102, 126, 234, 0.4);
}

/*
    Estilos para la vista de categorías de electrodomésticos.
    .inicio: Contenedor principal de la vista.
    .categorias-lista: Grid de tarjetas de categorías.
    .categoria-card: Tarjeta individual de categoría.
    .categoria-descripcion: Descripción de la categoría.
    .electrodomesticos-placeholder: Espacio reservado para los electrodomésticos.
*/
.inicio {
    padding: 2rem;
}

.categorias-lista {
    display: flex;
    flex-direction: column;
    align-items: flex-start; /* Centra las tarjetas */
    gap: 0;
    margin-top: 2rem;
}

.categoria-card {
    background: #fff;
    border-radius: 1rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    padding: 1.5rem;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    transition: box-shadow 0.2s;
    margin-bottom: 1.5rem;
    max-width: 700px; /* Ancho máximo de la tarjeta */
    width: 100%; /* Que no crezca más allá del contenedor */
}

.categoria-card:last-child {
    margin-bottom: 0;
}

.categoria-card {
    background: #fff;
    border-radius: 1rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    padding: 1.5rem;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    transition: box-shadow 0.2s;
}
.categoria-card:hover {
    box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}

.categoria-card h2 {
    margin: 0 0 0.5rem 0;
    font-size: 1.3rem;
    color: #2c3e50;
}

.categoria-descripcion {
    font-size: 1rem;
    color: #555;
    margin-bottom: 1rem;
}

.card{
    color: white;
    margin-bottom: 1em;
    
}

.electrodomesticos-placeholder {
    font-size: 0.95rem;
    color: #888;
    font-style: italic;
    margin-top: 0.5rem;
}
.add-button {
    background-color: var(--primary);
    border: none;
    border-radius: 0.5rem;
    padding: 0.5rem 1rem;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.2s;
    text-decoration: none;
}

.textoBotonAniadir{
    color: white;
}


/* Responsive para el botón */
@media (max-width: 768px) {
    .login-test-btn {
        top: 10px;
        right: 10px;
        padding: 0.5rem 1rem;
        font-size: 0.8rem;
    }
}

@media (max-width: 480px) {
    .login-test-btn {
        position: static;
        margin: 0 auto 1rem auto;
        display: block;
        width: fit-content;
    }
}
</style>