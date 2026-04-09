-- =============================================
-- TABLAS
-- =============================================

-- Tabla de sedes
CREATE TABLE sedes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla principal de usuarios (login)
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(20) NOT NULL CHECK (rol IN ('mesero', 'cajero', 'administrador')),
    sede_id INT REFERENCES sedes(id),  -- NULL solo para administrador
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    security_question VARCHAR(255),
    security_answer_hash VARCHAR(255)
);

-- Tabla de meseros
CREATE TABLE meseros (
    id SERIAL PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    sede_id INT NOT NULL REFERENCES sedes(id)
);

-- Tabla de cajeros
CREATE TABLE cajeros (
    id SERIAL PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    sede_id INT NOT NULL REFERENCES sedes(id)
);

-- Tabla de administradores
CREATE TABLE administradores (
    id SERIAL PRIMARY KEY,
    usuario_id INT UNIQUE NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20)
);

-- Tabla de productos (catálogo maestro)
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    unidad VARCHAR(50) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    costo NUMERIC NOT NULL,
    precio NUMERIC NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de inventario
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(id),
    sede_id INT NOT NULL REFERENCES sedes(id),
    stock NUMERIC DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_id, sede_id)
);

-- =============================================
-- ÍNDICES
-- =============================================

CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_rol ON usuarios(rol);
CREATE INDEX idx_usuarios_sede ON usuarios(sede_id);
CREATE INDEX idx_meseros_sede ON meseros(sede_id);
CREATE INDEX idx_cajeros_sede ON cajeros(sede_id);
CREATE INDEX idx_products_nombre ON products(nombre);
CREATE INDEX idx_products_categoria ON products(categoria);
CREATE INDEX idx_inventory_sede ON inventory(sede_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);

-- =============================================
-- INSERTS DE PRUEBA
-- =============================================

-- Sedes
INSERT INTO sedes (nombre, direccion) VALUES
  ('Galerias', '53B Street # 25 - 21'),
  ('Restrepo', 'Carrera 19 # 18 - 51 South'),
  ('Zona T', 'Carrera 14 # 83 - 11 North');

-- Usuarios (passwords hasheadas con bcrypt de "Admin1234", "Mesero1234", "Cajero1234")
INSERT INTO usuarios (email, password_hash, rol, sede_id) VALUES
  ('admin@eclipsebar.com',   '$2a$12$soBP.OO/zNTCqDiDHmZqu.Ki1EPTGCtvyLj.HcbcTfDzPnZz3t9L.', 'administrador', NULL),
  ('mesero@eclipsebar.com', '$2a$12$/GQSMPlpe7NIOGBpO1eBWeyNYN8oKZhXBHytckamshC0hEhnEkvtu', 'mesero', 1),
  ('cajero@eclipsebar.com', '$2a$12$3xrSCOFsAIoLyB7lpU7vMedGVJTUHlOfJ5gnmg4fWJNzIOLgTCroy', 'cajero', 2);

-- Administrador
INSERT INTO administradores (usuario_id, nombre, telefono) VALUES
  (1, 'Carlos Suarez Admin', '3001234567');

-- Meseros
INSERT INTO meseros (usuario_id, nombre, telefono, sede_id) VALUES
  (2, 'Juan Lopez Mesero', '3109876543', 1);

-- Cajeros
INSERT INTO cajeros (usuario_id, nombre, telefono, sede_id) VALUES
  (3, 'Pablo Gomez Cajero', '3207654321', 2);

INSERT INTO products (nombre, unidad, categoria, costo, precio) VALUES
('Corona Extra', '330 ml', 'Liquor', 2500, 5000),
('Coca Cola', '600 ml', 'Drinks', 1800, 3500),
('Classic Hamburger', 'Unit', 'Food', 8000, 15000),
('Personal Pizza', 'Unit', 'Food', 7000, 14000),
('Margarita Pollo', 'Unit', 'Food', 3000, 7000),
('Whisky Old Parr', '500 ml', 'Liquor', 60000, 90000),
('Ron Medellín', '750 ml', 'Liquor', 30000, 55000),
('Water Cielo', '300 ml', 'Drinks', 1000, 2500);
