<template>
  <section>
    <header class="header-nuevo">
      <h1>Agregar dispositivo</h1>
      <router-link to="/Inicio" class="volver-inicio-btn">
        <span class="material-icons">arrow_back</span>
        Volver al inicio
      </router-link>
    </header>
    <br>
    <!-- Componente Buscador -->
    <Buscador v-model="searchQuery" placeholder="Buscar dispositivo..." />
    <!-- Mostrar resultados filtrados -->
    <section class="navegador">
    <article v-for="(categoria, idx) in filteredCategorias" :key="idx" class="buscador">
      <br></br>
      <article class="cards">
        <Card
          v-for="(card, i) in categoria.cards"
          :key="i"
          :title="card.title"
          :description="card.description"
          :image="card.image"
          :background-color1="card.backgroundColor1"
          :background-color2="card.backgroundColor2"
          buttonText="Agregar"
        />
      </article>
    </article>
     </section>
    
    <footer class="footer-agregar">
      <button class="agregar-no-registrado" @click="abrirFormulario">
        Agregar dispositivo no registrado
      </button>
    </footer>
    <!-- Formulario modal -->
    <Formulario
      :visible="showForm"
      :categorias="categorias.map(c => c.name)"
      @close="cerrarFormulario"
      @submit="agregarDispositivo"
    />
  </section>
</template>

<script>
import Buscador from "../components/Buscador.vue"
import Card from "../components/Card.vue"
import Formulario from "../components/formulario.vue"
import Refrigerador from "../assets/refrigerator.png"
import Tv from "../assets/tv.png"
import Lavadora from "../assets/lavadora.png"
import Aire from "../assets/aire.png"
import Plancha from "../assets/plancha.png"
export default {
  // Cambiar primero la categoria para que con base en la categoria se muestren los dispositivos
  name: "NuevoDispositivo",
  components: { Buscador, Card, Formulario },
  data() {
    return {
      searchQuery: "",
      categorias: [
        {
          name: "Electrodomésticos",
          cards: [
            { title:"Refrigerador", description: "Frío y eficiente", image: Refrigerador, backgroundColor1:"#3CB300",backgroundColor2:"#46D100"},
            {title:"Television", description:"Descripcion de la Television", image:Tv, backgroundColor1:"#005CB3", backgroundColor2:"#0084FF"},
            {title:"Lavadora", description:"Descripcion de la lavadora", image:Lavadora, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},
            {title:"Aire acondicionado", description:"Descripcion del aire acondicionado", image:Aire, backgroundColor1:"#3CB300", backgroundColor2:"#46D100"},
            {title:"Plancha", description:"Descripcion de la plancha", image:Plancha, backgroundColor1:"#B31C00", backgroundColor2:"#FF2B00"},          
            ]
        }
      ],
      showForm: false,
    }
  },
  computed: {
    filteredCategorias() {
      const q = this.searchQuery.toLowerCase().trim()
      if (!q) return this.categorias
      return this.categorias
        .map(cat => {
          const filteredCards = cat.cards.filter(
            card =>
              card.title.toLowerCase().includes(q) ||
              card.description.toLowerCase().includes(q)
          )
          return { ...cat, cards: filteredCards }
        })
        .filter(cat => cat.cards.length > 0)
    }
  },
  methods: {
    abrirFormulario() {
      this.showForm = true;
    },
    cerrarFormulario() {
      this.showForm = false;
    },
    agregarDispositivo(dispositivo) {
      // Aquí puedes agregar el dispositivo a la lista si lo deseas
      this.cerrarFormulario();
    }
  }
}
</script>
<style>
    .header-nuevo {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 1.5rem;
    }
    .volver-inicio-btn {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      background: var(--primary, #4ec145);
      color: #fff;
      border: none;
      border-radius: 0.5rem;
      padding: 0.5rem 1rem;
      font-size: 1rem;
      text-decoration: none;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: background 0.2s;
    }
    .volver-inicio-btn:hover {
      background: #3ea832;
      
    }
    .volver-inicio-btn .material-icons {
      font-size: 1.2rem;
      
    }
    .card{
        margin-bottom: 5px;
    }
    .footer-agregar {
      display: flex;
      justify-content: flex-start;
      margin-top: 2rem;
      margin-bottom: 2rem;
      
    }
    .agregar-no-registrado {
      background: var(--primary, #4ec145);
      color: #fff;
      border: none;
      border-radius: 0.5rem;
      padding: 0.8rem 1.5rem;
      font-size: 1.1rem;
      cursor: pointer;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      transition: background 0.2s;
    }
    .agregar-no-registrado:hover {
      background: #3ea832;
    }
</style>