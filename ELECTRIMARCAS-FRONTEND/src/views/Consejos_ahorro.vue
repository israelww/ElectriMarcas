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
        <section class="consejos-lista">
        <article class="cards">
            <Card
            v-for="c in consejosCards"
            :title="c.title"
            :description="c.description"
            :background-color1="c.backgroundColor1"
            :background-color2="c.backgroundColor2"
            />
        </article>
        </section>
    </section>
</template>

<script>
//
// Componente de vista de consejos de ahorro energético.
// Los consejos están definidos de forma fija.
// En el futuro podrían cargarse dinámicamente desde la base de datos.
//
import Card from '../components/Card.vue';
   
export default {
  name: 'Consejos',
  components: { Card },
  data() {
    return {
      consejos: [
        {
          id: 1,
          titulo: 'Desconecta los aparatos que no uses.',
          descripcion:
            'Muchos dispositivos en “stand by” (televisión, consolas, cargadores) siguen consumiendo energía.',
          color1: '#ef4444',
          color2: '#dc2626',
        },
        {
          id: 2,
          titulo: 'Evita abrir y cerrar mucho el refrigerador.',
          descripcion: 'Cada vez que lo abres, el motor trabaja más para enfriarlo.',
          color1: '#3b82f6',
          color2: '#0ea5e9',
        },
        {
          id: 3,
          titulo: 'Usa lavadoras solo con carga completa.',
          descripcion: 'Evita el desperdicio de agua y energía lavando pocas prendas por carga.',
          color1: '#34d399',
          color2: '#22c55e',
        },
      ],
    };
  },
  computed: {
    consejosCards() {
      return this.consejos.map(c => ({
        title: c.titulo,
        description: c.descripcion,
        backgroundColor1: c.color1,
        backgroundColor2: c.color2,
      }));
    },
  },
  methods: {
    verDetalle(c) {
      console.log('Tip seleccionado:', c.title);
    },
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
    max-width: 750px;
    width: 100%;
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