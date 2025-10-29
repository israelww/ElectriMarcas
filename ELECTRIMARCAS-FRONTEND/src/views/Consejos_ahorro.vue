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
        
        <!-- Sección de dispositivos que más consumen -->
        <section v-if="dispositivosAltoConsumo.length > 0" class="alto-consumo-section">
            <h2 class="section-title">💡 Dispositivos que más consumen energía</h2>
            <p class="section-description">Estos son tus dispositivos con mayor consumo. Aplica estos consejos para reducir tu factura:</p>
            <div class="dispositivos-consumo-lista">
                <article 
                    v-for="(disp, idx) in dispositivosAltoConsumo" 
                    :key="idx"
                    class="dispositivo-consumo-card"
                    :class="disp.nivelConsumo"
                >
                    <div class="consumo-header">
                        <h3 class="dispositivo-nombre">{{ disp.title }}</h3>
                        <span class="consumo-badge" :class="disp.nivelConsumo">
                            {{ disp.consumoDiario.toFixed(2) }} kWh/día
                        </span>
                    </div>
                    <div class="consumo-info">
                        <p class="consumo-datos">
                            <strong>Potencia:</strong> {{ disp.potencia }}W | 
                            <strong>Uso diario:</strong> {{ disp.horasUsoPorDia }}h | 
                            <strong>Días/semana:</strong> {{ disp.diasUsoPorSemana }}
                        </p>
                        <div class="consumo-mensual">
                            <strong>Consumo mensual estimado:</strong> {{ disp.consumoMensual.toFixed(2) }} kWh
                        </div>
                    </div>
                    <div class="consejo-personalizado">
                        <strong>💡 Consejo:</strong> {{ disp.consejo }}
                    </div>
                </article>
            </div>
        </section>
        
        <!-- Sección de consejos generales -->
        <section class="consejos-lista">
            <h2 class="section-title">Consejos generales de ahorro</h2>
            <article class="cards">
                <Card
                v-for="c in consejosCards"
                :key="c.id"
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
import { getConsumoResumen } from '../services/dataService.js';
   
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
            'Muchos dispositivos en "stand by" (televisión, consolas, cargadores) siguen consumiendo energía.',
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
      dispositivosAltoConsumo: []
    };
  },
  computed: {
    consejosCards() {
      return this.consejos.map(c => ({
        id: c.id,
        title: c.titulo,
        description: c.descripcion,
        backgroundColor1: c.color1,
        backgroundColor2: c.color2,
      }));
    },
  },
  mounted() {
    this.cargarDispositivosAltoConsumo();
  },
  methods: {
    verDetalle(c) {
      console.log('Tip seleccionado:', c.title);
    },
    cargarDispositivosAltoConsumo() {
      try {
        // Intentar obtener desde localStorage (datos guardados con ConfigDeviceModal)
        const saved = localStorage.getItem('categoriasCards');
        if (!saved) {
          // También intentar desde sessionStorage (dispositivos agregados recientemente)
          const sessionData = sessionStorage.getItem('selectedDevices');
          if (sessionData) {
            const { cards } = JSON.parse(sessionData);
            this.procesarDispositivos(cards);
          }
          return;
        }
        
        const map = JSON.parse(saved);
        const allDevices = [];
        
        // Recolectar todos los dispositivos de todas las categorías
        Object.values(map || {}).forEach(arr => {
          if (Array.isArray(arr)) {
            arr.forEach(d => {
              if (d && d.title) {
                allDevices.push(d);
              }
            });
          }
        });
        
        this.procesarDispositivos(allDevices);
      } catch (error) {
        console.error('Error al cargar dispositivos de alto consumo:', error);
      }
    },
    procesarDispositivos(devices) {
      if (!Array.isArray(devices) || devices.length === 0) return;
      
      const dispositivosConConsumo = devices
        .map(device => {
          const cantidad = device.cantidad ?? 1;
          const horas = device.horasUsoPorDia ?? 1;
          const diasSemana = device.diasUsoPorSemana ?? 7;
          const potencia = device.potencia ?? this.extraerPotencia(device.description) ?? 0;
          
          const consumoDiario = (potencia * horas * cantidad) / 1000; // kWh
          const consumoMensual = consumoDiario * 30;
          
          return {
            title: device.title,
            potencia,
            horasUsoPorDia: horas,
            diasUsoPorSemana: diasSemana,
            cantidad,
            consumoDiario,
            consumoMensual,
            nivelConsumo: this.obtenerNivelConsumo(consumoDiario),
            consejo: this.generarConsejo(device.title, consumoDiario, potencia, horas)
          };
        })
        .filter(d => d.consumoDiario > 0)
        .sort((a, b) => b.consumoDiario - a.consumoDiario)
        .slice(0, 5); // Top 5 dispositivos que más consumen
      
      this.dispositivosAltoConsumo = dispositivosConConsumo;
    },
    extraerPotencia(description) {
      if (!description || typeof description !== 'string') return null;
      const match = description.match(/(\d+)\s*W/i) || description.match(/Potencia:\s*(\d+)/i);
      return match ? parseInt(match[1]) : null;
    },
    obtenerNivelConsumo(consumoDiario) {
      if (consumoDiario > 10) return 'muy-alto';
      if (consumoDiario > 5) return 'alto';
      if (consumoDiario > 2) return 'medio';
      return 'bajo';
    },
    generarConsejo(nombre, consumoDiario, potencia, horas) {
      const nombreLower = nombre.toLowerCase();
      
      // Consejos específicos por tipo de dispositivo
      if (nombreLower.includes('refrigerador') || nombreLower.includes('refrigeradora')) {
        if (consumoDiario > 5) {
          return 'Considera revisar el sello de la puerta y ajustar la temperatura a 4-5°C. Evita abrir la puerta frecuentemente.';
        }
        return 'Mantén la puerta cerrada y verifica que el sello esté en buen estado.';
      }
      
      if (nombreLower.includes('aire') || nombreLower.includes('climatiz')) {
        if (consumoDiario > 8) {
          return 'Usa el modo ventilador cuando sea posible y mantén la temperatura en 24-26°C. Cierra ventanas y puertas mientras esté encendido.';
        }
        return 'Ajusta la temperatura a 24-26°C y limpia los filtros regularmente.';
      }
      
      if (nombreLower.includes('lavadora')) {
        if (consumoDiario > 3) {
          return 'Usa siempre cargas completas y elige ciclos de agua fría cuando sea posible. Reduce la frecuencia de uso si es posible.';
        }
        return 'Usa cargas completas y programas de lavado eficientes.';
      }
      
      if (nombreLower.includes('televisor') || nombreLower.includes('tv')) {
        if (horas > 8) {
          return 'Reduce las horas de uso diario. Activa el modo de ahorro de energía y apágalo cuando no estés viéndolo.';
        }
        return 'Desconéctalo cuando no lo uses y activa el modo de ahorro de energía.';
      }
      
      if (nombreLower.includes('plancha')) {
        return 'Úsala solo cuando tengas suficiente ropa para planchar. Desconéctala inmediatamente después de usar.';
      }
      
      // Consejos generales basados en consumo
      if (consumoDiario > 10) {
        return `Este dispositivo consume mucha energía (${consumoDiario.toFixed(2)} kWh/día). Considera reducir las horas de uso o buscar una alternativa más eficiente.`;
      }
      
      if (consumoDiario > 5) {
        return `Modera el uso de este dispositivo. Cada hora adicional representa ${(potencia/1000).toFixed(2)} kWh más en tu factura.`;
      }
      
      if (horas > 12) {
        return 'Este dispositivo está encendido muchas horas al día. Considera apagarlo cuando no sea necesario.';
      }
      
      return 'Asegúrate de desconectarlo cuando no lo estés usando para evitar consumo en modo stand-by.';
    }
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
    max-width: 900px;
    width: 100%;
    padding: 2rem;
    text-align: left;
}

