-- Create categories table first
CREATE TABLE products.categories (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert categories
INSERT INTO products.categories (name, description) VALUES
('BEBIDAS', 'Bebidas y Líquidos'),
('LACTEOS', 'Productos Lácteos'),
('PANADERIA', 'Productos de Panadería'),
('SNACKS', 'Snacks y Aperitivos'),
('DULCES', 'Dulces y Chocolates');

-- Create products table matching Product.java model
CREATE TABLE products.products (
    id BIGSERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category_id BIGINT,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    min_stock INTEGER NOT NULL DEFAULT 5,
    image_url TEXT,
    active BOOLEAN DEFAULT TRUE,
    taxable BOOLEAN DEFAULT TRUE,
    tax_rate DECIMAL(5,2) DEFAULT 19.00,
    barcode VARCHAR(50),
    brand VARCHAR(50),
    unit VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES products.categories(id)
);

CREATE INDEX idx_products_sku ON products.products(sku);
CREATE INDEX idx_products_category_id ON products.products(category_id);
CREATE INDEX idx_products_active ON products.products(active);

-- Insert sample products with all required fields
INSERT INTO products.products (sku, name, description, category_id, price, stock, min_stock, barcode, brand, unit, active, taxable, tax_rate) VALUES
('PROD-001', 'Coca Cola 350ml', 'Bebida carbonatada sabor cola', 1, 2000, 100, 10, '789123456 7890', 'Coca-Cola', 'unit', true, true, 19.00),
('PROD-002', 'Agua Mineral 500ml', 'Agua mineral natural', 1, 1500, 150, 15, '7891234567891', 'Brisa', 'unit', true, true, 19.00),
('PROD-003', 'Pan Integral 500g', 'Pan integral de trigo', 3, 3500, 50, 10, '7891234567892', 'Bimbo', 'kg', true, true, 19.00),
('PROD-004', 'Leche Entera 1L', 'Leche ultra pasteurizada', 2, 4200, 80, 15, '7891234567893', 'Alpina', 'liter', true, true, 19.00),
('PROD-005', 'Yogurt Natural 200g', 'Yogurt natural sin azúcar', 2, 2800, 60, 10, '7891234567894', 'Alpina', 'unit', true, true, 19.00),
('PROD-006', 'Papas Fritas 150g', 'Papas fritas sabor natural', 4, 3200, 90, 15, '7891234567895', 'Margarita', 'unit', true, true, 19.00),
('PROD-007', 'Chocolate Bar 50g', 'Chocolate con leche', 5, 2500, 70, 12, '7891234567896', 'Jet', 'unit', true, true, 19.00),
('PROD-008', 'Café Instantáneo 100g', 'Café soluble', 1, 8500, 40, 8, '7891234567897', 'Nescafé', 'unit', true, true, 19.00),
('PROD-009', 'Galletas Saladas 200g', 'Galletas crackers', 4, 3800, 85, 15, '7891234567898', 'Saltinas', 'unit', true, true, 19.00),
('PROD-010', 'Jugo Naranja 1L', 'Jugo natural de naranja', 1, 5500, 65, 10, '7891234567899', 'Hit', 'liter', true, true, 19.00);

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA products TO alwon;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA products TO alwon;
