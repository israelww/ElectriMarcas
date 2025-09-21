create database ELECTRIMARCAS
go
use ELECTRIMARCAS
go

CREATE TABLE categoria(
	id_categoria char(3) not null,
	nombre_categoria varchar(50)not null ,
	PRIMARY KEY(id_categoria)
)
SELECT * from categoria

--Tabla temporal para almacenar datos de un electrodomestico
#create table temp_electrodomestico(,
	nombre_categoria varchar(50) not null,
	id_electrodomestico char(6) not null,
	nombre_electrodomestico varchar(60) not null,
	id_marca char(6) not null,
	nombre_marca varchar(30) not null,
	id_modelo char(6) not null,
	nombre_modelo varchar(40) not null,
	año_fabricacion int not null,
	descripcion varchar(60) not null,
	voltaje varchar(10) not null,
	potencia  not null,
)


create table marca(
	id_marca char(6) not null,
	nombre_marca varchar(30)not null,
	PRIMARY KEY(id_marca)
)
create table modelo(
	id_modelo char(6) not null,
	id_marca char(6) not null,
	nombre_modelo varchar(40)not null,
	año_fabricacion int not null,
	PRIMARY KEY(id_modelo),
	FOREIGN KEY(id_marca) references marca(id_marca)
)

create table tarifa(
	id_tarifa char(6) not null,
	estado varchar(30)not null,
	estacion_anio varchar(20) not null,
	costo_kwh int not null,
	fecha date not null,
	PRIMARY KEY(id_tarifa)
)
alter table tarifa
ALTEr COLUMN costo_kwh int not null
insert into tarifa values('T01','Sinaloa','Verano',800,'2025-06-01')
insert into tarifa values('T02','Sinaloa','Invierno',0.1250,'2025-12-01')

T01 - Sinaloa - Verano - 600 - 2023-06-01
T02 - Sinaloa - Invierno - 0.1250 - 2023-12-01

create table consumo(
	id_consumo char(6) not null,
	id_electrodomestico char(6) not null,
	horas_uso int not null,
	dias_uso_mes int not null,
	id_tarifa char(6) not null,
	PRIMARY KEY(id_consumo),
	FOREIGN KEY(id_electrodomestico) references electrodomestico(id_electrodomestico),
	FOREIGN KEY(id_tarifa) references tarifa(id_tarifa)
)

create table electrodomestico(
	id_electrodomestico char(6) not null,
	id_categoria char(3) not null,
	id_modelo char(6) not null,
	voltaje INT not null,
	potencia INT not null,
	nombre_electrodomestico varchar(60) not null,
	descripcion varchar(60) not null,
	PRIMARY KEY(id_electrodomestico),
	FOREIGN KEY(id_categoria) references categoria(id_categoria),
	FOREIGN KEY(id_modelo) references modelo(id_modelo)
)

insert into categoria values('C01','Cocina')
insert into categoria values('C02','Limpieza')
insert into categoria values('C03','Entretenimiento')
go
insert into categoria values('C04','Climatizacion')
go
insert into categoria values('C05','Cuidado Personal')
go

SELECT * FROM categoria


-- Cambiar la longitud de varchar en tablas existentes
ALTER TABLE categoria 
ALTER COLUMN nombre_categoria VARCHAR(50) NOT NULL;

ALTER TABLE marca 
ALTER COLUMN nombre_marca VARCHAR(30) NOT NULL;

ALTER TABLE modelo 
ALTER COLUMN nombre_modelo VARCHAR(40) NOT NULL;

ALTER TABLE tarifa 
ALTER COLUMN estado VARCHAR(30) NOT NULL;

ALTER TABLE tarifa 
ALTER COLUMN estacion_anio VARCHAR(20) NOT NULL;

-- Cambiar decimal para mayor precisión
ALTER TABLE tarifa 
ALTER COLUMN costo_kwh DECIMAL(6,4) NOT NULL;

ALTER TABLE electrodomestico 
ALTER COLUMN potencia DECIMAL(8,2) NOT NULL;

ALTER TABLE electrodomestico
add nombre_electrodomestico varchar(60) not null;

ALTER TABLE electrodomestico
add descripcion varchar(60) not null;

select* from electrodomestico

