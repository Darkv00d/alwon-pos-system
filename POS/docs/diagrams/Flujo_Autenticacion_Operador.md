# Flujo de Autenticación de Operador - Alwon POS

## Versión 1.0 (25 Diciembre 2025)

Este documento describe el flujo completo del sistema de autenticación de operadores con PIN temporal de 2 niveles.

---

## 🎯 Resumen del Sistema

**Tipo:** Autenticación de 2 niveles (Usuario/Password + PIN)  
**Tecnología:** Spring Boot + Redis + Twilio + SendGrid  
**Seguridad:** BCrypt + JWT + TTL automático  
**Tiempo de vida:** 8 horas por PIN  

---

## 📊 Flujo Completo de Autenticación

```mermaid
sequenceDiagram
    participant U as Usuario (Operador)
    participant F as Frontend (React)
    participant G as Gateway :8080
    participant A as Auth Service :8088
    participant C as Sistema Central
    participant R as Redis :6379
    participant N as NotificationService
    participant T as Twilio (WhatsApp)
    participant S as SendGrid (Email)
    participant DB as PostgreSQL

    %% ========================================
    %% FASE 1: LOGIN INICIAL
    %% ========================================
    Note over U,DB: FASE 1: LOGIN INICIAL
    
    U->>F: 1. Ingresa usuario y contraseña
    F->>G: POST /api/auth/login<br/>{username, password}
    G->>A: Forward request
    
    %% Validación contra Sistema Central
    A->>C: POST /operators/validate<br/>{username, password}
    
    alt Credenciales Válidas
        C-->>A: {valid: true, operator: {...}}
        
        %% Generar PIN
        A->>A: Generar PIN aleatorio (6 dígitos)
        Note over A: PIN: "472915"
        
        %% Hashear y guardar en Redis
        A->>A: pinHash = BCrypt.hash(pin)
        A->>R: SET pin:operator:123<br/>{pinHash, attempts:0}<br/>TTL: 28800s (8h)
        R-->>A: OK
        
        %% Guardar sesión en PostgreSQL
        A->>DB: INSERT operator_sessions<br/>{operator_id, token_jti, ...}
        DB-->>A: OK
        
        %% Enviar notificaciones ASYNC
        par Notificaciones Paralelas
            A->>N: sendPinViaWhatsApp(phone, name, pin)
            N->>T: WhatsApp API
            T-->>N: {sent: true, sid: "..."}
            N-->>A: {sent: true}
        and
            A->>N: sendPinViaEmail(email, name, pin)
            N->>S: SendGrid API
            S-->>N: {status: 202}
            N-->>A: {sent: true}
        end
        
        %% Generar JWT
        A->>A: token = JWT.create({operatorId: 123})
        
        %% Respuesta exitosa
        A-->>G: 200 OK<br/>{success: true, operator, token, pin, notifications}
        G-->>F: Forward response
        
        %% Frontend muestra PIN
        F->>F: Guardar token en localStorage
        F->>U: Mostrar PIN por 5 segundos
        Note over U,F: PIN: 472915<br/>✓ WhatsApp enviado<br/>✓ Email enviado
        
    else Credenciales Inválidas
        C-->>A: {valid: false}
        A-->>G: 401 Unauthorized
        G-->>F: Forward error
        F->>U: "Usuario o contraseña incorrectos"
    end

    %% ========================================
    %% FASE 2: VALIDACIÓN DE PIN
    %% ========================================
    Note over U,DB: FASE 2: VALIDACIÓN DE PIN
    
    U->>F: 2. Ingresa PIN en teclado numérico
    F->>G: POST /api/auth/validate-pin<br/>{pin: "472915"}<br/>Authorization: Bearer {token}
    G->>A: Forward with JWT
    
    %% Verificar JWT
    A->>A: Extraer operatorId del JWT
    
    %% Obtener datos de Redis
    A->>R: GET pin:operator:123
    R-->>A: {pinHash: "$2a$10...", attempts: 0}
    
    %% Validar PIN
    A->>A: BCrypt.compare(pin, pinHash)
    
    alt PIN Correcto
        A->>R: UPDATE attempts = 0
        A->>DB: INSERT audit_log<br/>{action: "PIN_VALIDATED"}
        A-->>G: 200 OK<br/>{valid: true, operator: {...}}
        G-->>F: Forward response
        F->>U: Abrir Menú Administrativo
        Note over U: ✅ Acceso Concedido
        
    else PIN Incorrecto
        A->>R: INCREMENT attempts (1, 2, 3...)
        
        alt Intentos < 3
            A-->>G: 401 Unauthorized<br/>{valid: false, attemptsRemaining: 2}
            G-->>F: Forward
            F->>U: "PIN incorrecto. 2 intentos restantes"
            Note over U: ⚠️ Intento fallido
            
        else Intentos >= 3
            A->>R: DELETE pin:operator:123
            A->>DB: INSERT audit_log<br/>{action: "MAX_ATTEMPTS_EXCEEDED"}
            A-->>G: 429 Too Many Requests<br/>{requiresLogin: true}
            G-->>F: Forward
            F->>F: Limpiar estado
            F->>U: "Máximo de intentos alcanzado.<br/>Inicia sesión nuevamente"
            Note over U: ❌ Bloqueado - Requiere nuevo login
        end
    end

    %% ========================================
    %% FASE 3: USO DEL MENÚ ADMIN
    %% ========================================
    Note over U,DB: FASE 3: USO DEL MENÚ ADMIN
    
    U->>F: 3. Selecciona opción<br/>(Cierre/Ventas/Pérdidas)
    F->>G: Request con JWT
    G->>A: Verificar sesión activa
    A->>DB: Query operator_sessions
    DB-->>A: Session válida
    A-->>G: 200 OK
    
    %% Registrar acción
    A->>DB: INSERT audit_log<br/>{action: "VIEW_SALES"}
    
    %% ========================================
    %% FASE 4: LOGOUT
    %% ========================================
    Note over U,DB: FASE 4: LOGOUT
    
    U->>F: 4. Cierra sesión
    F->>G: POST /api/auth/logout<br/>Authorization: Bearer {token}
    G->>A: Forward
    
    A->>R: DELETE pin:operator:123
    A->>DB: UPDATE operator_sessions<br/>SET revoked = true
    A->>DB: INSERT audit_log<br/>{action: "LOGOUT"}
    
    A-->>G: 200 OK
    G-->>F: Forward
    F->>F: Limpiar localStorage
    F->>U: Redirigir a pantalla inicial
```

