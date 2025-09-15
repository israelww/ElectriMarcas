<template>
    <!--
        Vista de "Acerca de la App".
        El título y la introducción van fuera de la tarjeta.
        El detalle principal va dentro de una sola card.
    -->
    <main class="Acercade-page">
        <section class="Acercade">
            <h1>Acerca de la App</h1>
            <p>
                Esta aplicación está diseñada para ayudarte a conocer y controlar tu consumo eléctrico en el hogar.
            </p>

            <nav class="Acercade-card">
                <p>
                    Fue creada para facilitar a los usuarios el cálculo del consumo eléctrico de sus aparatos domésticos. 
                    A través de una interfaz sencilla, permite ingresar datos como potencia, tiempo de uso y tarifa eléctrica, 
                    ofreciendo un estimado del consumo en kWh y del costo mensual aproximado.
                </p>
                <p>
                    El objetivo es ayudar a las familias a comprender mejor su gasto energético, identificar los dispositivos 
                    que más consumen y fomentar hábitos de ahorro de energía.
                </p>
                <p class="nota">
                    ⚠️ Nota: Los resultados son estimaciones y pueden variar de acuerdo con la compañía de electricidad 
                    y las condiciones reales de uso.
                </p>
            </nav>
        </section>
    </main>
</template>

<script>
export default {
    name: "Acercade",
};
</script>

<style scoped>
.Acercade-page {
    padding: 2rem;
    display: flex;
    align-items: flex-start;
}

.Acercade {
    max-width: 750px;
    width: 100%;
}

/* Card */
.Acercade-card {
    background: hwb(209 61% 8%);
    border-radius: 1rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.12);
    padding: 1.5rem 2rem;
    transition: box-shadow 0.2s;
    max-width: 700px;
    margin-top: 1.5rem;
    color: #555;
    font-weight: bold;
}

.Acercade-card:hover {
    box-shadow: 0 4px 16px rgba(0,0,0,0.18);
}

.Acercade-card p {
    font-size: 1rem;
    line-height: 1.5;
    color: #444;
    margin-bottom: 1rem;
}

.Acercade-card .nota {
    font-size: 0.95rem;
    font-style: italic;
    color: #d97706;
}
</style>
