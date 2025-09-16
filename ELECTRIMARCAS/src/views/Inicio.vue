
<script>
//
// Componente de vista de categorías de electrodomésticos.
// Las categorías están definidas de forma fija.
// Los electrodomésticos se cargarán dinámicamente desde la base de datos en el futuro.
//
export default {
    name: 'Inicio',
    data() {
        return {
            // Lista fija de categorías de electrodomésticos
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
                },
                {
                    id: 4,
                    nombre: 'Climatización',
                    descripcion: 'Equipos para regular la temperatura y el ambiente.',
                },
                {
                    id: 5,
                    nombre: 'Cuidado Personal',
                    descripcion: 'Electrodomésticos para el cuidado y bienestar personal.',
                },
                // Se pueden agregar más categorías aquí
            ],
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
                <p class="categoria-descripcion">{{ categoria.descripcion }}</p><br>
                <!--
                    Aquí se mostrarán los electrodomésticos de la categoría,
                    obtenidos desde la base de datos en el futuro.
                -->
                <nav class="electrodomesticos-placeholder">
                    <em>Electrodomésticos de esta categoría se cargarán aquí.</em>
                </nav>
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