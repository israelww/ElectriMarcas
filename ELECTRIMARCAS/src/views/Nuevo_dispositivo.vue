<template>
  <section>
    <h1>Agregar dispositivo</h1>
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
    
  </section>
</template>

<script>
import Buscador from "../components/Buscador.vue"
import Card from "../components/Card.vue"
import Refrigerador from "../assets/refrigerator.png"
import Tv from "../assets/tv.png"
import Lavadora from "../assets/lavadora.png"
import Aire from "../assets/aire.png"
import Plancha from "../assets/plancha.png"
export default {
  name: "Inicio",
  components: { Buscador, Card },
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
      ]
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
  }
}
</script>
<style>
    .card{
        margin-bottom: 5px;
    }
</style>