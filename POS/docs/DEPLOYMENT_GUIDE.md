# Alwon POS - Deployment Guide

**Versión:** 1.0.0  
**Última actualización:** 2025-12-28  
**Autor:** Equipo Alwon

---

## 📋 Pre-requisitos

### Software Requerido
- **Java 21** (JDK)
- **Maven 3.9+**
- **Docker & Docker Compose** (recomendado)
- **Node.js 18+** y **npm**
- **PostgreSQL 15** (o usar Docker)
- **Redis 7** (para Auth Service)
- **RabbitMQ 3** (para mensajería)

### Puertos Necesarios
Asegúrese de que los siguientes puertos estén disponibles:

| Puerto | Servicio |
|--------|----------|
| 5432 | PostgreSQL |
| 6379 | Redis |
| 5672 | RabbitMQ |
| 15672 | RabbitMQ Management |
| 8080 | API Gateway |
| 8081 | Session Service |
| 8082 | Cart Service |
| 8083 | Product Service |
| 8084 | Payment Service |
| 8085 | Camera Service |
| 8086 | Access Service |
| 8087 | Inventory Service |
| 8088 | Auth Service |
| 8090 | WebSocket Server |
| 9000 | External API |
| 5173 | Frontend (Dev) |

---

## 🚀 Opción 1: Deployment con Docker (Recomendado)

### Paso 1: Preparar Scripts SQL

```bash
cd c:\Users\algam\.gemini\antigravity\scratch\Alwon\POS
```

Verificar que existen los siguientes archivos:
- `init-db.sql` (schema principal)
- `init-auth-schema.sql` (schema de autenticación)
- `test-data.sql` (datos de prueba)
- `update-products-FINAL.sql` (21 productos canasta familiar)

### Paso 2: Iniciar Infraestructura Base

```bash
docker-compose up -d postgres redis rabbitmq
```

**Verificar:**
```bash
# PostgreSQL
docker exec -it alwon-postgres psql -U alwon -d alwon_pos -c "SELECT 1;"

# Redis
docker exec -it alwon-redis redis-cli -a alwon2024 ping

# RabbitMQ
curl http://localhost:15672
# Usuario: alwon, Password: alwon2024
```

### Paso 3: Ejecutar Scripts SQL

```bash
# Windows PowerShell
$env:PGPASSWORD="alwon2024"

# Schema principal (ya se ejecuta automáticamente con Docker)
# Si es necesario ejecutar manualmente:
Get-Content init-db.sql | docker exec -i alwon-postgres psql -U alwon -d alwon_pos

# Schema de autenticación
Get-Content init-auth-schema.sql | docker exec -i alwon-postgres psql -U alwon -d alwon_pos

# Productos canasta familiar
Get-Content update-products-FINAL.sql | docker exec -i alwon-postgres psql -U alwon -d alwon_pos

# Datos de prueba (si lo desea)
Get-Content test-data.sql | docker exec -i alwon-postgres psql -U alwon -d alwon_pos
```

### Paso 4: Compilar Servicios Backend

```bash
cd backend

# API Gateway
cd api-gateway
mvn clean package -DskipTests
cd ..

# Session Service
cd session-service
mvn clean package -DskipTests
cd ..

# Cart Service
cd cart-service
mvn clean package -DskipTests
cd ..

# Product Service
cd product-service
mvn clean package -DskipTests
cd ..

# Payment Service
cd payment-service
mvn clean package -DskipTests
cd ..

# Camera Service
cd camera-service
mvn clean package -DskipTests
cd ..

# Access Service
cd access-service
mvn clean package -DskipTests
cd ..

# Inventory Service
cd inventory-service
mvn clean package -DskipTests
cd ..

# Auth Service
cd auth-service
mvn clean package -DskipTests
cd ..

# External API Service
cd external-api-service
mvn clean package -DskipTests
cd ..

# WebSocket Server
cd websocket-server
mvn clean package -DskipTests
cd ..
```

**O compilar todos a la vez:**
```bash
cd backend
.\build-all.ps1
```

### Paso 5: Iniciar Servicios

**Opción A: Con Docker Compose (todos los servicios)**
```bash
docker-compose up -d
```

**Opción B: Manual (solo backend, frontend aparte)**
```bash
# En ventanas separadas de PowerShell:

# 1. API Gateway
cd backend\api-gateway
mvn spring-boot:run

# 2. Session Service
cd backend\session-service
mvn spring-boot:run

# 3. Cart Service
cd backend\cart-service
mvn spring-boot:run

# 4. Product Service
cd backend\product-service
mvn spring-boot:run

# 5. Payment Service
cd backend\payment-service
mvn spring-boot:run

# 6. Camera Service
cd backend\camera-service
mvn spring-boot:run

# 7. Access Service
cd backend\access-service
mvn spring-boot:run

# 8. Inventory Service
cd backend\inventory-service
mvn spring-boot:run

# 9. Auth Service
cd backend\auth-service
mvn spring-boot:run

# 10. WebSocket Server
cd backend\websocket-server
mvn spring-boot:run

# 11. External API Service
cd backend\external-api-service
mvn spring-boot:run
```

### Paso 6: Verificar Servicios

```bash
cd backend
.\verify-services.ps1
```

**O verificar manualmente:**
```bash
# Session Service
curl http://localhost:8081/actuator/health

# Cart Service
curl http://localhost:8082/actuator/health

# Product Service
curl http://localhost:8083/actuator/health

# Payment Service
curl http://localhost:8084/actuator/health

# Camera Service
curl http://localhost:8085/actuator/health

# Access Service
curl http://localhost:8086/actuator/health

# Inventory Service
curl http://localhost:8087/actuator/health

# Auth Service
curl http://localhost:8088/actuator/health

# WebSocket Server
curl http://localhost:8090/actuator/health

# External API Service
curl http://localhost:9000/actuator/health

# API Gateway (debe mostrar las rutas)
curl http://localhost:8080/actuator/gateway/routes
```

