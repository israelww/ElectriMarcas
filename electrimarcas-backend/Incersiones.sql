-- Usar la base de datos
USE ELECTRIMARCAS;
GO

-- Crear la tabla de temp_electrodomesticos
create table #temp_electrodomestico(
	id_categoria char(6) not null,
	nombre_categoria varchar(50) not null,
	id_electrodomestico char(6) not null,
	nombre_electrodomestico varchar(60) not null,
	id_marca char(6) not null,
	nombre_marca varchar(30) not null,
	id_modelo char(6) not null,
	nombre_modelo varchar(40) not null,
	año_fabricacion int not null,
	descripcion varchar(150) not null,
	voltaje varchar(10) not null,
	potencia varchar(10) not null,
)

-- Insertar datos
BULK INSERT #temp_electrodomestico
FROM 'C:\USB Santiago\Semestre 7 Tec\Taller de Investigación II\ElectriMarcas\tabla_electrodomesticos.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,              -- omitir encabezado si el CSV lo tiene
    FIELDTERMINATOR = ',',     -- separador de columnas
    ROWTERMINATOR = '\n',      -- salto de línea
    TABLOCK
);

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
INSERT INTO tarifa_municipios (id_tarifa_municipios, estado, municipio, clave_tarifa_base, inicio_verano, fin_verano) VALUES
(1,  'Sinaloa', 'Ahome',             '1F', '0501', '1031'),
(2,  'Sinaloa', 'Angostura',         '1F', '0501', '1031'),
(3,  'Sinaloa', 'Badiraguato',       '1E', '0501', '1031'),
(4,  'Sinaloa', 'Concordia',         '1D', '0501', '1031'),
(5,  'Sinaloa', 'Cosalá',            '1D', '0501', '1031'),
(6,  'Sinaloa', 'Culiacán',          '1F', '0501', '1031'),
(7,  'Sinaloa', 'Choix',             '1F', '0501', '1031'),
(8,  'Sinaloa', 'Elota',             '1E', '0501', '1031'),
(9,  'Sinaloa', 'Escuinapa',         '1E', '0501', '1031'),
(10, 'Sinaloa', 'El Fuerte',         '1F', '0501', '1031'),
(11, 'Sinaloa', 'Guasave',           '1F', '0501', '1031'),
(12, 'Sinaloa', 'Mazatlán',          '1E', '0501', '1031'),
(13, 'Sinaloa', 'Mocorito',          '1F', '0501', '1031'),
(14, 'Sinaloa', 'Rosario',           '1E', '0501', '1031'),
(15, 'Sinaloa', 'Salvador Alvarado', '1F', '0501', '1031'),
(16, 'Sinaloa', 'San Ignacio',       '1E', '0501', '1031'),
(17, 'Sinaloa', 'Sinaloa',           '1F', '0501', '1031'),
(18, 'Sinaloa', 'Navolato',          '1F', '0501', '1031'),
(19, 'Sinaloa', 'El Dorado',         '1F', '0501', '1031'),
(20, 'Sinaloa', 'Juan José Ríos',    '1F', '0501', '1031');

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
('1D', 1000),
('1E', 2000),
('1F', 2500);
GO

--INSERCION DE DATOS EN TABLA CONSUMO 
-- Tarifa 'T01' (Básica/Residencial)
('C00001', 'E00001', 24, 30, 'T01'),  -- Nevera (uso continuo)
('C00002', 'E00002', 5, 30, 'T01'),   -- Televisor
('C00003', 'E00003', 8, 25, 'T01'),   -- PC de escritorio
('C00004', 'E00004', 12, 30, 'T01'),  -- Iluminación general
('C00005', 'E00005', 1, 28, 'T01'),   -- Cargador de móvil
('C00006', 'E00006', 4, 30, 'T01'),   -- Router
('C00007', 'E00007', 10, 25, 'T01'),  -- Servidor NAS
('C00008', 'E00008', 1, 30, 'T01'),   -- Tablet de pared
('C00009', 'E00009', 3, 30, 'T01'),   -- Ventilador
('C00010', 'E00010', 1, 15, 'T01'),   -- Licuadora
('C00011', 'E00011', 24, 30, 'T01'),  -- Congelador
('C00012', 'E00012', 5, 25, 'T01'),   -- Equipo de sonido
('C00013', 'E00013', 8, 30, 'T01'),   -- Luces exteriores
('C00014', 'E00014', 0.2, 20, 'T01'), -- Secador de manos
('C00015', 'E00015', 4, 30, 'T01'),   -- Monitor adicional

-- Tarifa 'T02' (Pico/Especial)
('C00016', 'E00016', 2, 12, 'T02'),  -- Lavadora
('C00017', 'E00017', 0.5, 10, 'T02'), -- Microondas
('C00018', 'E00018', 3, 15, 'T02'),  -- Secadora de ropa
('C00019', 'E00019', 6, 20, 'T02'),  -- Estufa de inducción
('C00020', 'E00020', 2, 8, 'T02'),   -- Plancha
('C00021', 'E00021', 7, 20, 'T02'),  -- Bomba de piscina
('C00022', 'E00022', 5, 15, 'T02'),  -- Herramienta de taller
('C00023', 'E00023', 0.5, 5, 'T02'),  -- Batidora profesional
('C00024', 'E00024', 9, 28, 'T02'),  -- Calentador de agua
('C00025', 'E00025', 6, 20, 'T02'),  -- Aire acondicionado
('C00026', 'E00026', 4, 18, 'T02'),  -- Horno eléctrico
('C00027', 'E00027', 12, 30, 'T02'), -- Lavavajillas
('C00028', 'E00028', 8, 10, 'T02'),  -- Consola de juegos
('C00029', 'E00029', 6, 25, 'T02'),  -- Servidor de oficina
('C00030', 'E00030', 1, 30, 'T02');  -- Impresora (en stand-by)

-- Verificación de los datos insertados
SELECT * FROM categoria;
SELECT * FROM marca;
SELECT * FROM modelo;
SELECT * FROM electrodomestico;
SELECT * FROM tarifa_municipios;
SELECT * FROM planes_tarifa;z
SELECT * FROM bloques_tarfia;
SELECT * FROM reglas_dac;
SELECT * FROM consumo;
GO
