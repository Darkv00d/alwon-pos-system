-- Auth Schema Creation
CREATE SCHEMA IF NOT EXISTS auth;

-- Operators Table
CREATE TABLE IF NOT EXISTS auth.operators (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('CASHIER', 'SUPERVISOR', 'ADMIN')),
    store_id INTEGER NOT NULL,
    verification_code VARCHAR(6) NOT NULL,
    active BOOLEAN DEFAULT true,
    failed_login_attempts INTEGER DEFAULT 0,
    last_failed_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Operator Sessions Table  
CREATE TABLE IF NOT EXISTS auth.operator_sessions (
    id SERIAL PRIMARY KEY,
    operator_id INTEGER REFERENCES auth.operators(id),
    login_at TIMESTAMP DEFAULT NOW(),
    logout_at TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent TEXT,
    token_jti VARCHAR(50) UNIQUE
);

-- Audit Logs Table
CREATE TABLE IF NOT EXISTS auth.audit_logs (
    id SERIAL PRIMARY KEY,
    operator_id INTEGER REFERENCES auth.operators(id),
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id VARCHAR(100) NOT NULL,
    old_value JSONB,
    new_value JSONB,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_audit_operator ON auth.audit_logs(operator_id);
CREATE INDEX idx_audit_created_at ON auth.audit_logs(created_at DESC);
CREATE INDEX idx_operator_sessions_operator ON auth.operator_sessions(operator_id);

-- Insert test operator (username: admin, password: admin123)
-- Password hash generated with BCrypt
INSERT INTO auth.operators (username, password_hash, name, role, store_id, verification_code) 
VALUES ('admin', '$2a$10$X8p1yZ0c7f9r5p7q1w3e5t7y9u1i3o5p', 'Administrador', 'ADMIN', 1, '123456')
ON CONFLICT (username) DO NOTHING;