.section-title {
    font-size: 1.5rem;
    font-weight: 700;
    color: #2c3e50;
    margin-top: 2rem;
    margin-bottom: 0.5rem;
}

.section-description {
    font-size: 1rem;
    color: #555;
    margin-bottom: 1.5rem;
}

.alto-consumo-section {
    margin-bottom: 3rem;
    padding: 1.5rem;
    background: #f8f9fa;
    border-radius: 1rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.dispositivos-consumo-lista {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.dispositivo-consumo-card {
    background: #fff;
    border-radius: 0.75rem;
    padding: 1.25rem;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    transition: box-shadow 0.2s;
    border-left: 4px solid #4ec145;
}

.dispositivo-consumo-card:hover {
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
}

.dispositivo-consumo-card.muy-alto {
    border-left-color: #ef4444;
}

.dispositivo-consumo-card.alto {
    border-left-color: #f59e0b;
}

.dispositivo-consumo-card.medio {
    border-left-color: #3b82f6;
}

.dispositivo-consumo-card.bajo {
    border-left-color: #22c55e;
}

.consumo-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.75rem;
}

.dispositivo-nombre {
    font-size: 1.2rem;
    font-weight: 700;
    color: #2c3e50;
    margin: 0;
}

.consumo-badge {
    padding: 0.4rem 0.8rem;
    border-radius: 0.5rem;
    font-weight: 600;
    font-size: 0.9rem;
    color: #fff;
}

.consumo-badge.muy-alto {
    background: linear-gradient(135deg, #ef4444, #dc2626);
}

.consumo-badge.alto {
    background: linear-gradient(135deg, #f59e0b, #d97706);
}

.consumo-badge.medio {
    background: linear-gradient(135deg, #3b82f6, #2563eb);
}

.consumo-badge.bajo {
    background: linear-gradient(135deg, #22c55e, #16a34a);
}

.consumo-info {
    margin-bottom: 0.75rem;
}

.consumo-datos {
    font-size: 0.9rem;
    color: #666;
    margin: 0.25rem 0;
}

.consumo-mensual {
    font-size: 0.95rem;
    color: #2c3e50;
    margin-top: 0.5rem;
}

.consejo-personalizado {
    background: #fff7ed;
    border-left: 3px solid #f59e0b;
    padding: 0.75rem;
    border-radius: 0.5rem;
    font-size: 0.95rem;
    line-height: 1.5;
    color: #431407;
    margin-top: 0.75rem;
}

.consejo-personalizado strong {
    color: #d97706;
}

.consejos-lista {
    display: flex;
    flex-direction: column;
    align-items: left;
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

@media (max-width: 768px) {
    .consumo-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 0.5rem;
    }
    
    .dispositivo-consumo-card {
        padding: 1rem;
    }
}
</style>