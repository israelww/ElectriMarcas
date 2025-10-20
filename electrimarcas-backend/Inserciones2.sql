-- Usar la base de datos
USE ELECTRIMARCASS;
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
FROM 'C:\csv\tabla_electrodomesticos.csv'
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
    CASE WHEN tt.nombre_categoria = 'limpieza' THEN 'C01'
         WHEN tt.nombre_categoria = 'cocina' THEN 'C02'
         WHEN tt.nombre_categoria = 'entretenimiento' THEN 'C03'
         WHEN tt.nombre_categoria = 'climatizacion' THEN 'C04'
         WHEN tt.nombre_categoria = 'cuidado' THEN 'C05'
    ELSE 'C99' -- Categoría genérica para otros casos
    END AS id_categoria,
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

/* -----------------------------------------------------------
   2.1 Insertar reglas DAC (Prerrequisito)
   -----------------------------------------------------------
   Tabla: reglas_dac(clave_tarifa_base, limite_promedio_mensual_kwh)
   - Define el umbral de kWh promedio mensual que dispara la DAC
   - PRERREQUISITO: Debe existir antes de usar la clave 'DAC'
------------------------------------------------------------ */
INSERT INTO reglas_dac (clave_tarifa_base, limite_promedio_mensual_kwh) VALUES
('1D', 1000),
('1E', 2000),
('1F', 2500);
GO

/* -----------------------------------------------------------
   2.2 Insertar municipios y su tarifa base
   -----------------------------------------------------------
   Tabla: tarifa_municipios(estado, municipio, clave_tarifa_base, inicio_verano, fin_verano)
   - 'clave_tarifa_base' mapea el municipio a 1D/1E/1F por CFE
   - 'inicio_verano'/'fin_verano' se guardan como 'MMDD' (asumido CHAR(4))
   - PRERREQUISITO para crear planes: necesitamos IDs de municipios
------------------------------------------------------------ */
INSERT INTO tarifa_municipios (estado, municipio, clave_tarifa_base, inicio_verano, fin_verano) VALUES
('Sinaloa', 'Ahome', '1F', '0501', '1031'),
('Sinaloa', 'Angostura', '1F', '0501', '1031'),
('Sinaloa', 'Badiraguato', '1E', '0501', '1031'),
('Sinaloa', 'Concordia', '1D', '0501', '1031'),
('Sinaloa', 'Cosalá', '1D', '0501', '1031'),
('Sinaloa', 'Culiacán', '1F', '0501', '1031'),
('Sinaloa', 'Choix', '1F', '0501', '1031'),
('Sinaloa', 'Elota', '1E', '0501', '1031'),
('Sinaloa', 'Escuinapa', '1E', '0501', '1031'),
('Sinaloa', 'El Fuerte', '1F', '0501', '1031'),
('Sinaloa', 'Guasave', '1F', '0501', '1031'),
('Sinaloa', 'Mazatlán', '1E', '0501', '1031'),
('Sinaloa', 'Mocorito', '1F', '0501', '1031'),
('Sinaloa', 'Rosario', '1E', '0501', '1031'),
('Sinaloa', 'Salvador Alvarado', '1F', '0501', '1031'),
('Sinaloa', 'San Ignacio', '1E', '0501', '1031'),
('Sinaloa', 'Sinaloa', '1F', '0501', '1031'),
('Sinaloa', 'Navolato', '1F', '0501', '1031'),
('Sinaloa', 'El Dorado', '1F', '0501', '1031'),
('Sinaloa', 'Juan José Ríos', '1F', '0501', '1031');
GO

/* -----------------------------------------------------------
   2.3 Insertar planes_tarifa y bloques_tarifa
   -----------------------------------------------------------
   - Usamos variables para capturar id_plan (IDENTITY) y
     vincular sin romper la FK de bloques_tarifa(id_plan)
   - Cada plan es una combinación (clave_tarifa, es_verano)
   - DAC se define como plan independiente
------------------------------------------------------------ */

-- Variables para IDs de Plan
DECLARE @id_plan_1D_FV INT, @id_plan_1D_V INT;
DECLARE @id_plan_1E_FV INT, @id_plan_1E_V INT;
DECLARE @id_plan_1F_FV INT, @id_plan_1F_V INT;
DECLARE @id_plan_DAC   INT;

-- Variables para IDs de municipios “representativos” por clave base
DECLARE @id_municipio_1D INT;
DECLARE @id_municipio_1E INT;
DECLARE @id_municipio_1F INT;

-- Elegimos un municipio por cada clave base (el de menor id_municipio)
-- Nota: esto hace el script determinista: siempre toma el primero insertado.
SELECT TOP 1 @id_municipio_1D = id_municipio
FROM tarifa_municipios
WHERE clave_tarifa_base = '1D'
ORDER BY id_municipio;

SELECT TOP 1 @id_municipio_1E = id_municipio
FROM tarifa_municipios
WHERE clave_tarifa_base = '1E'
ORDER BY id_municipio;

SELECT TOP 1 @id_municipio_1F = id_municipio
FROM tarifa_municipios
WHERE clave_tarifa_base = '1F'
ORDER BY id_municipio;

-- Guardas defensivas: si falta alguno, abortamos
IF @id_municipio_1D IS NULL OR @id_municipio_1E IS NULL OR @id_municipio_1F IS NULL
BEGIN
    RAISERROR('ERROR CRÍTICO: No se encontraron IDs de municipios para 1D/1E/1F. Verifique tarifa_municipios.', 16, 1);
    RETURN;
