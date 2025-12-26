# Arquitectura de Microservicios - Alwon POS

## Versión Actualizada (25 Diciembre 2025)

Sistema Alwon POS con separación clara de integraciones entrantes y salientes.

```mermaid
graph TB
    %% Estilos
    classDef incoming fill:#FFE6E6,stroke:#FF6B6B,stroke-width:4px,color:#000
    classDef outgoing fill:#E8DAEF,stroke:#9673a6,stroke-width:3px,color:#000
    classDef frontend fill:#D5F4E6,stroke:#82b366,stroke-width:3px,color:#000
    classDef gateway fill:#D6EAF8,stroke:#6c8ebf,stroke-width:3px,color:#000
    classDef microservice fill:#FCF3CF,stroke:#d79b00,stroke-width:3px,color:#000
    classDef auth fill:#D4EDDA,stroke:#28a745,stroke-width:3px,color:#000
    classDef database fill:#FADBD8,stroke:#c73232,stroke-width:3px,color:#000
    classDef broker fill:#F5EEF8,stroke:#af7ac5,stroke-width:3px,color:#000
    classDef redis fill:#FFE6CC,stroke:#FF6B35,stroke-width:3px,color:#000
    
    %% CAPA 0: INTEGRACIONES ENTRANTES
    subgraph CAPA0["📥 CAPA 0: INTEGRACIONES ENTRANTES"]
        CONCENTRADOR["Concentrador IA<br/>(Reconocimiento + Tracking)"]:::outgoing
        EXTAPI["External API :9000<br/><br/>POST /external/customer<br/>POST /external/purchase"]:::incoming
    end
    
    %% CAPA 1: FRONTEND
    subgraph CAPA1["💻 CAPA 1: FRONTEND"]
        PWA["React PWA :3000<br/><br/>• Dashboard<br/>• Cart View<br/>• Payment<br/>• Auth ✨"]:::frontend
    end
    
    %% CAPA 2: GATEWAY
    subgraph CAPA2["🚪 CAPA 2: GATEWAY"]
        GW["API Gateway :8080<br/><br/>/api/sessions/*<br/>/api/carts/*<br/>/api/products/*<br/>/api/payments/*<br/>/api/auth/* ✨"]:::gateway
    end
    
    %% CAPA 3: MICROSERVICIOS
    subgraph CAPA3["⚙️ CAPA 3: MICROSERVICIOS INTERNOS"]
        SESSION["Session :8081"]:::microservice
        CART["Cart :8082"]:::microservice
        PRODUCT["Product :8083"]:::microservice
        PAYMENT["Payment :8084"]:::microservice
        ACCESS["Access :8085"]:::microservice
        INVENTORY["Inventory :8087"]:::microservice
        AUTH["✨ Auth :8088<br/><br/>• Login<br/>• PIN gen<br/>• JWT<br/>• Notif ✨"]:::auth
        WS["WebSocket :8090"]:::microservice
    end
    
    %% CAPA 4: PERSISTENCIA
    subgraph CAPA4["💾 CAPA 4: PERSISTENCIA"]
        POSTGRES[("PostgreSQL :5432<br/><br/>• sessions<br/>• carts<br/>• products<br/>• payments<br/>• access<br/>• inventory<br/>• auth ✨")]:::database
        REDIS[("Redis :6379<br/><br/>PIN Storage<br/>TTL: 8h")]:::redis
        RABBIT["RabbitMQ<br/>:5672 / :15672"]:::broker
    end
    
    %% CAPA 5: INTEGRACIONES SALIENTES
    subgraph CAPA5["📤 CAPA 5: INTEGRACIONES SALIENTES"]
        CENTRAL["Sistema Central<br/>(Validación usuarios)"]:::outgoing
        TWILIO["Twilio WhatsApp"]:::outgoing
        SENDGRID["SendGrid Email"]:::outgoing
        PSE["PSE Pagos"]:::outgoing
    end
    
    %% CONEXIONES CAPA 0
    CONCENTRADOR ==>|"Cliente + Productos"| EXTAPI
    EXTAPI -->|"Crear sesión"| SESSION
    EXTAPI -->|"Consultar precios"| PRODUCT
    EXTAPI -->|"Añadir items"| CART
    
    %% CONEXIONES FRONTEND
    PWA -->|"REST API"| GW
    PWA -.->|"WebSocket"| WS
    
    %% GATEWAY → MICROSERVICIOS
    GW -->|"/api/sessions/*"| SESSION
    GW -->|"/api/carts/*"| CART
    GW -->|"/api/products/*"| PRODUCT
    GW -->|"/api/payments/*"| PAYMENT
    GW -->|"/api/access/*"| ACCESS
    GW -->|"/api/auth/*"| AUTH
    
    %% AUTH → CAPA 5 (SALIENTES)
    AUTH -->|"Validar"| CENTRAL
    AUTH -->|"WhatsApp PIN"| TWILIO
    AUTH -->|"Email PIN"| SENDGRID
    
    %% PAYMENT → CAPA 5
    PAYMENT -->|"Procesar pago"| PSE
    
    %% WEBSOCKET
    WS -.->|"Events"| SESSION
    WS -.->|"Updates"| CART
    WS -.->|"Status"| PAYMENT
    
    %% INTER-MICROSERVICES
    CART -->|"Session info"| SESSION
    CART -->|"Product details"| PRODUCT
    PAYMENT -->|"Cart total"| CART
    PAYMENT -->|"Session data"| SESSION
    INVENTORY -->|"Update stock"| PRODUCT
    
    %% PERSISTENCIA
    SESSION -->|"sessions"| POSTGRES
    CART -->|"carts"| POSTGRES
    PRODUCT -->|"products"| POSTGRES
    PAYMENT -->|"payments"| POSTGRES
    ACCESS -->|"access"| POSTGRES
    INVENTORY -->|"inventory"| POSTGRES
    AUTH -->|"auth"| POSTGRES
    AUTH -->|"PIN hash"| REDIS
    
    %% EVENT BUS
    SESSION -.->|"Publish"| RABBIT
    CART -.->|"Publish"| RABBIT
    PAYMENT -.->|"Publish"| RABBIT
    AUTH -.->|"Publish"| RABBIT
    RABBIT -.->|"Consume"| WS
    RABBIT -.->|"Consume"| INVENTORY
```

