<template>
    <!-- Vista principal de la aplicación -->
    <section class="estadisticas">
        <!-- Título de la página de estadísticas -->
        <h1>Estadísticas</h1>
        <article class="grafica1">
            <div v-if="isLoading">
            Cargando datos... ⏳
            </div>
            <div v-else-if="error">
            <p style="color: red;">¡Error al cargar los datos! {{ error }}</p>
            </div>
            
            <div v-else-if="chartData" style="height: 400px;">
            <bar-chart :chartData="chartData" :chartOptions="chartOptions" />
            </div>
            
            <div v-else>
            <p>No se encontraron datos para la gráfica.</p>
            </div>
        </article>

    </section>
</template>

<script setup   >
    import { ref, onMounted } from 'vue';
    import { getChartData } from '../services/dataService'; // Importar tu función de servicio
    import BarChart from '../components/GraficaBarras.vue'
    const chartData = ref(null);
    const isLoading = ref(true);
    const error = ref(null);

    const fetchData = async () => {
        isLoading.value = true;
        error.value = null; // Limpiar errores anteriores
        
        try {
            // 1. Llama a la función de servicio (la que usa Axios)
            const data = await getChartData();
            // 2. Asigna los datos recibidos a la variable reactiva
            chartData.value = data; 
            
        } catch (err) {
            // 3. Captura el error lanzado por el servicio para mostrarlo al usuario
            error.value = err.message || 'Ocurrió un error desconocido al cargar la gráfica.';
            chartData.value = null;
            
        } finally {
            // 4. Terminar el estado de carga
            isLoading.value = false;
        }
        };
        // 5. Iniciar la carga de datos al montar el componente
        onMounted(fetchData);
        // Opciones de la gráfica (pueden ser estáticas o también cargarse dinámicamente)
        const chartOptions = {
        responsive: true,
        maintainAspectRatio: false
    };
</script>

<style scoped>
.estadisticas {
    padding: 2rem;
}
</style>