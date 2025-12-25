-- ============================================
-- DATOS DE PRUEBA PARA ALWON POS
-- ============================================

-- Limpiar datos existentes de prueba
TRUNCATE sessions.customer_sessions CASCADE;
TRUNCATE carts.carts CASCADE;
TRUNCATE carts.cart_items CASCADE;
TRUNCATE carts.cart_modifications CASCADE;

-- ============================================
-- SESIONES ACTIVAS
-- ============================================

-- Sesión 1: Cliente con reconocimiento facial (ACTIVE)
INSERT INTO sessions.customer_sessions 
(session_id, customer_id, customer_type, customer_name, tower, apartment, phone, email, photo_url, status, created_at, updated_at, expires_at, last_activity_at)
VALUES
('session-001', 'CUST-12345', 'FACIAL', 'María García López', 'Torre A', '501', '3001234567', 'maria.garcia@email.com', 'https://randomuser.me/api/portraits/women/1.jpg', 'ACTIVE', NOW() - INTERVAL '15 minutes', NOW(), NOW() + INTERVAL '45 minutes', NOW());

-- Sesión 2: Cliente con PIN (ACTIVE)
INSERT INTO sessions.customer_sessions 
(session_id, customer_id, customer_type, customer_name, tower, apartment, phone, email, photo_url, status, created_at, updated_at, expires_at, last_activity_at)
VALUES
('session-002', 'CUST-67890', 'PIN', 'Carlos Rodríguez Pérez', 'Torre B', '1203', '3009876543', 'carlos.rodriguez@email.com', 'https://randomuser.me/api/portraits/men/2.jpg', 'ACTIVE', NOW() - INTERVAL '8 minutes', NOW(), NOW() + INTERVAL '52 minutes', NOW());

-- Sesión 3: Cliente no identificado (ACTIVE)
INSERT INTO sessions.customer_sessions 
(session_id, customer_id, customer_type, customer_name, tower, apartment, phone, email, photo_url, status, created_at, updated_at, expires_at, last_activity_at)
VALUES
('session-003', NULL, 'NO_ID', 'Cliente No Identificado', NULL, NULL, NULL, NULL, NULL, 'ACTIVE', NOW() - INTERVAL '5 minutes', NOW(), NOW() + INTERVAL '25 minutes', NOW());

-- Sesión 4: Cliente con reconocimiento facial (AT_CHECKOUT - en caja)
INSERT INTO sessions.customer_sessions 
(session_id, customer_id, customer_type, customer_name, tower, apartment, phone, email, photo_url, status, created_at, updated_at, expires_at, last_activity_at)
VALUES
('session-004', 'CUST-11111', 'FACIAL', 'Ana Martínez Silva', 'Torre C', '802', '3157654321', 'ana.martinez@email.com', 'https://randomuser.me/api/portraits/women/3.jpg', 'AT_CHECKOUT', NOW() - INTERVAL '20 minutes', NOW() - INTERVAL '2 minutes', NOW() + INTERVAL '40 minutes', NOW() - INTERVAL '2 minutes');

-- Sesión 5: Cliente con PIN (ACTIVE)
INSERT INTO sessions.customer_sessions 
(session_id, customer_id, customer_type, customer_name, tower, apartment, phone, email, photo_url, status, created_at, updated_at, expires_at, last_activity_at)
VALUES
('session-005', 'CUST-22222', 'PIN', 'Luis Hernández Torres', 'Torre A', '305', '3209988776', 'luis.hernandez@email.com', 'https://randomuser.me/api/portraits/men/4.jpg', 'ACTIVE', NOW() - INTERVAL '3 minutes', NOW(), NOW() + INTERVAL '57 minutes', NOW());

-- ============================================
-- CARRITOS DE COMPRAS
-- ============================================

-- Carrito 1: María García
INSERT INTO carts.carts (cart_id, session_id, total_amount, total_items, status, created_at, updated_at)
VALUES ('cart-001', 'session-001', 36300, 5, 'ACTIVE', NOW() - INTERVAL '15 minutes', NOW());

INSERT INTO carts.cart_items (cart_id, product_sku, product_name, quantity, unit_price, subtotal, created_at)
VALUES 
('cart-001', 'PROD-001', 'Coca Cola 350ml', 3, 2000, 6000, NOW() - INTERVAL '14 minutes'),
('cart-001', 'PROD-004', 'Leche Entera 1L', 2, 4200, 8400, NOW() - INTERVAL '13 minutes'),
('cart-001', 'PROD-006', 'Papas Fritas 150g', 2, 3200, 6400, NOW() - INTERVAL '12 minutes'),
('cart-001', 'PROD-007', 'Chocolate Bar 50g', 4, 2500, 10000, NOW() - INTERVAL '11 minutes'),
('cart-001', 'PROD-010', 'Jugo Naranja 1L', 1, 5500, 5500, NOW() - INTERVAL '10 minutes');

-- Carrito 2: Carlos Rodríguez
INSERT INTO carts.carts (cart_id, session_id, total_amount, total_items, status, created_at, updated_at)
VALUES ('cart-002', 'session-002', 35900, 4, 'ACTIVE', NOW() - INTERVAL '8 minutes', NOW());

INSERT INTO carts.cart_items (cart_id, product_sku, product_name, quantity, unit_price, subtotal, created_at)
VALUES 
('cart-002', 'PROD-002', 'Agua Mineral 500ml', 6, 1500, 9000, NOW() - INTERVAL '7 minutes'),
('cart-002', 'PROD-003', 'Pan Integral 500g', 2, 3500, 7000, NOW() - INTERVAL '6 minutes'),
('cart-002', 'PROD-008', 'Café Instantáneo 100g', 1, 8500, 8500, NOW() - INTERVAL '5 minutes'),
('cart-002', 'PROD-009', 'Galletas Saladas 200g', 3, 3800, 11400, NOW() - INTERVAL '4 minutes');

