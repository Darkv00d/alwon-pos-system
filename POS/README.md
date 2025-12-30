# 🏪 Alwon POS - Sistema de Punto de Venta con IA

Sistema de punto de venta inteligente con reconocimiento facial, gestión automatizada de carritos y pagos PSE, diseñado para tiendas autónomas en edificios residenciales.

---

## 🎯 Características Principales

- ✅ **Reconocimiento Facial** - Identificación automática de clientes
- ✅ **3 Tipos de Cliente** - FACIAL, PIN, NO_ID
- ✅ **Gestión de Carritos** - Sistema automatizado con IA
- ✅ **Pagos PSE** - Integración con pagos en línea
- ✅ **Dashboard en Tiempo Real** - WebSocket para actualizaciones live
- ✅ **11 Microservicios** - Arquitectura escalable
- ✅ **Frontend Moderno** - React + TypeScript + Vite
- ✅ **21 Productos** - Canasta familiar colombiana

---

## 🏗️ Arquitectura

### Backend (Java 21 + Spring Boot 3.2.1)
- **API Gateway** (8080) - Punto de entrada único
- **Session Service** (8081) - Gestión de sesiones de cliente
- **Cart Service** (8082) - Gestión de carritos de compra
- **Product Service** (8083) - Catálogo de productos
- **Payment Service** (8084) - Procesamiento de pagos
- **Camera Service** (8085) - Reconocimiento facial
- **Access Service** (8086) - Control de acceso
- **Inventory Service** (8087) - Gestión de inventario
- **Auth Service** (8088) - Autenticación JWT
- **WebSocket Server** (8090) - Comunicación en tiempo real
- **External API** (9000) - Integración con sistemas externos

### Frontend (React 18 + TypeScript)
- **Dashboard** - Vista de sesiones activas
- **CartView** - Detalle de carrito de compras
- **Login Modal** - Autenticación de operadores
- **Payment View** - Procesamiento de pagos

### Infraestructura
- **PostgreSQL 15** - Base de datos principal
- **Redis 7** - Cache y sesiones
- **RabbitMQ 3** - Mensajería asíncrona
- **Docker** - Containerización

---

## 📚 Documentación

| Documento | Descripción |
|-----------|-------------|
| [API Documentation](docs/API_DOCUMENTATION.md) | Endpoints de todos los servicios |
| [Deployment Guide](docs/DEPLOYMENT_GUIDE.md) | Guía de instalación y deployment |
| [Testing Strategy](docs/TESTING_STRATEGY.md) | Estrategia de testing completa |
| [Master Backlog](docs/ALWON-MASTER-BACKLOG.md) | Estado del proyecto |
| [Feature Roadmap](docs/FEATURE-ROADMAP.md) | Plan de features |
| [Architecture](docs/ARQUITECTURA_MICROSERVICIOS.md) | Arquitectura del sistema |
| [Database Model](docs/diagrams/Database_Model_Diagram.md) | Modelo de datos |
| [Business Rules](docs/BUSINESS_RULES.md) | Reglas de negocio |

---

## 🚀 Quick Start

### Opción 1: Docker (Recomendado)

```bash
# 1. Iniciar infraestructura
docker-compose up -d postgres redis rabbitmq

# 2. Ejecutar scripts SQL
Get-Content init-auth-schema.sql | docker exec -i alwon-postgres psql -U alwon -d alwon_pos
Get-Content update-products-FINAL.sql | docker exec -i alwon-postgres psql -U alwon -d alwon_pos

# 3. Compilar servicios
cd backend
.\build-all.ps1

# 4. Iniciar todos los servicios
docker-compose up -d

# 5. Iniciar frontend
cd frontend
npm install
npm run dev
```

### Opción 2: Manual

Ver [DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md) para instrucciones detalladas.

---

## 🧪 Testing

```bash
# Verificar servicios backend
cd backend
.\verify-services.ps1

# Tests completos
# Ver TESTING_STRATEGY.md para todos los tests
```

---

## 📊 Estado del Proyecto

| Componente | Estado | Progreso |
|------------|--------|----------|
| Backend | ✅ Completo | 11/11 servicios |
| Frontend | ✅ Completo | 11/11 User Stories |
| Base de Datos | ✅ Completo | 7/7 schemas |
| Integración | ✅ Completo | API ajustada |
| Documentación | ✅ Completo | 100% |
| Testing | ⚠️ Parcial | 3/11 servicios |
| Deployment | 📝 Documentado | Listo para deploy |

---

## 🔑 Credenciales de Prueba

### Operador Admin
- **Usuario:** `admin`
- **Password:** `admin123`

### Base de Datos
- **Host:** `localhost:5432`
- **Database:** `alwon_pos`
- **Usuario:** `alwon`
- **Password:** `alwon2024`

### RabbitMQ
- **Management UI:** `http://localhost:15672`
- **Usuario:** `alwon`
- **Password:** `alwon2024`

---

## 📱 URLs Importantes

### Frontend
- **Aplicación:** `http://localhost:5173`

### Backend
- **API Gateway:** `http://localhost:8080`
- **Swagger Auth Service:** `http://localhost:8088/swagger-ui.html`
- **Swagger Session Service:** `http://localhost:8081/swagger-ui.html`
- **Swagger Product Service:** `http://localhost:8083/swagger-ui.html`

### Monitoring
- **RabbitMQ Management:** `http://localhost:15672`

---

## 🛠️ Tecnologías

### Backend
- Java 21
- Spring Boot 3.2.1
- Spring Data JPA
- Spring Cloud Gateway
- RabbitMQ
- PostgreSQL
- Redis
- JWT (io.jsonwebtoken)
- Lombok
- Swagger/OpenAPI

### Frontend
- React 18
- TypeScript
- Vite
- Zustand (state management)
- Axios
- React Router

### DevOps
- Docker & Docker Compose
- Maven
- npm

---

## 📝 User Stories Implementadas

### Dashboard
1. ✅ Visualización de productos para NO_ID
2. ✅ Torre y apartamento para clientes identificados
3. ✅ Cálculo correcto de items y total
4. ✅ Ocultar Session ID técnico
5. ✅ Popup de autenticación de operador
6. ✅ Productos de canasta familiar

### Carrito
7. ✅ Header informativo de cliente
8. ✅ Alineación de controles de cantidad
9. ✅ Botones Suspender/Cancelar más grandes
10. ✅ Botón "Continuar al Pago" prominente
11. ✅ Resumen visual mejorado

---

## 🔒 Seguridad

- ✅ Autenticación JWT
- ✅ BCrypt para passwords
- ✅ Rate limiting (3 intentos)
- ✅ CORS configurado
- ⚠️ HTTPS pendiente (producción)
- ⚠️ Spring Security completo (pendiente)

---

## 🐛 Troubleshooting

Ver [DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md#troubleshooting) para soluciones comunes.

---

## 👥 Contribuir

1. Fork el proyecto
2. Crear feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

---

## 📄 Licencia

© 2025 Alwon. Todos los derechos reservados.

---

## 📞 Soporte

Para soporte técnico, consultar la documentación o contactar al equipo de desarrollo.

---

**Última actualización:** 2025-12-28  
**Versión:** 1.0.0
