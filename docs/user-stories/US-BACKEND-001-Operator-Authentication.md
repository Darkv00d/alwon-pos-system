# User Stories - Backend Authentication

**Fecha:** 2025-12-24  
**Versión:** 1.0  
**Estado:** Pendiente

---

## Epic: Sistema de Autenticación de Operadores

### Contexto
Los operadores de la tienda deben autenticarse al iniciar su turno para:
- Acceder al sistema POS
- Registrar sus acciones en logs de auditoría
- Habilitar la modificación de carritos
- Asociar transacciones a su sesión de trabajo

---

## US-BACKEND-001: Endpoint de Login de Operador

**Como** operador de la tienda  
**Quiero** autenticarme con mi usuario y contraseña  
**Para que** el sistema registre mi sesión de trabajo y me otorgue acceso

### Criterios de Aceptación

- [ ] Endpoint `POST /api/auth/login` disponible
- [ ] Acepta `{ "username": string, "password": string }`
- [ ] Valida credenciales contra tabla `operators` en BD
- [ ] Retorna JWT token con duración de 8 horas (turno laboral)
- [ ] Token incluye claims: `operatorId`, `name`, `role`, `storeId`
- [ ] Si credenciales incorrectas, retorna 401 con mensaje claro
- [ ] Si cuenta bloqueada (3+ intentos fallidos), retorna 403
- [ ] Registra en log tabla `operator_sessions`: inicio de sesión, IP, timestamp

### Detalles Técnicos

**Service:** `auth-service` (nuevo microservicio)  
**Database:** Schema `auth`  
**Tabla:** `operators`

```sql
CREATE TABLE auth.operators (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL, -- 'CASHIER', 'SUPERVISOR', 'ADMIN'
    store_id INTEGER NOT NULL,
    verification_code VARCHAR(6) NOT NULL, -- Para modificar carritos
    active BOOLEAN DEFAULT true,
    failed_login_attempts INTEGER DEFAULT 0,
    last_failed_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE auth.operator_sessions (
    id SERIAL PRIMARY KEY,
    operator_id INTEGER REFERENCES auth.operators(id),
    login_at TIMESTAMP DEFAULT NOW(),
    logout_at TIMESTAMP,
    ip_address VARCHAR(45),
    user_agent TEXT,
    token_jti VARCHAR(50) UNIQUE -- JWT ID para revocación
);
```

**Response Exitoso:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "operator": {
      "id": 1,
      "username": "jperez",
      "name": "Juan Pérez",
      "role": "CASHIER",
      "verificationCode": "123456"
    },
    "expiresIn": 28800
  }
}
```

**Endpoint:** `POST /api/auth/login`  
**Estimación:** 5 Story Points

---

## US-BACKEND-002: Middleware de Validación de JWT

**Como** desarrollador del sistema  
**Quiero** un middleware que valide el JWT en cada request  
**Para que** solo operadores autenticados accedan a endpoints protegidos

### Criterios de Aceptación

- [ ] Middleware valida presencia de header `Authorization: Bearer <token>`
- [ ] Verifica firma del JWT con secret key de la aplicación
- [ ] Valida que token no haya expirado
- [ ] Valida que token no esté revocado (checkear `token_jti` en tabla)
- [ ] Inyecta datos del operador en request context para uso en controllers
- [ ] Si token inválido/expirado, retorna 401 Unauthorized
- [ ] Permite configurar rutas públicas (whitelist) sin autenticación

### Detalles Técnicos

**Implementación:** Interceptor de Spring Security  
**Configuración:** `application.yml`

```yaml
jwt:
  secret: ${JWT_SECRET}
  expiration: 28800 # 8 horas en segundos
  