---

## 🔐 Detalles de Seguridad

### 1. Pin Generation
```java
// Genera números de 100000 a 999999
Random random = new Random();
int pin = 100000 + random.nextInt(900000);
```

### 2. PIN Storage en Redis
**Key:** `pin:operator:{operatorId}`

**Value (JSON):**
```json
{
  "pinHash": "$2a$10$N9qo8uLOickgx2ZMRZoMye...",
  "attempts": 0,
  "createdAt": "2025-12-25T12:30:00",
  "expiresAt": "2025-12-25T20:30:00"
}
```

**TTL:** 28800 segundos (8 horas)

### 3. PIN Validation
```java
// BCrypt compare
boolean isValid = passwordEncoder.matches(pin, storedPinHash);
```

### 4. JWT Token
**Claims:**
```json
{
  "sub": "123",
  "username": "carlos.martinez",
  "role": "OPERATOR",
  "iat": 1703512800,
  "exp": 1703541600
}
```

**Expiración:** 8 horas (28800000 ms)

---

## 📱 Notificaciones

### WhatsApp (Twilio)
**Plantilla:**
```
🔐 *Alwon POS*

Hola Carlos Martínez,

Tu PIN temporal es: *472915*

Este PIN es válido por 8 horas.

No compartas este código con nadie.
```

### Email (SendGrid)
**HTML Template:**
- Logo de Alwon POS
- PIN destacado con tipografía grande
- Validez de 8 horas
- Aviso de seguridad

**Máscaras de Privacidad:**
- Phone: `+57 300 123 4567` → `***-***-4567`
- Email: `carlos@alwon.com` → `c***@alwon.com`

---

## ⚠️ Manejo de Errores

### Error 1: Credenciales Inválidas
**Status:** 401 Unauthorized  
**Response:**
```json
{
  "success": false,
  "error": "INVALID_CREDENTIALS",
  "message": "Usuario o contraseña incorrectos"
}
```

### Error 2: PIN Incorrecto (< 3 intentos)
**Status:** 401 Unauthorized  
**Response:**
```json
{
  "success": false,
  "valid": false,
  "attemptsRemaining": 2,
  "message": "PIN incorrecto"
}
```

### Error 3: Máximo de Intentos
**Status:** 429 Too Many Requests  
**Response:**
```json
{
  "success": false,
  "error": "MAX_ATTEMPTS_EXCEEDED",
  "message": "Máximo de intentos alcanzado. Por favor inicia sesión nuevamente.",
  "requiresLogin": true
}
```

### Error 4: PIN Expirado
**Status:** 401 Unauthorized  
**Response:**
```json
{
  "success": false,
  "error": "PIN_EXPIRED",
  "message": "PIN expirado. Inicia sesión nuevamente.",
  "requiresLogin": true
}
```

### Error 5: Rate Limit Excedido
**Status:** 429 Too Many Requests  
**Response:**
```json
{
  "error": "RATE_LIMIT_EXCEEDED",
  "message": "Demasiadas solicitudes. Intenta de nuevo en 60 segundos."
}
```

**Límite:** 5 intentos por minuto

---

## 🔄 Estados del Sistema

