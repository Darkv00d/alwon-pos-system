-- ============================================
-- Alwon POS - Auth Service Database Schema
-- ============================================
-- Creado: 25 Diciembre 2025
-- Propósito: Sistema de autenticación de operadores con PIN temporal
-- ============================================

-- Create schema if not exists
CREATE SCHEMA IF NOT EXISTS auth;

-- ============================================
-- Tabla: Operators
-- Almacena información de operadores del POS
-- ============================================
CREATE TABLE IF NOT EXISTS auth.operators (
    operator_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role VARCHAR(20) DEFAULT 'OPERATOR' CHECK (role IN ('OPERATOR', 'SUPERVISOR', 'ADMIN')),
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_login_at TIMESTAMP NULL
);

-- Índices para optimizar consultas
CREATE INDEX idx_operators_username ON auth.operators(username);
CREATE INDEX idx_operators_email ON auth.operators(email);
CREATE INDEX idx_operators_active ON auth.operators(active);

-- ============================================
-- Tabla: Operator Sessions (JWT Tokens)
-- Track de sesiones activas de operadores
-- ============================================
CREATE TABLE IF NOT EXISTS auth.operator_sessions (
    session_id SERIAL PRIMARY KEY,
    operator_id INT NOT NULL REFERENCES auth.operators(operator_id) ON DELETE CASCADE,
    token_jti VARCHAR(255) UNIQUE NOT NULL, -- JWT Token ID
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP NOT NULL,
    revoked BOOLEAN DEFAULT false,
    revoked_at TIMESTAMP NULL
);

CREATE INDEX idx_sessions_operator ON auth.operator_sessions(operator_id);
CREATE INDEX idx_sessions_token ON auth.operator_sessions(token_jti);
CREATE INDEX idx_sessions_active ON auth.operator_sessions(revoked, expires_at);

-- ============================================
-- Tabla: Audit Log
-- Registro de acciones administrativas
-- ============================================
CREATE TABLE IF NOT EXISTS auth.audit_log (
    log_id BIGSERIAL PRIMARY KEY,
    operator_id INT REFERENCES auth.operators(operator_id) ON DELETE SET NULL,
    action VARCHAR(50) NOT NULL, -- LOGIN, LOGOUT, CLOSE_DAY, VIEW_SALES, etc.
    entity_type VARCHAR(50), --  SESSION, CART, PAYMENT, REPORT
    entity_id VARCHAR(100),
    details JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    success BOOLEAN DEFAULT true,
    error_message TEXT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_audit_operator ON auth.audit_log(operator_id);
CREATE INDEX idx_audit_action ON auth.audit_log(action);
CREATE INDEX idx_audit_created ON auth.audit_log(created_at DESC);

-- ============================================
-- Tabla: PIN Attempts (Tracking de intentos fallidos)
-- Backup si Redis falla, para limitar intentos
-- ============================================
CREATE TABLE IF NOT EXISTS auth.pin_attempts (
    attempt_id BIGSERIAL PRIMARY KEY,
    operator_id INT NOT NULL REFERENCES auth.operators(operator_id) ON DELETE CASCADE,
    attempt_time TIMESTAMP DEFAULT NOW(),
    success BOOLEAN DEFAULT false,
    ip_address VARCHAR(45)
);

CREATE INDEX idx_pin_attempts_operator ON auth.pin_attempts(operator_id);
CREATE INDEX idx_pin_attempts_time ON auth.pin_attempts(attempt_time DESC);

-- ============================================
-- Función: Update timestamp automáticamente
-- ============================================
CREATE OR REPLACE FUNCTION auth.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para operators
CREATE TRIGGER update_operators_updated_at 
    BEFORE UPDATE ON auth.operators 
    FOR EACH ROW 
    EXECUTE FUNCTION auth.update_updated_at_column();

-- ============================================
-- Datos iniciales: Operadores de prueba
-- ============================================
-- Nota: Passwords están hasheados con BCrypt
-- Password plano: alwon2025

INSERT INTO auth.operators (username, password_hash, full_name, email, phone, role) VALUES
('carlos.martinez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhqa', 'Carlos Martínez', 'carlos.martinez@alwon.com', '+57 300 123 4567', 'OPERATOR'),
('ana.rodriguez', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhqa', 'Ana Rodríguez', 'ana.rodriguez@alwon.com', '+57 301 234 5678', 'SUPERVISOR'),
('luis.garcia', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhqa', 'Luis García', 'luis.garcia@alwon.com', '+57 302 345 6789', 'ADMIN')
ON CONFLICT (username) DO NOTHING;

-- ============================================
-- Comentarios de tablas y columnas
-- ============================================
COMMENT ON SCHEMA auth IS 'Schema para autenticación de operadores del POS';

COMMENT ON TABLE auth.operators IS 'Operadores del POS con credenciales y roles';
COMMENT ON COLUMN auth.operators.password_hash IS 'Hash BCrypt del password (costo 10)';
COMMENT ON COLUMN auth.operators.role IS 'OPERATOR: operaciones básicas, SUPERVISOR: reportes, ADMIN: configuración';

COMMENT ON TABLE auth.operator_sessions IS 'Sesiones activas de operadores (JWT tokens)';
COMMENT ON COLUMN auth.operator_sessions.token_jti IS 'JWT ID (jti claim) para blacklist';

COMMENT ON TABLE auth.audit_log IS 'Log de auditoría de acciones administrativas';

COMMENT ON TABLE auth.pin_attempts IS 'Registro de intentos de PIN (backup de Redis)';

-- ============================================
-- Grants (ajustar según usuarios de BD)
-- ============================================
-- GRANT ALL PRIVILEGES ON SCHEMA auth TO alwon_auth_service;
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA auth TO alwon_auth_service;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA auth TO alwon_auth_service;

-- ============================================
-- Verificación de datos
-- ============================================
SELECT 
    'Operators created' as info,
    count(*) as total_count,
    count(*) FILTER (WHERE active = true) as active_count
FROM auth.operators;
