# 🛠️ Stack Tecnológico - Alwon POS System

## 📋 Resumen Ejecutivo

Alwon POS es un sistema Point of Sale moderno construido con arquitectura de microservicios, implementando las mejores prácticas de desarrollo empresarial.

---

## 🎯 Backend - Microservicios Java

### Core Framework
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Java** | 21 LTS | Lenguaje de programación principal |
| **Spring Boot** | 3.2.1 | Framework de aplicación |
| **Spring Cloud Gateway** | 2023.0.0 | API Gateway y enrutamiento |
| **Spring Data JPA** | 3.2.1 | Persistencia y ORM |
| **Spring AMQP** | 3.1.1 | Mensajería asíncrona |
| **Spring WebSocket** | 6.1.2 | Comunicación en tiempo real |
| **Spring Actuator** | 3.2.1 | Monitoreo y health checks |

### Gestión de Dependencias
- **Maven** 3.9+ - Build tool y gestión de dependencias
- **Lombok** 1.18.30 - Reducción de boilerplate code

### Documentación API
- **SpringDoc OpenAPI** 2.3.0 - Especificación OpenAPI 3.0
- **Swagger UI** - Interfaz interactiva de API

---

## 🗄️ Base de Datos

### Sistema de Gestión
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **PostgreSQL** | 15-alpine | Base de datos relacional principal |
| **Hibernate** | 6.4.1 | ORM (incluido en Spring Data JPA) |

### Esquemas Implementados
- `sessions` - Gestión de sesiones de clientes
- `carts` - Carritos de compra y productos
- `products` - Catálogo de productos y categorías
- `payments` - Transacciones de pago
- `camera` - Evidencia visual y reconocimiento facial
- `access` - Control de acceso y tipos de cliente
- `inventory` - Gestión de inventario y movimientos

**Total:** 7 esquemas, 13 tablas, 27 índices

---

## 📨 Mensajería y Eventos

### Message Broker
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **RabbitMQ** | 3-management | Message broker AMQP |
| **Spring RabbitTemplate** | - | Cliente de mensajería |

### Patrones Implementados
- **Event-Driven Architecture** - Comunicación entre microservicios
- **Publish/Subscribe** - Eventos de negocio
- **Async Messaging** - Procesamiento asíncrono

---

## ⚛️ Frontend - React PWA

### Core Framework
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **React** | 18.2.0 | Librería UI principal |
| **TypeScript** | 5.3.3 | Lenguaje tipado |
| **Vite** | 5.0.8 | Build tool y dev server |

### Estado y Routing
- **Zustand** 4.4.7 - Estado global
- **React Router** 6.21.1 - Navegación SPA

### Networking
- **Axios** 1.6.5 - Cliente HTTP
- **WebSocket** - Comunicación en tiempo real

### Estilos
- **CSS Modules** - Estilos con scope
- **Vanilla CSS** - Sistema de diseño custom

### PWA
- **Vite PWA Plugin** - Service workers
- **Manifest.json** - Configuración de instalación

---

## 🐳 Containerización y Orquestación

### Docker
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Docker** | 24+ | Containerización |
| **Docker Compose** | 2.23+ | Orquestación multi-contenedor |

### Imágenes Base Utilizadas
```yaml
- eclipse-temurin:21-jdk-alpine   # Backend services
- postgres:15-alpine               # PostgreSQL
- rabbitmq:3-management           # RabbitMQ
- node:18-alpine                  # Frontend build
```

---

## 🏗️ Arquitectura de Microservicios

### Servicios Implementados (9)

#### 1. API Gateway (Puerto 8080)
- **Función:** Punto de entrada único
- **Tech Stack:** Spring Cloud Gateway
- **Features:** Enrutamiento, CORS, Load Balancing

#### 2. Session Service (Puerto 8081)
- **Función:** Gestión de sesiones de clientes
- **Tech Stack:** Spring Boot + PostgreSQL + RabbitMQ
- **Features:** CRUD sesiones, estados, eventos

#### 3. Cart Service (Puerto 8082)
- **Función:** Carritos de compra
- **Tech Stack:** Spring Boot + PostgreSQL
- **Features:** Gestión de items, auditoría

#### 4. Product Service (Puerto 8083)
- **Función:** Catálogo de productos
- **Tech Stack:** Spring Boot + PostgreSQL
- **Features:** Productos, categorías, búsqueda

#### 5. Payment Service (Puerto 8084)
- **Función:** Procesamiento de pagos
- **Tech Stack:** Spring Boot + PostgreSQL
- **Features:** PSE, tarjetas débito/crédito (mock)

