-- Alwon POS - Database Initialization Script
-- Creates all schemas and tables for 9 microservices

-- Drop existing schemas if they exist
DROP SCHEMA IF EXISTS sessions CASCADE;
DROP SCHEMA IF EXISTS carts CASCADE;
DROP SCHEMA IF EXISTS products CASCADE;
DROP SCHEMA IF EXISTS payments CASCADE;
DROP SCHEMA IF EXISTS camera CASCADE;
DROP SCHEMA IF EXISTS access CASCADE;
DROP SCHEMA IF EXISTS inventory CASCADE;

-- Create schemas
CREATE SCHEMA sessions;
CREATE SCHEMA carts;
CREATE SCHEMA products;
CREATE SCHEMA payments;
CREATE SCHEMA camera;
CREATE SCHEMA access;
CREATE SCHEMA inventory;

-- ============================================
-- SESSION SERVICE (Port 8081)
-- ============================================
CREATE TABLE sessions.customer_sessions (
    id BIGSERIAL PRIMARY KEY,
    session_id VARCHAR(100) UNIQUE NOT NULL,
    customer_id VARCHAR(50),
    customer_type VARCHAR(20) NOT NULL CHECK (customer_type IN ('FACIAL', 'PIN', 'NO_ID')),
    customer_name VARCHAR(200),
    tower VARCHAR(50),
    apartment VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(100),
    photo_url TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'AT_CHECKOUT', 'COMPLETED', 'EXPIRED', 'CANCELLED')),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sessions_customer_id ON sessions.customer_sessions(customer_id);
CREATE INDEX idx_sessions_status ON sessions.customer_sessions(status);
CREATE INDEX idx_sessions_created_at ON sessions.customer_sessions(created_at);