security:
  public-endpoints:
    - /api/auth/login
    - /api/health
    - /actuator/**
```

**Uso en Controllers:**
```java
@GetMapping("/protected")
public ResponseEntity<?> getProtectedData(@AuthenticatedOperator Operator operator) {
    // operator inyectado automáticamente desde JWT
    return ResponseEntity.ok(Map.of("operatorName", operator.getName()));
}
```

**Estimación:** 3 Story Points

---

## US-BACKEND-003: Endpoint de Logout

**Como** operador  
**Quiero** cerrar sesión al terminar mi turno  
**Para que** mi token sea revocado y no pueda ser usado nuevamente

### Criterios de Aceptación

- [ ] Endpoint `POST /api/auth/logout` disponible
- [ ] Requiere JWT válido en header Authorization
- [ ] Registra `logout_at` en tabla `operator_sessions`
- [ ] Invalida el token añadiéndolo a lista de revocación (Redis o BD)
- [ ] Retorna 200 OK con mensaje de confirmación
- [ ] Si token ya inválido, retorna 401

### Detalles Técnicos

**Revocación de Token:**  
Usar Redis para almacenar JTIs revocados con TTL = tiempo hasta expiración original.

```java
@PostMapping("/logout")
public ResponseEntity<?> logout(@AuthenticatedOperator Operator operator, 
                                 @RequestHeader("Authorization") String authHeader) {
    String token = authHeader.substring(7); // Remove "Bearer "
    tokenRevocationService.revoke(token);
    sessionService.recordLogout(operator.getSessionId());
    return ResponseEntity.ok(Map.of("message", "Sesión cerrada exitosamente"));
}
```

**Endpoint:** `POST /api/auth/logout`  
**Estimación:** 2 Story Points

---

## US-BACKEND-004: Registro de Auditoría de Acciones

**Como** administrador  
**Quiero** que todas las acciones críticas de los operadores sean registradas  
**Para que** pueda auditar modificaciones a carritos y transacciones

### Criterios de Aceptación

- [ ] Tabla`audit_logs` creada en schema `auth`
- [ ] Se registra automáticamente cuando un operador:
  - Modifica cantidad de items en carrito
  - Elimina items del carrito
  - Cancela una transacción
  - Suspende una sesión
  - Sobrescribe precio de producto
- [ ] Cada log incluye: timestamp, operatorId, action, entityType, entityId, oldValue, newValue, ipAddress
- [ ] Logs son inmutables (solo INSERT, no UPDATE/DELETE)

### Detalles Técnicos

```sql
CREATE TABLE auth.audit_logs (
    id SERIAL PRIMARY KEY,
    operator_id INTEGER REFERENCES auth.operators(id),
    action VARCHAR(50) NOT NULL, -- 'CART_ITEM_MODIFIED', 'CART_ITEM_REMOVED'
    entity_type VARCHAR(50) NOT NULL, -- 'CART', 'SESSION', 'PAYMENT'
    entity_id VARCHAR(100) NOT NULL,
    old_value JSONB,
    new_value JSONB,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_audit_operator ON auth.audit_logs(operator_id);
CREATE INDEX idx_audit_created_at ON auth.audit_logs(created_at DESC);
```

**Ejemplo de Log:**
```json
{
  "operatorId": 1,
  "action": "CART_ITEM_QUANTITY_CHANGED",
  "entityType": "CART_ITEM",
  "entityId": "cart-001-item-123",
  "oldValue": {"quantity": 2},
  "newValue": {"quantity": 5},
  "ipAddress": "192.168.1.100",
  "createdAt": "2025-12-24T10:30:00Z"
}
```

**Estimación:** 5 Story Points

---

## US-BACKEND-005: Validación de Código de Verificación para Modificar Carritos

**Como** sistema  
**Quiero** validar el código de verificación del operador antes de permitir modificaciones  
**Para que** solo operadores autorizados con conocimiento del código puedan editar carritos

### Criterios de Aceptación

- [ ] Endpoint `POST /api/auth/verify-code` disponible
- [ ] Acepta `{ "operatorId": number, "verificationCode": string }`
- [ ] Valida que el código coincida con el almacenado en BD
- [ ] Retorna 200 OK si código correcto
- [ ] Retorna 403 Forbidden si código incorrecto
- [ ] Incrementa contador de intentos fallidos (máx 3 por sesión)
- [ ] Registra intento en audit_logs

### Detalles Técnicos

**Endpoint:** `POST /api/auth/verify-code`

```json
// Request
{
  "operatorId": 1,
  "verificationCode": "123456"
}

// Response (éxito)
{
  "success": true,
  "message": "Código verificado correctamente",
  "operatorName": "Juan Pérez"
}

// Response (error)
{
  "success": false,
  "message": "Código incorrecto. 2 intentos restantes.",
  "attemptsRemaining": 2
}
```

**Estimación:** 2 Story Points

---

## US-BACKEND-006: Endpoint de Refresh Token

**Como** operador  
**Quiero** que mi sesión se renueve automáticamente si sigo activo  
**Para que** no tenga que hacer login nuevamente durante mi turno de 8+ horas

### Criterios de Aceptación

- [ ] Endpoint `POST /api/auth/refresh` disponible
- [ ] Acepta token actual en Authorization header
- [ ] Si token válido pero próximo a expirar (< 1 hora restante), emite nuevo token
- [ ] Nuevo token tiene mismos claims pero nueva expiración (+8 horas)
- [ ] Invalida token anterior
- [ ] Retorna nuevo token en response
- [ ] Si token ya expirado, retorna 401 (debe hacer login nuevamente)

### Detalles Técnicos

**Frontend Usage:**  
Llamar automáticamente cada 7 horas (antes de expiración).

```typescript
// Frontend hook
useEffect(() => {
  const refreshInterval = setInterval(async () => {
    const newToken = await authApi.refreshToken();
    localStorage.setItem('operator_token', newToken);
  }, 7 * 60 * 60 * 1000); // 7 horas
  
  return () => clearInterval(refreshInterval);
}, []);
```

**Endpoint:** `POST /api/auth/refresh`  
**Estimación:** 3 Story Points

---

## Estimación Total

| US | Descripción | Story Points |
|----|-------------|--------------|
| US-BACKEND-001 | Login de Operador | 5 |
| US-BACKEND-002 | Middleware JWT | 3 |
| US-BACKEND-003 | Logout | 2 |
| US-BACKEND-004 | Auditoría | 5 |
| US-BACKEND-005 | Verificación Código | 2 |
| US-BACKEND-006 | Refresh Token | 3 |
| **TOTAL** | | **20 SP** |

**Velocidad estimada:** 8-10 SP por sprint  
**Duración:** 2 sprints (~4 semanas)

---

## Orden de Implementación Sugerido

1. **Sprint 1 (Autenticación Básica):**
   - US-BACKEND-001: Login ✅
   - US-BACKEND-002: Middleware JWT ✅
   - US-BACKEND-003: Logout ✅

2. **Sprint 2 (Seguridad y Auditoría):**
   - US-BACKEND-004: Audit Logs ✅
   - US-BACKEND-005: Verificación Código ✅
   - US-BACKEND-006: Refresh Token ✅

---

## Dependencias

### Backend Nuevos
- Microservicio `auth-service` (Spring Boot)
- Librería JWT: `io.jsonwebtoken:jjwt`
- Redis para revocación de tokens (opcional, puede usar BD)

### Base de Datos
- Schema `auth`
- Tablas: `operators`, `operator_sessions`, `audit_logs`

### Frontend
- Almacenar JWT en localStorage
- Interceptor Axios para inyectar token en headers
- Hook de auto-refresh
- Redirección a login si 401

---

## Notas de Seguridad

1. **Passwords:** Usar BCrypt con factor 12+ para hashing
2. **JWT Secret:** Almacenar en variable de entorno, NUNCA en código
3. **HTTPS:** Obligatorio en producción para transmitir tokens
4. **Rate Limiting:** Limitar intentos de login (5 por minuto máx)
5. **Código de Verificación:** Generar aleatoriamente, cambiar cada 30 días
6. **Audit Logs:** Retención de 2 años mínimo por regulaciones

---

## Integración con US Frontend

Esta implementación backend complementa:
- **US-005 (Frontend):** Modal de login consume `POST /api/auth/login`
- **US-007 (Frontend):** Header muestra datos de `operator` desde JWT
- **Modificar Carrito (Frontend):** Valida código con `POST /api/auth/verify-code`
