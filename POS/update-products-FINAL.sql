-- PRODUCTOS CANASTA FAMILIAR - VERSION FINAL
-- Compatible con schema real de productos

-- Limpiar datos existentes
DELETE FROM products.products;
DELETE FROM products.categories;

-- Insertar categorías (sin icon)
INSERT INTO products.categories (name, description) VALUES
('Lácteos', 'Productos lácteos y derivados'),
('Panadería', 'Pan y productos de panadería'),
('Bebidas', 'Bebidas y jugos'),
('Granos', 'Arroz, fríjoles y cereales'),
('Aceites', 'Aceites de cocina'),
('Condimentos', 'Sal, azúcar y condimentos'),
('Aseo', 'Productos de aseo e higiene'),
('Snacks', 'Mecatos y snacks'),
('Carnes', 'Carnes y proteínas');

-- Insertar productos usando category_id
INSERT INTO products.products (sku, name, description, category_id, price, stock, barcode, tax_rate, active) VALUES
-- LÁCTEOS (category_id = 1)
('HUEVOS-AA-12', 'Huevos AA x12 Unidades', 'Huevos frescos categoría AA', 1, 8500.00, 100, '7702001234567', 0.00, true),
('LECHE-ALPINA-1L', 'Leche Alpina Entera 1L', 'Leche entera pasteurizada', 1, 3800.00, 150, '7702002345678', 0.00, true),
('QUESO-CAMPESINO-500G', 'Queso Campesino 500g', 'Queso fresco campesino', 1, 12500.00, 50, '7702003456789', 0.00, true),

-- PANADERÍA (category_id = 2)
('PAN-BIMBO-TAJADO', 'Pan Tajado Bimbo', 'Pan de molde tajado 550g', 2, 4200.00, 80, '7702104567890', 0.00, true),
('AREPAS-QUAKER-500G', 'Arepas Quaker x10', 'Arepas precocidas 500g', 2, 5900.00, 60, '7702205678901', 0.00, true),

-- BEBIDAS (category_id = 3)
('COCA-COLA-400ML', 'Coca-Cola 400ml', 'Gaseosa Coca-Cola personal', 3, 2500.00, 200, '7702306789012', 0.08, true),
('AGUA-BRISA-600ML', 'Agua Brisa 600ml', 'Agua sin gas', 3, 1800.00, 180, '7702407890123', 0.00, true),
('JUGO-HIT-1L', 'Jugo Hit Naranja 1L', 'Jugo de naranja Hit', 3, 4500.00, 90, '7702508901234', 0.08, true),

-- GRANOS (category_id = 4)
('ARROZ-DIANA-500G', 'Arroz Diana 500g', 'Arroz blanco primera calidad', 4, 2100.00, 120, '7702609012345', 0.00, true),
('FRIJOL-ROJO-500G', 'Fríjol Rojo 500g', 'Fríjol rojo seco', 4, 4800.00, 70, '7702710123456', 0.00, true),
('LENTEJA-500G', 'Lenteja 500g', 'Lenteja seca premium', 4, 3900.00, 75, '7702811234567', 0.00, true),

-- ACEITES (category_id = 5)
('ACEITE-GIRASOL-900ML', 'Aceite Girasol 900ml', 'Aceite de girasol Premier', 5, 8900.00, 50, '7702912345678', 0.00, true),

-- CONDIMENTOS (category_id = 6)
('SAL-REFISAL-500G', 'Sal Refisal 500g', 'Sal de cocina refinada', 6, 1200.00, 100, '7703013456789', 0.00, true),
('AZUCAR-MANUELITA-1KG', 'Azúcar Manuelita 1kg', 'Azúcar blanca refinada', 6, 3400.00, 110, '7703114567890', 0.00, true),

-- ASEO (category_id = 7)
('JABON-REY-3PACK', 'Jabón Rey x3', 'Jabón de tocador pack x3', 7, 6500.00, 80, '77032156789 01', 0.19, true),
('PAPEL-FAMILIA-4ROLL', 'Papel Higiénico Familia x4', 'Papel higiénico doble hoja', 7, 7800.00, 90, '7703316789012', 0.19, true),

-- SNACKS (category_id = 8)
('PAPAS-MARGARITA-150G', 'Papas Margarita Naturales 150g', 'Papas fritas naturales', 8, 4500.00, 100, '7703417890123', 0.08, true),
('GALLETAS-FESTIVAL-300G', 'Galletas Festival 300g', 'Galletas dulces surtidas', 8, 5200.00, 85, '7703518901234', 0.08, true),
('CHOCOLATINA-JET-35G', 'Chocolatina Jet 35g', 'Chocolate con leche', 8, 2000.00, 150, '7703619012345', 0.08, true),

-- CARNES (category_id = 9)
('POLLO-PECHUGA-1KG', 'Pechuga de Pollo 1kg', 'Pechuga de pollo fresca', 9, 14500.00, 40, '7703720123456', 0.00, true),
('CARNE-MOLIDA-500G', 'Carne Molida Res 500g', 'Carne molida especial', 9, 10800.00, 35, '7703821234567', 0.00, true);

-- Verificar resultados
SELECT COUNT(*) as total_productos FROM products.products;
SELECT c.name as categoria, COUNT(p.id) as cantidad 
FROM products.categories c
LEFT JOIN products.products p ON p.category_id = c.id
GROUP BY c.name 
ORDER BY c.name;