```mermaid
stateDiagram-v2
    [*] --> NoAutenticado
    
    NoAutenticado --> LoginEnProgreso: Usuario ingresa credenciales
    LoginEnProgreso --> PinGenerado: Credenciales válidas
    LoginEnProgreso --> NoAutenticado: Credenciales inválidas
    
    PinGenerado --> ValidandoPin: Usuario ingresa PIN
    ValidandoPin --> Autenticado: PIN correcto
    ValidandoPin --> PinGenerado: PIN incorrecto (< 3 intentos)
    ValidandoPin --> NoAutenticado: MAX_ATTEMPTS_EXCEEDED
    
    Autenticado --> MenuAdministrativo: Acceso concedido
    MenuAdministrativo --> Autenticado: Realizar acciones
    MenuAdministrativo --> NoAutenticado: Logout
    
    PinGenerado --> NoAutenticado: PIN expirado (8h)
    Autenticado --> NoAutenticado: Token expirado
```

---

## ⏱️ Tiempos y TTLs

| Componente | Duración | Notas |
|------------|----------|-------|
| **PIN TTL** | 8 horas | Expira automáticamente en Redis |
| **JWT Token** | 8 horas | Mismo tiempo que el PIN |
| **Auto-cierre PIN Display** | 5 segundos | Frontend cierra modal automáticamente |
| **Rate Limit** | 5 req/min | Por IP en endpoint login |
| **Timeout Sistema Central** | 5 segundos | Timeout para validación de usuario |
| **Timeout Redis** | 60 segundos | Configurado en connection factory |

---

## 📊 Audit Log

Todas las acciones se registran en `auth.audit_log`:

**Acciones registradas:**
- `LOGIN` - Login exitoso
- `LOGIN_FAILED` - Credenciales inválidas
- `PIN_GENERATED` - PIN generado
- `PIN_VALIDATED` - PIN validado correctamente
- `PIN_FAILED` - Intento de PIN incorrecto
- `MAX_ATTEMPTS_EXCEEDED` - Máximo de intentos alcanzado
- `LOGOUT` - Cierre de sesión
- `VIEW_SALES` - Ver ventas del día
- `CLOSE_DAY` - Cierre del día
- `VIEW_LOSSES` - Ver pérdidas del día

**Estructura del log:**
```sql
INSERT INTO auth.audit_log (
  operator_id,
  action,
  entity_type,
  entity_id,
  details,
  ip_address,
  user_agent,
  success,
  created_at
) VALUES (
  123,
  'PIN_VALIDATED',
  'PIN',
  NULL,
  '{"attempts": 1}',
  '192.168.1.100',
  'Mozilla/5.0...',
  true,
  NOW()
);
```

---

## 🚀 Endpoints del API

### 1. POST `/api/auth/login`
**Descripción:** Login y generación de PIN  
**Auth:** No (público)  
**Rate Limit:** 5 req/min  

### 2. POST `/api/auth/validate-pin`
**Descripción:** Validación de PIN  
**Auth:** Sí (JWT Bearer)  
**Rate Limit:** 10 req/min  

### 3. POST `/api/auth/logout`
**Descripción:** Cierre de sesión  
**Auth:** Sí (JWT Bearer)  
**Rate Limit:** No  

### 4. GET `/api/auth/session`
**Descripción:** Verificar sesión activa  
**Auth:** Sí (JWT Bearer)  
**Rate Limit:** No  

---

## 🔧 Configuración Requerida

### Variables de Entorno

```bash
# Sistema Central
CENTRAL_SYSTEM_URL=https://central.alwon.com
CENTRAL_API_KEY=your_api_key

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your_password

# Twilio (WhatsApp)
TWILIO_ACCOUNT_SID=ACxxxxxxxxx
TWILIO_AUTH_TOKEN=your_token
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886
TWILIO_ENABLED=true

# SendGrid (Email)
SENDGRID_API_KEY=SG.xxxxxxxxx
SENDGRID_FROM_EMAIL=noreply@alwon.com
SENDGRID_ENABLED=true

# JWT
JWT_SECRET=change_this_in_production
JWT_EXPIRATION_MS=28800000

# PIN
PIN_EXPIRATION_HOURS=8
MAX_PIN_ATTEMPTS=3
```

---

## 📈 Métricas de Performance

| Operación | Tiempo Esperado | Notas |
|-----------|----------------|-------|
| Login (completo) | < 2 segundos | Incluye validación + PIN + notificaciones |
| Validación Sistema Central | < 500ms | Depende de red |
| Generación PIN | < 10ms | Local |
| Redis SET/GET | < 1ms | Red local |
| Notificación WhatsApp | 1-3 segundos | Async, no bloquea |
| Notificación Email | 1-2 segundos | Async, no bloquea |
| Validación PIN | < 50ms | BCrypt + Redis |

---

**Documento actualizado:** 25 de Diciembre, 2025  
**Versión:** 1.0  
**Autor:** Alwon POS Team
