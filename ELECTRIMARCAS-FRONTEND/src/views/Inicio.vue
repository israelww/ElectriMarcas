<script>
// Componente de vista de categorías de electrodomésticos.
// Falta hacer un panel a la izquierda en añadir dispositivo que acumule los dispositivos añadidos y al dar click en guardar
// se añadan todos a la categoría correspondiente y con sus respectivos datos (voltaje, potencia, etc.)
import Card from '../components/Card.vue'
import Formulario from '../components/formulario.vue'
import ConfigDeviceModal from '../components/ConfigDeviceModal.vue'
import { getDispositivosList } from '../services/dataService.js'
import Refrigerador from '../assets/refrigerator.png' 
import Lavadora from '../assets/lavadora.png'
import Tv from '../assets/tv.png'
import Aire from '../assets/aire.png'
import Plancha from '../assets/plancha.png'

export default {
    name: 'Inicio',
    components: { Card, Formulario, ConfigDeviceModal },
    data() {
        return {
            categorias: [
                {
                    id: 1,
                    nombre: 'Cocina',
                    descripcion: 'Electrodomésticos para cocinar y preparar alimentos.',


                },
                {
                    id: 2,
                    nombre: 'Limpieza',
                    descripcion: 'Aparatos para limpieza del hogar y ropa.',

                   

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
            showConfig: false,
            configCategoriaId: null,
            configCardIndex: null,
        };
    },
    async created() {
        // 1) Cargar estado persistido por categoría desde localStorage
        try {
            const saved = localStorage.getItem('categoriasCards');
            if (saved) {
                const map = JSON.parse(saved);
                this.categorias.forEach(cat => {
                    cat.cards = Array.isArray(map?.[cat.id]) ? map[cat.id] : [];
                });
            }
        } catch {}

        // 2) Consumir selección desde Nuevo_dispositivo (sessionStorage) - compatible con 1 o muchos
        try {
            const storedMany = sessionStorage.getItem('selectedDevices');
            if (storedMany) {
                const { cards, categoriaId } = JSON.parse(storedMany);
                const categoria = this.categorias.find(c => c.id === categoriaId);
                if (categoria && Array.isArray(cards)) {
                    cards.forEach(card => {
                        const existe = categoria.cards.find(d => d.title === card.title && d.description === card.description);
                        if (!existe) {
                            categoria.cards.push({
                                title: card.title,
                                description: card.description,
                                image: card.image || '',
                                backgroundColor1: card.backgroundColor1,
                                backgroundColor2: card.backgroundColor2
                            });
                        }
                    });
                }
                sessionStorage.removeItem('selectedDevices');
                this.persistCards();
                return;
            }
        } catch {}

        // 3) Compatibilidad con selección de un solo elemento (versión anterior)
        try {
            const stored = sessionStorage.getItem('selectedDevice');
            if (stored) {
                const { card, categoriaId } = JSON.parse(stored);
                const categoria = this.categorias.find(c => c.id === categoriaId);
                if (categoria && card) {
                    const dispositivoExistente = categoria.cards.find(device => 
                        device.title === card.title && device.description === card.description
                    );
                    if (!dispositivoExistente) {
                        categoria.cards.push({
                            title: card.title,
                            description: card.description,
                            image: card.image || '',
                            backgroundColor1: card.backgroundColor1,
                            backgroundColor2: card.backgroundColor2
                        });
                    }
                }
                sessionStorage.removeItem('selectedDevice');
                this.persistCards();
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
                this.persistCards();
            }
        },
        configurarCard(categoriaId, cardIndex) {
            this.configCategoriaId = categoriaId;
            this.configCardIndex = cardIndex;
            this.showConfig = true;
        },
        onSaveConfig(payload) {
            const categoria = this.categorias.find(c => c.id === this.configCategoriaId);
            if (!categoria) { this.showConfig = false; return; }
            const device = categoria.cards[this.configCardIndex];
            if (!device) { this.showConfig = false; return; }
            device.cantidad = Math.max(1, parseInt(payload.cantidad, 10) || 1);
            device.horasUsoPorDia = Math.max(0, parseFloat(payload.horasUsoPorDia) || 0);
            device.diasUsoPorSemana = Math.min(7, Math.max(1, parseInt(payload.diasUsoPorSemana, 10) || 7));
            device.potencia = Math.max(0, parseFloat(payload.potencia) || 0);
            device.consumoDiarioKWh = (device.potencia * device.horasUsoPorDia * device.cantidad) / 1000;
            this.persistCards();
            this.showConfig = false;
        },
        getConsumoResumen() {
            const resumen = { diarioKWh: 0, semanalKWh: 0, mensualKWh: 0, anualKWh: 0 };
            this.categorias.forEach(cat => {
                (cat.cards || []).forEach(d => {
                    const cantidad = d.cantidad ?? 1;
                    const horas = d.horasUsoPorDia ?? 0;
                    const diasSemana = d.diasUsoPorSemana ?? 7;
                    const potencia = d.potencia ?? 0; // W
                    const diario = (potencia * horas * cantidad) / 1000; // kWh
                    resumen.diarioKWh += diario;
                    resumen.semanalKWh += diario * diasSemana;
                    resumen.mensualKWh += diario * 30;
                    resumen.anualKWh += diario * 365;
                });
            });
            return resumen;
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
                // Verificar si el dispositivo ya existe en la categoría para evitar duplicados
                const dispositivoExistente = categoria.cards.find(device => 
                    device.title === dispositivo.nombre && device.description === dispositivo.descripcion
                );
                
                if (!dispositivoExistente) {
                    categoria.cards.push({
                        title: dispositivo.nombre,
                        description: dispositivo.descripcion,
                        image: '', // Puedes pedir imagen en el formulario si lo deseas
                        backgroundColor1: '#B31C00',
                        backgroundColor2: '#FF2B00',
                        voltaje: dispositivo.voltaje,
                        potencia: dispositivo.potencia,
                    });
                    this.persistCards();
                }
            }
            this.cerrarFormulario();
        },
        persistCards() {
            // Persiste solo las tarjetas por categoría
            const map = {};
            this.categorias.forEach(cat => { map[cat.id] = cat.cards; });
            try { localStorage.setItem('categoriasCards', JSON.stringify(map)); } catch {}
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
                <div v-if="categoria.cards.length === 0" class="categoria-vacia">
                    <p>No hay dispositivos agregados en esta categoría.</p>
                </div>
                <Card
                    v-for="(card, idx) in categoria.cards"
                    :key="idx"
                    :title="card.title"
                    :description="card.description"
                    :buttonText="card.buttonText"
                    :image="card.image"
                    :backgroundColor1="card.backgroundColor1"
                    :backgroundColor2="card.backgroundColor2"
                    @configurar="configurarCard(categoria.id, idx)"
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
    <ConfigDeviceModal
      :visible="showConfig"
      :device="configCategoriaId !== null && configCardIndex !== null ? (categorias.find(c=>c.id===configCategoriaId)?.cards?.[configCardIndex] || null) : null"
      @close="showConfig=false"
      @save="onSaveConfig"
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

.categoria-vacia {
    background-color: #f8f9fa;
    border: 2px dashed #dee2e6;
    border-radius: 0.5rem;
    padding: 1rem;
    text-align: center;
    margin: 1rem 0;
}

.categoria-vacia p {
    color: #6c757d;
    font-style: italic;
    margin: 0;
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