### Paso 7: Iniciar Frontend

```bash
cd frontend
npm install
npm run dev
```

Frontend estará disponible en: `http://localhost:5173`

---

## 🔧 Opción 2: Deployment Manual (Sin Docker)

### 1. Instalar PostgreSQL

```bash
# Descargar desde: https://www.postgresql.org/download/windows/
# Crear base de datos
psql -U postgres
CREATE DATABASE alwon_pos;
CREATE USER alwon WITH PASSWORD 'alwon2024';
GRANT ALL PRIVILEGES ON DATABASE alwon_pos TO alwon;
\q
```

### 2. Ejecutar Scripts SQL

```bash
psql -U alwon -d alwon_pos -f init-db.sql
psql -U alwon -d alwon_pos -f init-auth-schema.sql
psql -U alwon -d alwon_pos -f update-products-FINAL.sql
```

### 3. Instalar Redis

```bash
# Windows: Descargar desde https://github.com/microsoftarchive/redis/releases
# O usar Docker:
docker run -d -p 6379:6379 --name alwon-redis redis:7-alpine redis-server --requirepass alwon2024
```

### 4. Instalar RabbitMQ

```bash
# Descargar desde: https://www.rabbitmq.com/download.html
# O usar Docker:
docker run -d -p 5672:5672 -p 15672:15672 --name alwon-rabbitmq \
  -e RABBITMQ_DEFAULT_USER=alwon \
  -e RABBITMQ_DEFAULT_PASS=alwon2024 \
  rabbitmq:3-management-alpine
```

### 5. Configurar Variables de Entorno

Crear archivo `backend/.env`:
```env
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/alwon_pos
SPRING_DATASOURCE_USERNAME=alwon
SPRING_DATASOURCE_PASSWORD=alwon2024
SPRING_RABBITMQ_HOST=localhost
SPRING_RABBITMQ_PORT=5672
SPRING_RABBITMQ_USERNAME=alwon
SPRING_RABBITMQ_PASSWORD=alwon2024
SPRING_DATA_REDIS_HOST=localhost
SPRING_DATA_REDIS_PORT=6379
SPRING_DATA_REDIS_PASSWORD=alwon2024
JWT_SECRET=your-super-secret-jwt-key-change-in-production-min-256-bits
JWT_EXPIRATION_MS=28800000
```

### 6. Iniciar Servicios

Seguir los mismos pasos del "Paso 5" de la Opción 1.

---

## 🧪 Validación Post-Deployment

### 1. Backend Health Checks

```bash
# Script automático
cd backend
.\verify-services.ps1
```

### 2. Test de Integración Básico

```bash
# 1. Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# 2. Get Products
curl http://localhost:8080/api/products

# 3. Get Active Sessions
curl http://localhost:8080/api/sessions/active
```

### 3. Test Frontend

1. Abrir `http://localhost:5173`
2. Verificar que Dashboard carga
3. Click en badge "Operador"
4. Login con `admin` / `admin123`
5. Verificar que aparece botón "Cierre de Caja"

---

## 📊 Monitoring

### Swagger UI (Documentación API)

- Auth Service: `http://localhost:8088/swagger-ui.html`
- Session Service: `http://localhost:8081/swagger-ui.html`
- Product Service: `http://localhost:8083/swagger-ui.html`
- Cart Service: `http://localhost:8082/swagger-ui.html`
- Payment Service: `http://localhost:8084/swagger-ui.html`

### RabbitMQ Management

- URL: `http://localhost:15672`
- Usuario: `alwon`
- Password: `alwon2024`

### Actuator Endpoints

Todos los servicios exponen:
- `/actuator/health` - Estado del servicio
- `/actuator/info` - Información del servicio
- `/actuator/metrics` - Métricas

---

## 🐛 Troubleshooting

### Error: Puerto ya en uso

```bash
# Windows: Liberar puerto
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Error: No se puede conectar a PostgreSQL

```bash
# Verificar que PostgreSQL está corriendo
docker ps | grep postgres

# Ver logs
docker logs alwon-postgres
```

### Error: Connection refused (RabbitMQ)

```bash
# Verificar RabbitMQ
docker logs alwon-rabbitmq

# Reiniciar
docker restart alwon-rabbitmq
```

### Error: Compilación falla

```bash
# Limpiar caché Maven
mvn clean install -U

# Verificar versión Java
java -version
# Debe ser Java 21
```

---

## 🔐 Seguridad para Producción

### Cambios Obligatorios

1. **JWT Secret:** Cambiar en `.env`:
   ```env
   JWT_SECRET=<generar-clave-256-bits-aleatoria>
   ```

2. **Passwords de Base de Datos:**
   ```env
   POSTGRES_PASSWORD=<password-fuerte>
   REDIS_PASSWORD=<password-fuerte>
   RABBITMQ_PASSWORD=<password-fuerte>
   ```

3. **HTTPS:** Configurar certificados SSL

4. **CORS:** Restringir origins permitidos

5. **Rate Limiting:** Ajustar límites en Auth Service

---

## 📝 Notas Importantes

- **No ejecutar con `-DskipTests` en producción**
- **Configurar backups automáticos de PostgreSQL**
- **Monitorear logs de todos los servicios**
- **Implementar rotación de logs**
- **Configurar alertas de salud de servicios**

---

**Deployment completado exitosamente** ✅

Para soporte: contactar al equipo de desarrollo
