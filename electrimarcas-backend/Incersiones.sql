-- Usar la base de datos
USE ELECTRIMARCAS;
GO

-- ===================================================================
-- INSERTS PARA DATOS MAESTROS (Catálogos)
-- Se insertan los datos que no dependen de otros.
-- ===================================================================

-- 1. Insertar en la tabla 'categoria'
-- Se insertan las categorías únicas desde la tabla temporal.
-- Usamos DISTINCT para no insertar duplicados si hubiera varios electrodomésticos de la misma categoría.

select * from #temp_electrodomestico
INSERT INTO categoria (id_categoria, nombre_categoria)
SELECT DISTINCT
    -- Asumimos un patrón para generar el id_categoria, por ejemplo 'C' + número.
    -- En un caso real, podrías tener una tabla de mapeo o una lógica más robusta.
    CASE WHEN tt.nombre_categoria = 'limpieza' THEN 'C01' END,
    tt.nombre_categoria
FROM #temp_electrodomestico tt
WHERE NOT EXISTS (SELECT 1 FROM categoria c WHERE c.nombre_categoria = tt.nombre_categoria);

-- 2. Insertar en la tabla 'marca'
-- Se insertan las marcas únicas desde la tabla temporal.
select * from marca
INSERT INTO marca (id_marca, nombre_marca)
SELECT DISTINCT
    tt.id_marca,
    tt.nombre_marca
FROM #temp_electrodomestico tt
WHERE NOT EXISTS (SELECT 1 FROM marca m WHERE m.id_marca = tt.id_marca);

-- ===================================================================
-- INSERTS PARA DATOS DEPENDIENTES
-- Ahora se insertan los datos que tienen claves foráneas.
-- ===================================================================

-- 3. Insertar en la tabla 'modelo'
-- Se insertan los modelos únicos, asegurando que su marca ya exista.
INSERT INTO modelo (id_modelo, id_marca, nombre_modelo, año_fabricacion)
SELECT DISTINCT
    tt.id_modelo,
    tt.id_marca,
    tt.nombre_modelo,
    tt.año_fabricacion
FROM #temp_electrodomestico tt
WHERE NOT EXISTS (SELECT 1 FROM modelo mo WHERE mo.id_modelo = tt.id_modelo);



-- 4. Insertar en la tabla 'electrodomestico'
-- Finalmente, se inserta la información completa del electrodoméstico.
INSERT INTO electrodomestico (id_electrodomestico, id_categoria, id_modelo, voltaje, potencia, nombre_electrodomestico, descripcion)
SELECT DISTINCT
    tt.id_electrodomestico,
    -- Obtenemos el id_categoria correspondiente al nombre de la categoría.
    (SELECT c.id_categoria FROM categoria c WHERE c.nombre_categoria = tt.nombre_categoria),
    tt.id_modelo,
    CAST(tt.voltaje AS INT),
    CAST(tt.potencia AS INT),
    tt.nombre_electrodomestico,
    tt.descripcion
FROM #temp_electrodomestico tt
WHERE NOT EXISTS (SELECT 1 FROM electrodomestico e WHERE e.id_electrodomestico = tt.id_electrodomestico);

select * from electrodomestico



-- ===================================================================
-- EJEMPLO DE INSERTS PARA TARIFAS (CFE Tarifa 1F - Sinaloa)
-- Estos datos son un ejemplo basado en las tarifas de CFE y deben ser actualizados
-- según las publicaciones oficiales en el Diario Oficial de la Federación.
-- ===================================================================

-- Insertar el municipio y su tarifa base
INSERT INTO tarifa_municipios (estado, municipio, clave_tarifa_base, inicio_verano, fin_verano) VALUES
('Sinaloa', 'Culiacán', '1F', '0501', '1031');

-- Insertar los planes tarifarios (Verano y Fuera de Verano)
-- Asumimos que los planes actuales son vigentes desde inicio de 2025.
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas) VALUES
('1F', TRUE, '2025-01-01', 'Tarifa 1F para temporada de verano.'),
('1F', FALSE, '2025-01-01', 'Tarifa 1F para fuera de verano.');

-- Insertar los bloques de consumo para el plan de VERANO (1F)
-- (ID del plan de verano es 1)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(1, 1, 300, 0.5950),   -- Básico: Primeros 300 kWh
(1, 2, 1200, 0.7410),  -- Intermedio Bajo: Siguientes 900 kWh (300+900=1200)
(1, 3, 2500, 1.8040),  -- Intermedio Alto: Siguientes 1300 kWh (1200+1300=2500)
(1, 4, NULL, 2.8590);  -- Excedente: kWh adicionales

-- Insertar los bloques de consumo para el plan FUERA DE VERANO (1F)
-- (ID del plan fuera de verano es 2)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(2, 1, 75, 0.8090),    -- Básico: Primeros 75 kWh
(2, 2, 200, 0.9760),   -- Intermedio: Siguientes 125 kWh (75+125=200)
(2, 3, NULL, 2.8590);   -- Excedente: kWh adicionales

-- Insertar regla para Tarifa Doméstica de Alto Consumo (DAC)
INSERT INTO reglas_dac (clave_tarifa_base, limite_promedio_mensual_kwh) VALUES
('1F', 2500);
GO

-- Verificación de los datos insertados
SELECT * FROM categoria;
SELECT * FROM marca;
SELECT * FROM modelo;
SELECT * FROM electrodomestico;
SELECT * FROM tarifa_municipios;
SELECT * FROM planes_tarifa;
SELECT * FROM bloques_tarifa;
SELECT * FROM reglas_dac;
GO
