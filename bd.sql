-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS servicio_mantenimiento;
USE servicio_mantenimiento;

-- Eliminar tablas si existen (orden correcto por claves foráneas)
DROP TABLE IF EXISTS servicios;
DROP TABLE IF EXISTS historial_estados;
DROP TABLE IF EXISTS dispositivos;
DROP TABLE IF EXISTS clientes;

-- Tabla de clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    direccion VARCHAR(200) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    codigo_postal VARCHAR(10),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de dispositivos
CREATE TABLE dispositivos (
    id_dispositivo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo_dispositivo ENUM('PC', 'Laptop', 'Tablet', 'Impresora', 'Monitor', 'Otro') NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    numero_serie VARCHAR(50),
    problema_reportado TEXT NOT NULL,
    estado ENUM('Recibido', 'En diagnóstico', 'En reparación', 'Reparado', 'Entregado') DEFAULT 'Recibido',
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabla de historial de estados
CREATE TABLE historial_estados (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_dispositivo INT NOT NULL,
    estado_anterior ENUM('Recibido', 'En diagnóstico', 'En reparación', 'Reparado', 'Entregado'),
    estado_nuevo ENUM('Recibido', 'En diagnóstico', 'En reparación', 'Reparado', 'Entregado') NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100),
    FOREIGN KEY (id_dispositivo) REFERENCES dispositivos(id_dispositivo) ON DELETE CASCADE
);

-- Tabla de servicios
CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    id_dispositivo INT NOT NULL,
    descripcion_servicio TEXT NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    tecnico_asignado VARCHAR(100),
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_finalizacion TIMESTAMP NULL,
    observaciones TEXT,
    FOREIGN KEY (id_dispositivo) REFERENCES dispositivos(id_dispositivo) ON DELETE CASCADE
);

-- 1. Insertar clientes
INSERT INTO clientes (nombre, apellidos, telefono, email, direccion, ciudad, codigo_postal) VALUES
('Juan', 'Pérez López', '5551234567', 'juan.perez@email.com', 'Calle Principal 123', 'Ciudad de México', '06000'),
('María', 'García Hernández', '5552345678', 'maria.garcia@email.com', 'Avenida Reforma 456', 'Guadalajara', '44100'),
('Carlos', 'Martínez Sánchez', '5553456789', 'carlos.martinez@email.com', 'Boulevard Juárez 789', 'Monterrey', '64000'),
('Ana', 'Rodríguez Díaz', '5554567890', 'ana.rodriguez@email.com', 'Calle Morelos 321', 'Puebla', '72000');

-- 2. Insertar dispositivos (usando los IDs de clientes recién insertados)
INSERT INTO dispositivos (id_cliente, tipo_dispositivo, marca, modelo, numero_serie, problema_reportado) VALUES
(1, 'Laptop', 'Dell', 'XPS 15', 'DLXPS151234', 'No enciende, posible falla de placa'),
(2, 'PC', 'HP', 'Pavilion', 'HPPAV987654', 'Sobrecalentamiento y apagones'),
(3, 'Tablet', 'Samsung', 'Galaxy Tab S7', 'SMGTABS7123', 'Pantalla rota y no carga'),
(4, 'Impresora', 'Epson', 'L380', 'EPSL3804567', 'Atascos de papel y manchado');

-- 3. Insertar servicios (usando los IDs de dispositivos recién insertados)
INSERT INTO servicios (id_dispositivo, descripcion_servicio, costo, tecnico_asignado, observaciones) VALUES
(1, 'Diagnóstico y reemplazo de placa madre', 2500.00, 'Carlos Ramírez', 'Se reemplazó placa madre defectuosa'),
(2, 'Limpieza interna y reemplazo de pasta térmica', 450.00, 'Ana Martínez', 'Se recomienda mantenimiento cada 6 meses'),
(3, 'Reemplazo de pantalla y puerto de carga', 1800.00, 'Lucía Fernández', 'Se usaron refacciones originales'),
(4, 'Limpieza de cabezales y ajuste de mecanismo', 600.00, 'Pedro Gómez', 'Requiere cartuchos originales para mejor rendimiento');