-- ============================================
-- CART SERVICE (Port 8082)
-- ============================================
CREATE TABLE carts.carts (
    id BIGSERIAL PRIMARY KEY,
    cart_id VARCHAR(100) UNIQUE NOT NULL,
    session_id VARCHAR(100) NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    total_items INTEGER DEFAULT 0,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE carts.cart_items (
    id BIGSERIAL PRIMARY KEY,
    cart_id VARCHAR(100) NOT NULL,
    product_sku VARCHAR(50) NOT NULL,
    product_name VARCHAR(200),
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    detection_confidence DECIMAL(3,2),
    requires_review BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES carts.carts(cart_id) ON DELETE CASCADE
);

CREATE TABLE carts.cart_modifications (
    id BIGSERIAL PRIMARY KEY,
    cart_id VARCHAR(100) NOT NULL,
    operator_id VARCHAR(50),
    action VARCHAR(50) NOT NULL,
    item_sku VARCHAR(50),
    old_quantity INTEGER,
    new_quantity INTEGER,
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_carts_session_id ON carts.carts(session_id);
CREATE INDEX idx_cart_items_cart_id ON carts.cart_items(cart_id);

-- ============================================
-- PRODUCT SERVICE (Port 8083)
-- ============================================
CREATE TABLE products.products (
    id BIGSERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    barcode VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_products_sku ON products.products(sku);
CREATE INDEX idx_products_category ON products.products(category);
CREATE INDEX idx_products_active ON products.products(active);

-- Insert sample products
INSERT INTO products.products (sku, name, description, category, price, barcode, active) VALUES
('PROD-001', 'Coca Cola 350ml', 'Bebida carbonatada sabor cola', 'BEBIDAS', 2000, '7891234567890', true),
('PROD-002', 'Agua Mineral 500ml', 'Agua mineral natural', 'BEBIDAS', 1500, '7891234567891', true),
('PROD-003', 'Pan Integral 500g', 'Pan integral de trigo', 'PANADERIA', 3500, '7891234567892', true),
('PROD-004', 'Leche Entera 1L', 'Leche ultra pasteurizada', 'LACTEOS', 4200, '7891234567893', true),
('PROD-005', 'Yogurt Natural 200g', 'Yogurt natural sin azúcar', 'LACTEOS', 2800, '7891234567894', true),
('PROD-006', 'Papas Fritas 150g', 'Papas fritas sabor natural', 'SNACKS', 3200, '7891234567895', true),
('PROD-007', 'Chocolate Bar 50g', 'Chocolate con leche', 'DULCES', 2500, '7891234567896', true),
('PROD-008', 'Café Instantáneo 100g', 'Café soluble', 'BEBIDAS', 8500, '7891234567897', true),
('PROD-009', 'Galletas Saladas 200g', 'Galletas crackers', 'SNACKS', 3800, '7891234567898', true),
('PROD-010', 'Jugo Naranja 1L', 'Jugo natural de naranja', 'BEBIDAS', 5500, '7891234567899', true);

-- ============================================
-- PAYMENT SERVICE (Port 8084)
-- ============================================
CREATE TABLE payments.transactions (
    id BIGSERIAL PRIMARY KEY,
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    session_id VARCHAR(100) NOT NULL,
    cart_id VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('PSE', 'DEBIT', 'CREDIT', 'CASH')),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED')),
    pse_bank VARCHAR(100),
    pse_reference VARCHAR(100),
    card_last_four VARCHAR(4),
    authorization_code VARCHAR(50),
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE INDEX idx_payments_session_id ON payments.transactions(session_id);
CREATE INDEX idx_payments_status ON payments.transactions(status);

-- ============================================
-- CAMERA SERVICE (Port 8085)
-- ============================================
CREATE TABLE camera.facial_recognitions (
    id BIGSERIAL PRIMARY KEY,
    recognition_id VARCHAR(100) UNIQUE NOT NULL,
    customer_id VARCHAR(50),
    face_hash VARCHAR(200),
    confidence DECIMAL(3,2),
    image_url TEXT,
    camera_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE camera.evidence_files (
    id BIGSERIAL PRIMARY KEY,
    evidence_id VARCHAR(100) UNIQUE NOT NULL,
    session_id VARCHAR(100) NOT NULL,
    file_type VARCHAR(20) CHECK (file_type IN ('PHOTO', 'VIDEO')),
    file_url TEXT NOT NULL,
    product_sku VARCHAR(50),
    description TEXT,
    camera_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);

CREATE INDEX idx_evidence_session_id ON camera.evidence_files(session_id);

-- ============================================
-- ACCESS SERVICE (Port 8086)
-- ============================================
CREATE TABLE access.client_types (
    id SERIAL PRIMARY KEY,
    type_code VARCHAR(20) UNIQUE NOT NULL,
    type_name VARCHAR(50) NOT NULL,
    color_hex VARCHAR(7) NOT NULL,
    description TEXT,
    requires_photo BOOLEAN DEFAULT FALSE,
    requires_evidence BOOLEAN DEFAULT FALSE,
    data_retention_days INTEGER,
    active BOOLEAN DEFAULT TRUE
);

INSERT INTO access.client_types (type_code, type_name, color_hex, description, requires_photo, requires_evidence, data_retention_days) VALUES
('FACIAL', 'Cliente Registrado', '#10b981', 'Cliente con reconocimiento facial permanente', true, false, NULL),
('PIN', 'Cliente Temporal', '#f59e0b', 'Cliente temporal con PIN, datos eliminados post-pago', true, false, 1),
('NO_ID', 'Sin Identificación', '#ef4444', 'Persona no identificada, requiere evidencia visual', true, true, 30);

-- ============================================
-- INVENTORY SERVICE (Port 8087)
-- ============================================
CREATE TABLE inventory.stock (
    id BIGSERIAL PRIMARY KEY,
    product_sku VARCHAR(50) UNIQUE NOT NULL,
    quantity_available INTEGER DEFAULT 0,
    quantity_reserved INTEGER DEFAULT 0,
    minimum_stock INTEGER DEFAULT 5,
    last_restock_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory.stock_movements (
    id BIGSERIAL PRIMARY KEY,
    product_sku VARCHAR(50) NOT NULL,
    movement_type VARCHAR(20) CHECK (movement_type IN ('SALE', 'RETURN', 'RESTOCK', 'ADJUSTMENT')),
    quantity INTEGER NOT NULL,
    reference_id VARCHAR(100),
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initialize stock for sample products
INSERT INTO inventory.stock (product_sku, quantity_available, minimum_stock) 
SELECT sku, 100, 10 FROM products.products;

CREATE INDEX idx_stock_sku ON inventory.stock(product_sku);
CREATE INDEX idx_movements_sku ON inventory.stock_movements(product_sku);

-- ============================================
-- Create a test operator user
-- ============================================
CREATE TABLE IF NOT EXISTS sessions.operators (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(200) NOT NULL,
    full_name VARCHAR(200),
    role VARCHAR(20) DEFAULT 'OPERATOR',
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO sessions.operators (username, password_hash, full_name, role) VALUES
('operador', '$2a$10$N9qo8uLOickgx2ZMRZoMye1J6hQ8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8', 'Operador Principal', 'OPERATOR');

-- ============================================
-- Grant permissions
-- ============================================
GRANT ALL PRIVILEGES ON SCHEMA sessions TO alwon;
GRANT ALL PRIVILEGES ON SCHEMA carts TO alwon;
GRANT ALL PRIVILEGES ON SCHEMA products TO alwon;
GRANT ALL PRIVILEGES ON SCHEMA payments TO alwon;
GRANT ALL PRIVILEGES ON SCHEMA camera TO alwon;
GRANT ALL PRIVILEGES ON SCHEMA access TO alwon;
GRANT ALL PRIVILEGES ON SCHEMA inventory TO alwon;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA sessions TO alwon;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA carts TO alwon;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA products TO alwon;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA payments TO alwon;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA camera TO alwon;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA access TO alwon;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA inventory TO alwon;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA sessions TO alwon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA carts TO alwon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA products TO alwon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA payments TO alwon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA camera TO alwon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA access TO alwon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA inventory TO alwon;

-- ============================================
-- Verification queries
-- ============================================
-- SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('sessions', 'carts', 'products', 'payments', 'camera', 'access', 'inventory');
-- SELECT * FROM products.products;
-- SELECT * FROM access.client_types;