-- Carrito 3: Cliente No Identificado
INSERT INTO carts.carts (cart_id, session_id, total_amount, total_items, status, created_at, updated_at)
VALUES ('cart-003', 'session-003', 9700, 3, 'ACTIVE', NOW() - INTERVAL '5 minutes', NOW());

INSERT INTO carts.cart_items (cart_id, product_sku, product_name, quantity, unit_price, subtotal, created_at)
VALUES 
('cart-003', 'PROD-001', 'Coca Cola 350ml', 2, 2000, 4000, NOW() - INTERVAL '4 minutes'),
('cart-003', 'PROD-006', 'Papas Fritas 150g', 1, 3200, 3200, NOW() - INTERVAL '3 minutes'),
('cart-003', 'PROD-007', 'Chocolate Bar 50g', 1, 2500, 2500, NOW() - INTERVAL '2 minutes');

-- Carrito 4: Ana Martínez (en caja)
INSERT INTO carts.carts (cart_id, session_id, total_amount, total_items, status, created_at, updated_at)
VALUES ('cart-004', 'session-004', 157100, 8, 'AT_CHECKOUT', NOW() - INTERVAL '20 minutes', NOW() - INTERVAL '2 minutes');

INSERT INTO carts.cart_items (cart_id, product_sku, product_name, quantity, unit_price, subtotal, created_at)
VALUES 
('cart-004', 'PROD-001', 'Coca Cola 350ml', 5, 2000, 10000, NOW() - INTERVAL '19 minutes'),
('cart-004', 'PROD-002', 'Agua Mineral 500ml', 10, 1500, 15000, NOW() - INTERVAL '18 minutes'),
('cart-004', 'PROD-004', 'Leche Entera 1L', 5, 4200, 21000, NOW() - INTERVAL '17 minutes'),
('cart-004', 'PROD-005', 'Yogurt Natural 200g', 8, 2800, 22400, NOW() - INTERVAL '16 minutes'),
('cart-004', 'PROD-006', 'Papas Fritas 150g', 6, 3200, 19200, NOW() - INTERVAL '15 minutes'),
('cart-004', 'PROD-007', 'Chocolate Bar 50g', 10, 2500, 25000, NOW() - INTERVAL '14 minutes'),
('cart-004', 'PROD-008', 'Café Instantáneo 100g', 3, 8500, 25500, NOW() - INTERVAL '13 minutes'),
('cart-004', 'PROD-009', 'Galletas Saladas 200g', 5, 3800, 19000, NOW() - INTERVAL '12 minutes');

-- Carrito 5: Luis Hernández
INSERT INTO carts.carts (cart_id, session_id, total_amount, total_items, status, created_at, updated_at)
VALUES ('cart-005', 'session-005', 7700, 2, 'ACTIVE', NOW() - INTERVAL '3 minutes', NOW());

INSERT INTO carts.cart_items (cart_id, product_sku, product_name, quantity, unit_price, subtotal, created_at)
VALUES 
('cart-005', 'PROD-003', 'Pan Integral 500g', 1, 3500, 3500, NOW() - INTERVAL '2 minutes'),
('cart-005', 'PROD-004', 'Leche Entera 1L', 1, 4200, 4200, NOW() - INTERVAL '1 minute');

-- ============================================
-- MODIFICACIONES DE CARRITO
-- ============================================

-- Modificaciones del carrito 1 (María García)
INSERT INTO carts.cart_modifications (cart_id, action, item_sku, old_quantity, new_quantity, operator_id, reason, created_at)
VALUES 
('cart-001', 'QUANTITY_ADJUSTED', 'PROD-007', 2, 4, 'OP-001', 'Cliente solicitó más unidades', NOW() - INTERVAL '11 minutes'),
('cart-001', 'QUANTITY_ADJUSTED', 'PROD-001', 2, 3, 'OP-001', 'Sistema ajustó por disponibilidad', NOW() - INTERVAL '9 minutes');

-- Modificaciones del carrito 4 (Ana - en caja)
INSERT INTO carts.cart_modifications (cart_id, action, item_sku, old_quantity, new_quantity, operator_id, reason, created_at)
VALUES 
('cart-004', 'QUANTITY_ADJUSTED', 'PROD-002', 5, 10, NULL, 'Cliente agregó más productos', NOW() - INTERVAL '18 minutes'),
('cart-004', 'QUANTITY_ADJUSTED', 'PROD-005', 4, 8, NULL, 'Cliente agregó más productos', NOW() - INTERVAL '16 minutes'),
('cart-004', 'STAFF_OVERRIDE', 'PROD-007', 5, 10, 'OP-002', 'Revisión de operador', NOW() - INTERVAL '3 minutes');

-- ============================================
-- RESUMEN DE DATOS CREADOS
-- ============================================
-- 5 Sesiones: 4 ACTIVE, 1 AT_CHECKOUT
-- 5 Carritos con diferentes cantidades de items
-- 5 Modificaciones de carrito para auditoría
-- ============================================

SELECT 
    (SELECT COUNT(*) FROM sessions.customer_sessions) AS sesiones_creadas,
    (SELECT COUNT(*) FROM carts.carts) AS carritos_creados,
    (SELECT COUNT(*) FROM carts.cart_items) AS items_en_carritos,
    (SELECT COUNT(*) FROM carts.cart_modifications) AS modificaciones;
