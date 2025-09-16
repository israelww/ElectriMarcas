<template>
    <!--
        Vista de consejos de ahorro energético.
        Cada consejo se muestra como una tarjeta con su color e ícono.
    -->
    <section class="consejos">
        <h1>Consejos de ahorro</h1>
        <p> Estos consejos te ayudarán a reducir el consumo de energía en tu hogar, 
            ahorrar dinero en tus recibos de luz y contribuir al cuidado del medio ambiente.</p>
        <nav class="consejos-info">Estos consejos se irán modificando dependiendo en el consumo que realices con los electrodomésticos usados.</nav>
        <nav class="consejos-lista">
            <!-- Lista de consejos -->
            <nav
                v-for="consejo in consejos"
                :key="consejo.id"
                class="consejo-card"
                :style="{ background: consejo.color }"
            >
                <h2>
                    <span class="consejo-icon">{{ consejo.icono }}</span>
                    {{ consejo.titulo }}
                </h2>
                <p class="consejo-descripcion">{{ consejo.descripcion }}</p>
            </nav>
        </nav>
    </section>
</template>

<script>
//
// Componente de vista de consejos de ahorro energético.
// Los consejos están definidos de forma fija.
// En el futuro podrían cargarse dinámicamente desde la base de datos.
//
export default {
    name: 'Consejos',
    data() {
        return {
            // Lista fija de consejos de ahorro
            consejos: [
                {
                    id: 1,
                    icono: '🔌',
                    titulo: 'Desconecta los aparatos que no uses.',
                    descripcion:
                        'Muchos dispositivos en “stand by” (televisión, consolas, cargadores) siguen consumiendo energía.',
                    color: 'linear-gradient(180deg, #ef4444 0%, #dc2626 100%)',
                },
                {
                    id: 2,
                    icono: '❄️',
                    titulo: 'Evita abrir y cerrar mucho el refrigerador.',
                    descripcion:
                        'Cada vez que lo abres, el motor trabaja más para enfriarlo.',
                    color: 'linear-gradient(180deg, #3b82f6 0%, #0ea5e9 100%)',
                },
                {
                    id: 3,
                    icono: '👕',
                    titulo: 'Usa lavadoras solo con carga completa.',
                    descripcion:
                        'Evita el desperdicio de agua y energía lavando pocas prendas por carga.',
                    color: 'linear-gradient(180deg, #34d399 0%, #22c55e 100%)',
                },
            ],
        };
    },
};
</script>

<style scoped>
/*
    Estilos para la vista de consejos de ahorro.
    .consejos: Contenedor principal.
    .consejos-lista: Grid de tarjetas.
    .consejo-card: Tarjeta individual de cada consejo.
*/
.consejos {
    padding: 2rem;
    text-align: left;
}

.consejos-lista {
    display: flex;
    flex-direction: column;
    align-items: left; /* Alinea las tarjetas a la izquierda */
    gap: 1.2rem;
    margin-top: 1.5rem;
}

.consejo-card {
    border-radius: 1rem;
    padding: 1.5rem;
    color: #fff;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
    max-width: 700px;
    width: 100%;
    transition: box-shadow 0.2s;
}

.consejo-card:hover {
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.18);
}

.consejo-card h2 {
    margin: 0 0 0.5rem 0;
    font-size: 1.2rem;
    font-weight: 700;
    display: flex;
    align-items: left;
    gap: 0.5rem;
}

.consejo-descripcion {
    font-size: 1rem;
    line-height: 1.4;
}
.consejos-info {
    font-size: 0.9rem;
    color: #888;
    font-style: italic;
    margin-top: 0.5rem;
}
</style>