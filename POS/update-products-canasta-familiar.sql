-- US-006: Productos de Canasta Familiar Colombiana
-- Actualizar productos existentes con productos realistas

-- Limpiar productos actuales
DELETE FROM products.products;

-- Insertar productos de canasta familiar
INSERT INTO products.products (sku, name, description, category, price, stock, image_url, barcode, tax_rate, active) VALUES
-- LÁCTEOS
('HUEVOS-AA-12', 'Huevos AA x12 Unidades', 'Huevos frescos categoría AA', 'Lácteos', 8500.00, 100, '/images/huevos-aa.jpg', '7702001234567', 0.00, true),
('LECHE-ALPINA-1L', 'Leche Alpina Entera 1L', 'Leche entera pasteurizada', 'Lácteos', 3800.00, 150, '/images/leche-alpina.jpg', '7702002345678', 0.00, true),
('QUESO-CAMPESINO-500G', 'Queso Campesino 500g', 'Queso fresco campesino', 'Lácteos', 12500.00, 50, '/images/queso-campesino.jpg', '7702003456789', 0.00, true),

-- PANADERÍA
('PAN-BIMBO-TAJADO', 'Pan Tajado Bimbo', 'Pan de molde tajado 550g', 'Panadería', 4200.00, 80, '/images/pan-bimbo.jpg', '7702104567890', 0.00, true),
('AREPAS-QUAKER-500G', 'Arepas Quaker x10', 'Arepas precocidas 500g', 'Panadería', 5900.00, 60, '/images/arepas-quaker.jpg', '7702205678901', 0.00, true),

-- BEBIDAS
('COCA-COLA-400ML', 'Coca-Cola 400ml', 'Gaseosa Coca-Cola personal', 'Bebidas', 2500.00, 200, '/images/coca-cola.jpg', '7702306789012', 0.08, true),
('AGUA-BRISA-600ML', 'Agua Brisa 600ml', 'Agua sin gas', 'Bebidas', 1800.00, 180, '/images/agua-brisa.jpg', '7702407890123', 0.00, true),
('JUGO-HIT-1L', 'Jugo Hit Naranja 1L', 'Jugo de naranja Hit', 'Bebidas', 4500.00, 90, '/images/jugo-hit.jpg', '7702508901234', 0.08, true),

-- GRANOS Y CEREALES
('ARROZ-DIANA-500G', 'Arroz Diana 500g', 'Arroz blanco primera calidad', 'Granos', 2100.00, 120, '/images/arroz-diana.jpg', '7702609012345', 0.00, true),
('FRIJOL-ROJO-500G', 'Fríjol Rojo 500g', 'Fríjol rojo seco', 'Granos', 4800.00, 70, '/images/frijol-rojo.jpg', '7702710123456', 0.00, true),
('LENTEJA-500G', 'Lenteja 500g', 'Lenteja seca premium', 'Granos', 3900.00, 75, '/images/lenteja.jpg', '7702811234567', 0.00, true),

-- ACEITES Y CONDIMENTOS
('ACEITE-GIRASOL-900ML', 'Aceite Girasol 900ml', 'Aceite de girasol Premier', 'Aceites', 8900.00, 50, '/images/aceite-girasol.jpg', '7702912345678', 0.00, true),
('SAL-REFISAL-500G', 'Sal Refisal 500g', 'Sal de cocina refinada', 'Condimentos', 1200.00, 100, '/images/sal-refisal.jpg', '7703013456789', 0.00, true),
('AZUCAR-MANUELITA-1KG', 'Azúcar Manuelita 1kg', 'Azúcar blanca refinada', 'Condimentos', 3400.00, 110, '/images/azucar-manuelita.jpg', '7703114567890', 0.00, true),

-- ASEO E HIGIENE
('JABON-REY-3PACK', 'Jabón Rey x3', 'Jabón de tocador pack x3', 'Aseo', 6500.00, 80, '/images/jabon-rey.jpg', '7703215678901', 0.19, true),
('PAPEL-FAMILIA-4ROLL', 'Papel Higiénico Familia x4', 'Papel higiénico doble hoja', 'Aseo', 7800.00, 90, '/images/papel-familia.jpg', '7703316789012', 0.19, true),

-- SNACKS
('PAPAS-MARGARITA-150G', 'Papas Margarita Naturales 150g', 'Papas fritas naturales', 'Snacks', 4500.00, 100, '/images/papas-margarita.jpg', '7703417890123', 0.08, true),
('GALLETAS-FESTIVAL-300G', 'Galletas Festival 300g', 'Galletas dulces surtidas', 'Snacks', 5200.00, 85, '/images/galletas-festival.jpg', '7703518901234', 0.08, true),
('CHOCOLATINA-JET-35G', 'Chocolatina Jet 35g', 'Chocolate con leche', 'Snacks', 2000.00, 150, '/images/chocolatina-jet.jpg', '7703619012345', 0.08, true),

-- CARNES Y PROTEÍNAS (REFRIGERADAS)
('POLLO-PECHUGA-1KG', 'Pechuga de Pollo 1kg', 'Pechuga de pollo fresca', 'Carnes', 14500.00, 40, '/images/pechuga-pollo.jpg', '7703720123456', 0.00, true),
('CARNE-MOLIDA-500G', 'Carne Molida Res 500g', 'Carne molida especial', 'Carnes', 10800.00, 35, '/images/carne-molida.jpg', '7703821234567', 0.00, true);

-- Actualizar categorías
DELETE FROM products.categories;
INSERT INTO products.categories (name, description, icon) VALUES
('Lácteos', 'Productos lácteos y derivados', '🥛'),
('Panadería', 'Pan y productos de panadería', '🍞'),
('Bebidas', 'Bebidas y jugos', '🥤'),
('Granos', 'Arroz, fríjoles y cereales', '🌾'),
('Aceites', 'Aceites de cocina', '🫒'),
('Condimentos', 'Sal, azúcar y condimentos', '🧂'),
('Aseo', 'Productos de aseo e higiene', '🧼'),
('Snacks', 'Mecatos y snacks', '🍿'),
('Carnes', 'Carnes y proteínas', '🍖');

-- Verificar productos insertados
SELECT COUNT(*) as total_productos FROM products.products;
SELECT category, COUNT(*) as cantidad FROM products.products GROUP BY category ORDER BY category;
