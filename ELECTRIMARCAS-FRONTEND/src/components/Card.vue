<template>
  <section class="card":style="{background: `linear-gradient(to right, ${backgroundColor1}, ${backgroundColor2} )` }">
    <article class="card-imagen">
        <img v-if="image" :src="image" alt="Card Image" class="card-image" />
    </article>
    <article class="card-content">
      <h2 class="card-title">{{ title }}</h2>
      <p class="card-description">{{ description }}</p>
    </article>
    <section class="card-actions">
        <article class="card-boton">
            <button @click="$emit('eliminar')">{{ buttonText }}</button>
        </article>
    </section>
  </section>
</template>

<script>
export default {
  name: "Card",
  props: {
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    modelo: {
      type: String,
      required: true
    },
    image: {
      type: String,
      default: ""
    },
    buttonText: {
      type: String,
      default: "Eliminar"
    },
    backgroundColor1:{
        type:String,
        default:"black"
    },
    backgroundColor2:{
        type:String,
        default:"white"
    }
  }
};
</script>

<style scoped>
.card {
  border-radius: 10px;
  width: 100%;
  padding: 16px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  transition: transform 0.2s;
  display: flex;
  max-width: 700px;
  
}

.card-imagen{
    flex: 0 0 80px;
    max-width: 200px;
    padding: 10px;
    background-color: white;
    border-radius: 10px;
}

.card-content{
    
    width: 81%;
    margin-left: 1em;

}   

.card:hover {
  transform: scale(1.05);
}

.card-image {
  width: 100%;
  border-radius: 10px;
}
.card-title {
  font-size: 1.2rem;
  margin-top: 20px;
  margin-bottom: 2px;
  color: white;
}
.card-description {
  font-size: 0.9rem;
  color: white;

}
.card-actions {
  margin-top: 15px;
  text-align: right;
}
button {
  padding: 6px 12px;
  margin-top: 10%;
  border: none;
  background-color: white;
  color: black;
  border-radius: 5px;
  cursor: pointer;
}
button:hover {
  background-color: #f3f1f1;
  color: red;
}
</style>