---

## 📊 Estructura de Capas

### 📥 Capa 0: Integraciones Entrantes
**Sistemas que NOS LLAMAN**
- Concentrador IA → External API :9000

### 💻 Capa 1-4: Sistema Core
- **Capa 1:** Frontend React PWA
- **Capa 2:** API Gateway  
- **Capa 3:** Microservicios (Session, Cart, Product, Payment, Auth, etc.)
- **Capa 4:** Persistencia (PostgreSQL, Redis, RabbitMQ)

### 📤 Capa 5: Integraciones Salientes
**Sistemas que NOSOTROS LLAMAMOS**
- Sistema Central - Validación de operadores
- Twilio - WhatsApp (PIN)
- SendGrid - Email (PIN)
- PSE - Pagos

---

## ✨ Auth Service (Puerto 8088)

**Responsabilidades:**
- Login con usuario/contraseña
- Generación de PIN temporal (6 dígitos)
- Envío directo a Twilio (WhatsApp)
- Envío directo a SendGrid (Email)
- Almacenamiento en Redis (hash BCrypt, TTL 8h)
- JWT tokens
- Audit log

**Endpoints:**
- `POST /auth/login`
- `POST /auth/validate-pin`
- `POST /auth/logout`
- `GET /auth/session`

---

## � Decisiones de Arquitectura

### ❌ Eliminado:
- **Notification Service** (Puerto 8089) → Simplicidad

### ✅ Auth Service ahora:
- Llama **directamente** a Twilio WhatsApp API
- Llama **directamente** a SendGrid Email API
- Reduce latencia y complejidad

### 🏗️ Separación de Capas:
- **Capa 0:** Solo ENTRANTES (quién nos llama)
- **Capa 5:** Solo SALIENTES (a quién llamamos)
- Claridad en flujo de datos

---

**Actualizado:** 25 Diciembre 2025  
**Motor:** Mermaid v9+
