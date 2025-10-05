
-- ================================
-- Creación y uso de la base de datos
-- ================================
CREATE DATABASE ELECTRIMARCAS;
GO
USE ELECTRIMARCAS;
GO

-- ===================================================================
-- Tablas de Catálogos (Se mantienen sin cambios)
-- ===================================================================

CREATE TABLE categoria (
    id_categoria CHAR(6) NOT NULL,
    nombre_categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY(id_categoria)
);

CREATE TABLE marca (
    id_marca CHAR(6) NOT NULL,
    nombre_marca VARCHAR(30) NOT NULL,
    PRIMARY KEY(id_marca)
);

CREATE TABLE modelo (
    id_modelo CHAR(6) NOT NULL,
    id_marca CHAR(6) NOT NULL,
    nombre_modelo VARCHAR(40) NOT NULL,
    año_fabricacion INT NOT NULL,
    PRIMARY KEY(id_modelo),
    FOREIGN KEY(id_marca) REFERENCES marca(id_marca)
);

CREATE TABLE electrodomestico (
    id_electrodomestico CHAR(6) NOT NULL,
    id_categoria CHAR(6) NOT NULL,
    id_modelo CHAR(6) NOT NULL,
    voltaje INT NOT NULL,
    potencia INT NOT NULL,
    nombre_electrodomestico VARCHAR(60) NOT NULL,
    descripcion VARCHAR(60) NOT NULL,
    PRIMARY KEY(id_electrodomestico),
    FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY(id_modelo) REFERENCES modelo(id_modelo)
);

-- ================================
-- NUEVO MODELO DE TARIFAS
-- ================================

CREATE TABLE tarifa_municipios (
    id_municipio INT IDENTITY(1,1) PRIMARY KEY,
    estado VARCHAR(64) NOT NULL DEFAULT 'Sinaloa',
    municipio VARCHAR(64) NOT NULL UNIQUE,
    clave_tarifa_base VARCHAR(3) NOT NULL, -- '1D', '1E', '1F'
    inicio_verano CHAR(4), -- '0501' (01 mayo)
    fin_verano CHAR(4) -- '1031' (31 octubre)
);

CREATE TABLE planes_tarifa (
    id_plan INT IDENTITY(1,1) PRIMARY KEY,
    clave_tarifa VARCHAR(3) NOT NULL, -- '1D', '1E', '1F', 'DAC'
    es_verano BIT NOT NULL, -- 1 = verano, 0 = fuera de verano
    vigente_desde DATE NOT NULL,
    vigente_hasta DATE, -- NULL = actual
    notas TEXT
);

CREATE TABLE bloques_tarifa (
    id_bloque INT IDENTITY(1,1) PRIMARY KEY,
    id_plan INT NOT NULL,
    orden_bloque INT NOT NULL, -- 1=básico, 2=intermedio, 3=excedente
    limite_kwh INT, -- NULL = sin límite (excedente)
    precio_mxn money NOT NULL, -- precio $/kWh
    FOREIGN KEY (id_plan) REFERENCES planes_tarifa(id_plan)
);

CREATE TABLE reglas_dac (
    clave_tarifa_base VARCHAR(3) PRIMARY KEY,
    limite_promedio_mensual_kwh INT NOT NULL
);

-- ===================================================================
-- Tablas de Usuario y Consumo
-- ===================================================================

-- 1. Tabla de Usuario. Ahora incluye la ubicación (municipio).
CREATE TABLE usuario (
    id_usuario CHAR(6) PRIMARY KEY,
    id_municipio INT NOT NULL, -- CAMBIO: Se añade la ubicación directamente al usuario
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    contraseña_hash VARCHAR(255) NOT NULL,
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (id_municipio) REFERENCES tarifa_municipios(id_municipio)
);

-- 2. La tabla 'hogar' ha sido ELIMINADA.

-- ===================================================================
-- Tabla Transaccional de Consumo
-- ===================================================================

-- La tabla 'consumo' ahora se vincula directamente a un 'usuario'.
CREATE TABLE consumo (
    id_consumo char(6)  PRIMARY KEY,
    id_usuario char(6) NOT NULL, -- CAMBIO: Se vincula directamente con el usuario
    id_electrodomestico CHAR(6) NOT NULL,
    horas_uso_diario DECIMAL(4, 2) NOT NULL,
    dias_uso_mes INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_electrodomestico) REFERENCES electrodomestico(id_electrodomestico)a
);

GO