#### 6. Camera Service (Puerto 8085)
- **Función:** Reconocimiento facial
- **Tech Stack:** Spring Boot + PostgreSQL
- **Features:** Detección facial (mock), evidencia visual

#### 7. Access Service (Puerto 8086)
- **Función:** Control de acceso
- **Tech Stack:** Spring Boot + PostgreSQL
- **Features:** Tipos de cliente, validación

#### 8. Inventory Service (Puerto 8087)
- **Función:** Gestión de inventario
- **Tech Stack:** Spring Boot + PostgreSQL + RabbitMQ
- **Features:** Stock, movimientos, alertas

#### 9. WebSocket Server (Puerto 8090)
- **Función:** Comunicación en tiempo real
- **Tech Stack:** Spring WebSocket + RabbitMQ
- **Features:** Eventos push, notificaciones

---

## 🔧 Herramientas de Desarrollo

### Build y Compilación
- **Maven** - Build automation (backend)
- **npm** - Package manager (frontend)
- **PowerShell** - Scripts de automatización

### Control de Versiones
- **Git** 2.40+
- **GitHub** - Hosting y CI/CD

### IDEs Compatibles
- IntelliJ IDEA (recomendado para backend)
- Visual Studio Code (recomendado para frontend)
- Eclipse

---

## 📊 Características Técnicas Destacadas

### Seguridad (Planeado)
- [ ] Spring Security
- [ ] JWT Authentication
- [ ] OAuth 2.0
- [ ] HTTPS/TLS

### Observabilidad
- ✅ Spring Actuator health checks
- ✅ Structured logging (SLF4J + Logback)
- [ ] Distributed tracing (Zipkin/Sleuth)
- [ ] Metrics (Prometheus)

### Calidad de Código
- ✅ Lombok para código limpio
- ✅ TypeScript para type safety  
- ✅ JPA validation annotations
- [ ] Unit testing (JUnit 5)
- [ ] Integration testing

### Rendimiento
- ✅ Connection pooling (HikariCP)
- ✅ Lazy loading (JPA)
- ✅ Async messaging
- ✅ Vite HMR (dev)

---

## 📦 Versiones Mínimas Requeridas

### Runtime
```
Java: 21+
Node.js: 18+
PostgreSQL: 15+
RabbitMQ: 3.12+
Docker: 24+
Docker Compose: 2.20+
```

### Build Tools
```
Maven: 3.9+
npm: 9+
```

---

## 🗂️ Estructura del Proyecto

```
alwon-pos-system/
├── backend/                  # 9 microservicios Java
│   ├── api-gateway/
│   ├── session-service/
│   ├── cart-service/
│   ├── product-service/
│   ├── payment-service/
│   ├── camera-service/
│   ├── access-service/
│   ├── inventory-service/
│   └── websocket-server/
├── frontend/                 # React PWA
│   ├── src/
│   ├── public/
│   └── package.json
├── docker-compose.yml        # Orquestación
├── init-db.sql              # Schema PostgreSQL
└── docs/                    # Documentación
```

---

## 📈 Estadísticas del Proyecto

- **Líneas de código backend:** ~5,000+
- **Archivos Java:** 100+
- **Endpoints REST:** 50+
- **Entidades JPA:** 15+
- **Componentes React:** 10+
- **Servicios Docker:** 11

---

## 🔄 Estado de Implementación

### ✅ Completado
- 9 microservicios backend
- Frontend React PWA
- Base de datos PostgreSQL multi-schema
- Docker Compose setup
- API Gateway con CORS
- WebSocket real-time
- Documentación técnica

### 🚧 En Desarrollo
- Corrección de errores de compilación (Payment, Camera)
- Testing de integración completo
- Spring Security + JWT

### 📋 Roadmap
- Implementación de seguridad
- Tests automatizados (unit + integration)
- CI/CD pipeline
- Monitoreo y observabilidad
- Deployment a producción

---

## 📚 Referencias y Documentación

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [React Documentation](https://react.dev/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [RabbitMQ Documentation](https://www.rabbitmq.com/documentation.html)

---

## 👥 Contribución

Este stack tecnológico fue diseñado para ser:
- **Escalable:** Arquitectura de microservicios
- **Mantenible:** Código limpio y documentado
- **Moderno:** Tecnologías actuales y mejores prácticas
- **Robusto:** Validaciones, tipos fuertes, error handling

---

**Última actualización:** Diciembre 2023  
**Versión:** 1.0.0  
**Estado:** En Desarrollo Activo
