
<script>
//
// Componente de vista de categorías de electrodomésticos.
// Las categorías están definidas de forma fija.
// Los electrodomésticos se cargarán dinámicamente desde la base de datos en el futuro.
//
import Card from '../components/Card.vue'
import Refrigerador from '../assets/refrigerator.png' 
import Lavadora from '../assets/lavadora.png'
import Tv from '../assets/tv.png'
import Aire from '../assets/aire.png'
import Plancha from '../assets/plancha.png'
export default {
    name: 'Inicio',
    components:{Card},
    
    data() {
        return {
            // Lista fija de categorías de electrodomésticos
            categorias: [
                {
                    id: 1,
                    nombre: 'Cocina',
                    descripcion: 'Electrodomésticos para cocinar y preparar alimentos.',
                    cards:[
                        {title:"Refrigerador", description:"Descripcion del refrigerador", image:Refrigerador, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        {title:"Refrigerador 2", description:"Descripcion del refrigerador", image:Refrigerador,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        {title:"Refrigerador 3", description:"Descripcion del refrigerador", image:Refrigerador,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 2,
                    nombre: 'Limpieza',
                    descripcion: 'Aparatos para limpieza del hogar y ropa.',
                    cards:[
                        {title:"Lavadora", description:"Descripcion de la lavadora", image:Lavadora, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        {title:"Lavadora 2", description:"Descripcion de la lavadora", image:Lavadora,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        {title:"Lavadora 3", description:"Descripcion de la lavadora", image:Lavadora,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 3,
                    nombre: 'Entretenimiento',
                    descripcion: 'Dispositivos para ocio y entretenimiento.',
                    cards:[
                        {title:"Television", description:"Descripcion de la Television", image:Tv, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        {title:"Television 2", description:"Descripcion de la Television", image:Tv,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        {title:"Television 3", description:"Descripcion de la Television", image:Tv,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 4,
                    nombre: 'Climatización',
                    descripcion: 'Equipos para regular la temperatura y el ambiente.',
                    cards:[
                        {title:"Aire acondicionado", description:"Descripcion del aire acondicionado", image:Aire, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        {title:"Aire acondicionado 2", description:"Descripcion del aire acondicionado", image:Aire,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        {title:"Aire acondicionado 3", description:"Descripcion del aire acondicionado", image:Aire,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                {
                    id: 5,
                    nombre: 'Cuidado Personal',
                    descripcion: 'Electrodomésticos para el cuidado y bienestar personal.',
                    cards:[
                        {title:"Plancha", description:"Descripcion de la plancha", image:Plancha, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
                        {title:"Plancha 2", description:"Descripcion de la plancha", image:Plancha,backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
                        {title:"Plancha 3", description:"Descripcion de la plancha", image:Plancha,backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"}
                    ]
                },
                // Se pueden agregar más categorías aquí
            ],
            methods: {
                removeCard(categoriaId, cardIndex) {
                const categoria = this.categorias.find(c => c.id === categoriaId);
                    if (categoria) {
                    categoria.cards.splice(cardIndex, 1); // elimina la card
                    }
                }
            },
        
        };
        

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
                    @remove="removeCard(categoria.id,idx)"
                />
                <br>
                <input type="button" value="Añadir Electrodoméstico" class="add-button">
            </nav>
            
        </nav>
    </section>
</template>

<style scoped>
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
    color: rgb(26, 25, 25);
    border: none;
    border-radius: 0.5rem;
    padding: 0.5rem 1rem;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.2s;
}

</style>