<template>
    <section class="estadisticas">
        <h1>Estadísticas de Consumo Energético</h1>
        <p class="descripcion">Visualiza el consumo de tus 5 dispositivos que más energía consumen</p>
        
        <article class="grafica-container">
            <div v-if="isLoading" class="loading-state">
                <div class="spinner"></div>
                <p>Cargando estadísticas... ⏳</p>
            </div>
            
            <div v-else-if="error" class="error-state">
                <div class="error-icon">⚠️</div>
                <p class="error-message">{{ error }}</p>
                <router-link to="/Inicio" class="btn-add-devices">
                    ➕ Agregar dispositivos
                </router-link>
            </div>
            
            <div v-else-if="chartData" class="grafica-wrapper">
                <bar-chart :chartData="chartData" :chartOptions="chartOptions" />
            </div>
            
            <div v-else class="empty-state">
                <p>No se encontraron datos para mostrar.</p>
            </div>
        </article>
    </section>
</template>

<script setup>
    import { ref, onMounted } from 'vue';
    import { getTop5DispositivosConsumo } from '../services/dataService';
    import BarChart from '../components/GraficaBarras.vue'
    
    const chartData = ref(null);
    const isLoading = ref(true);
    const error = ref(null);

    const fetchData = async () => {
        isLoading.value = true;
        error.value = null;
        
        try {
            // Obtener los 5 dispositivos con mayor consumo
            const dispositivos = getTop5DispositivosConsumo();
            
            if (!dispositivos || dispositivos.length === 0) {
                error.value = 'No hay dispositivos configurados. Agrega dispositivos en la página de Inicio para ver estadísticas.';
                chartData.value = null;
                return;
            }
            
            // Preparar los datos para la gráfica
            const labels = dispositivos.map(d => d.nombre);
            const consumoDiario = dispositivos.map(d => d.consumoDiario);
            const consumoSemanal = dispositivos.map(d => d.consumoSemanal);
            const consumoMensual = dispositivos.map(d => d.consumoMensual);
            
            // Formato compatible con Chart.js
            chartData.value = {
                labels: labels,
                datasets: [
                    {
                        label: 'Consumo Diario (kWh)',
                        data: consumoDiario,
                        backgroundColor: 'rgba(59, 130, 246, 0.7)',
                        borderColor: 'rgba(59, 130, 246, 1)',
                        borderWidth: 2
                    },
                    {
                        label: 'Consumo Semanal (kWh)',
                        data: consumoSemanal,
                        backgroundColor: 'rgba(34, 197, 94, 0.7)',
                        borderColor: 'rgba(34, 197, 94, 1)',
                        borderWidth: 2
                    },
                    {
                        label: 'Consumo Mensual (kWh)',
                        data: consumoMensual,
                        backgroundColor: 'rgba(239, 68, 68, 0.7)',
                        borderColor: 'rgba(239, 68, 68, 1)',
                        borderWidth: 2
                    }
                ]
            };
            
        } catch (err) {
            error.value = err.message || 'Ocurrió un error al cargar la gráfica.';
            chartData.value = null;
        } finally {
            isLoading.value = false;
        }
    };
    
    onMounted(fetchData);
    
    // Opciones de la gráfica
   const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'top',
      labels: {
        color: '#000000', // ← color de texto en la leyenda
        font: {
          size: 12
        },
        padding: 15
      }
    },
    title: {
      display: true,
      text: 'Top 5 Dispositivos con Mayor Consumo Eléctrico',
      color: '#0f172a', // ← color del título general
      font: {
        size: 18,
        weight: 'bold'
      },
      padding: {
        top: 10,
        bottom: 20
      }
    },
    tooltip: {
      callbacks: {
        label: function(context) {
          let label = context.dataset.label || '';
          if (label) label += ': ';
          label += context.parsed.y.toFixed(2) + ' kWh';
          return label;
        }
      }
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      title: {
        display: true,
        text: 'Consumo Energético (kWh)',
        color: '#1e293b', // ← color del título del eje Y
        font: {
          size: 14,
          weight: 'bold'
        },
        padding: {
        bottom: 25   // separa el título de los números (aumenta o reduce este valor)
        }
      },
      ticks: {
        color: '#1e293b', // ← color de los números del eje Y
        callback: function(value) {
          return value.toFixed(1) + ' kWh';
        }
      },
      grid: {
        color: 'rgba(0,0,0,0.1)'
      }
    },
    x: {
      title: {
        display: true,
        text: 'Dispositivos',
        color: '#1e293b', // ← color del título del eje X
        font: {
          size: 14,
          weight: 'bold'
        }
      },
      ticks: {
        color: '#1e293b', // 🎯 ← AQUÍ se cambia el color de los nombres de los electrodomésticos
        maxRotation: 45,
        minRotation: 45,
        font: {
          size: 13,
        //   weight: '600'
        }
      },
      grid: {
        color: 'rgba(0,0,0,0.05)'
      }
    }
  }
};

</script>

<style scoped>
.estadisticas {
    padding: 2rem;
    max-width: 1400px;
    margin: 0 auto;
}

.estadisticas h1 {
    color: #2c3e50;
    font-size: 2rem;
    margin-bottom: 0.5rem;
    text-align: left;
}

.descripcion {
    color: #666;
    font-size: 1.1rem;
    margin-bottom: 2rem;
    text-align: left;
}

.grafica-container {
    background: #fff;
    border-radius: 1rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    padding: 2rem;
    min-height: 550px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.grafica-wrapper {
    width: 100%;
    height: 550px;
}

/* Loading state */
.loading-state {
    text-align: center;
    color: #666;
}

.spinner {
    border: 4px solid #f3f3f3;
    border-top: 4px solid var(--primary, #4CAF50);
    border-radius: 50%;
    width: 50px;
    height: 50px;
    animation: spin 1s linear infinite;
    margin: 0 auto 1.5rem;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.loading-state p {
    font-size: 1.1rem;
}

/* Error state */
.error-state {
    text-align: center;
    padding: 3rem 2rem;
}

.error-icon {
    font-size: 4rem;
    margin-bottom: 1rem;
}

.error-message {
    color: #ef4444;
    font-size: 1.2rem;
    margin-bottom: 2rem;
    line-height: 1.5;
}

.btn-add-devices {
    display: inline-block;
    padding: 1rem 2rem;
    background: linear-gradient(135deg, #4CAF50, #45a049);
    color: white;
    text-decoration: none;
    border-radius: 0.5rem;
    font-weight: 600;
    font-size: 1.1rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
}

.btn-add-devices:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(76, 175, 80, 0.4);
}

/* Empty state */
.empty-state {
    text-align: center;
    color: #666;
    padding: 3rem;
    font-size: 1.1rem;
}

/* Responsive */
@media (max-width: 768px) {
    .estadisticas {
        padding: 1rem;
    }
    
    .estadisticas h1 {
        font-size: 1.5rem;
    }
    
    .descripcion {
        font-size: 1rem;
    }
    
    .grafica-container {
        padding: 1.5rem;
        min-height: 450px;
    }
    
    .grafica-wrapper {
        height: 450px;
    }
    
    .error-icon {
        font-size: 3rem;
    }
    
    .error-message {
        font-size: 1rem;
    }
    
    .btn-add-devices {
        padding: 0.75rem 1.5rem;
        font-size: 1rem;
    }
}

@media (max-width: 480px) {
    .grafica-container {
        padding: 1rem;
        min-height: 400px;
    }
    
    .grafica-wrapper {
        height: 400px;
    }
}
</style>