END

/* ==============================
   INSERCIÓN DE PLANES_TARIFA
   ==============================
   Tabla: planes_tarifa(clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
   - es_verano: 1 = Verano, 0 = Fuera de Verano
   - vigente_desde: fecha de vigencia del plan
   - id_municipio: FK para anclar el plan a un municipio (criterio operativo)
   - SCOPE_IDENTITY() captura el id_plan recién creado
*/

-- 1D Fuera de Verano (FV)
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
VALUES ('1D', 0, '2025-01-01', N'1D fuera de verano', @id_municipio_1D);
SET @id_plan_1D_FV = SCOPE_IDENTITY();

-- 1D Verano (V)
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
VALUES ('1D', 1, '2025-05-01', N'1D verano', @id_municipio_1D);
SET @id_plan_1D_V = SCOPE_IDENTITY();

-- 1E Fuera de Verano (FV)
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
VALUES ('1E', 0, '2025-01-01', N'1E fuera de verano', @id_municipio_1E);
SET @id_plan_1E_FV = SCOPE_IDENTITY();

-- 1E Verano (V)
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
VALUES ('1E', 1, '2025-05-01', N'1E verano', @id_municipio_1E);
SET @id_plan_1E_V = SCOPE_IDENTITY();

-- 1F Fuera de Verano (FV)
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
VALUES ('1F', 0, '2025-01-01', N'1F fuera de verano', @id_municipio_1F);
SET @id_plan_1F_FV = SCOPE_IDENTITY();

-- 1F Verano (V)
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
VALUES ('1F', 1, '2025-05-01', N'1F verano', @id_municipio_1F);
SET @id_plan_1F_V = SCOPE_IDENTITY();

-- Plan DAC (se ancla a un municipio con 1F por conveniencia operativa)
INSERT INTO planes_tarifa (clave_tarifa, es_verano, vigente_desde, notas, id_municipio)
VALUES ('DAC', 0, '2025-01-01', N'Doméstica de Alto Consumo', @id_municipio_1F);
SET @id_plan_DAC = SCOPE_IDENTITY();


/* ==============================
   INSERCIÓN DE BLOQUES_TARIFA
   ==============================
   Tabla: bloques_tarifa(id_plan, orden_bloque, limite_kwh, precio_mxn)
   - 'orden_bloque' define la prioridad/escalón (recomendado UQ con id_plan)
   - 'limite_kwh' NULL significa "bloque abierto" (sin tope superior)
   - Los precios están normalizados por bloque
*/

-- Bloques 1D VERANO (V)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(@id_plan_1D_V, 1, 175 , 0.9770),
(@id_plan_1D_V, 2, 400 , 1.1310),
(@id_plan_1D_V, 3, 600 , 1.4590),
(@id_plan_1D_V, 4, NULL, 3.8890);

-- Bloques 1D FUERA DE VERANO (FV)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(@id_plan_1D_FV, 1, 75 , 1.1030),
(@id_plan_1D_FV, 2, 200, 1.3400),
(@id_plan_1D_FV, 3, NULL, 3.9170);

-- Bloques 1E VERANO (V)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(@id_plan_1E_V, 1, 300 , 0.8890),
(@id_plan_1E_V, 2, 750 , 1.0120),
(@id_plan_1E_V, 3, 900 , 1.3130),
(@id_plan_1E_V, 4, NULL, 3.8890);

-- Bloques 1E FUERA DE VERANO (FV)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(@id_plan_1E_FV, 1, 75 , 1.0950),
(@id_plan_1E_FV, 2, 200, 1.3300),
(@id_plan_1E_FV, 3, NULL, 3.8890);

-- Bloques 1F VERANO (V)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(@id_plan_1F_V, 1, 300 , 0.8150),
(@id_plan_1F_V, 2, 1200, 0.9960),
(@id_plan_1F_V, 3, 2500, 2.4230),
(@id_plan_1F_V, 4, NULL, 3.8330);

-- Bloques 1F FUERA DE VERANO (FV)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(@id_plan_1F_FV, 1, 75 , 1.1030),
(@id_plan_1F_FV, 2, 200, 1.3400),
(@id_plan_1F_FV, 3, NULL, 3.9170);

-- Bloque DAC (tarifa plana por kWh en todo el consumo)
INSERT INTO bloques_tarifa (id_plan, orden_bloque, limite_kwh, precio_mxn) VALUES
(@id_plan_DAC, 1, NULL, 6.0100);
GO


/* -----------------------------------------------------------
   Consulta de verificación:
   - Lista planes con sus bloques, ordenados por clave y temporada
------------------------------------------------------------ */
SELECT  P.id_plan,
        P.clave_tarifa,
        P.es_verano,
        B.orden_bloque,
        B.limite_kwh,
        B.precio_mxn
FROM planes_tarifa AS P
JOIN bloques_tarifa AS B
  ON P.id_plan = B.id_plan
ORDER BY P.clave_tarifa, P.es_verano DESC, B.orden_bloque;
GO

--INSERCION DE DATOS EN TABLA CONSUMO 
-- Tarifa 'T01' (Básica/Residencial)
INSERT INTO consumo (id_consumo, id_electrodomestico, horas_uso_diario, dias_uso_mes, id_tarifa)
VALUES
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
SELECT * FROM planes_tarifa;
SELECT * FROM bloques_tarfia;
SELECT * FROM reglas_dac;
SELECT * FROM consumo;
GO
