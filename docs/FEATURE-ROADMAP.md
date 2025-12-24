# Feature Roadmap - Alwon POS Frontend

**Última actualización:** 2025-12-23  
**Versión:** 1.0

---

## 🎯 Epics y Features

### Epic 1: Mejoras de Dashboard Principal
**Objetivo:** Mejorar la experiencia visual y funcional del dashboard de sesiones activas

#### Features

##### F-001: Visualización de Productos en Tarjetas
- **User Stories:** US-001
- **Puntos:** 5
- **Estado:** 📝 Pendiente
- **Descripción:** Mostrar imágenes de productos en las tarjetas de clientes NO_ID
- **Beneficio:** Los clientes pueden ver qué se les está cargando

##### F-002: Información de Ubicación del Cliente
- **User Stories:** US-002
- **Puntos:** 3
- **Estado:** 📝 Pendiente
- **Descripción:** Mostrar Torre y Apartamento para clientes identificados
- **Beneficio:** Operador puede confirmar ubicación de entrega rápidamente

##### F-003: Métrica Precisa de Carritos
- **User Stories:** US-003
- **Puntos:** 3
- **Estado:** 📝 Pendiente
- **Descripción:** Calcular y mostrar cantidades y totales correctos
- **Beneficio:** Información precisa del estado de compras

##### F-004: Autenticación de Operador
- **User Stories:** US-005
- **Puntos:** 5
- **Estado:** 📝 Pendiente
- **Descripción:** Modal de login para operadores con acceso a cierre de caja
- **Beneficio:** Control de acceso a funciones administrativas

---

### Epic 2: Mejoras de Página de Carrito
**Objetivo:** Optimizar la UX de la página de carrito para facilitar el proceso de compra

#### Features

##### F-005: Header Informativo de Cliente
- **User Stories:** US-007
- **Puntos:** 3
- **Estado:** 📝 Pendiente
- **Descripción:** Mostrar nombre, torre y apartamento en header del carrito
- **Beneficio:** Confirmación rápida de identidad del cliente

##### F-006: Controles de Cantidad Mejorados
- **User Stories:** US-008
- **Puntos:** 2
- **Estado:** 📝 Pendiente
- **Descripción:** Alineación correcta de botones +/- y display de cantidad
- **Beneficio:** Interfaz profesional y usable

##### F-007: Jerarquía Visual de Acciones
- **User Stories:** US-009, US-010
- **Puntos:** 5
- **Estado:** 📝 Pendiente
- **Descripción:** Botón de pago prominente, botones secundarios balanceados
- **Beneficio:** Flujo de compra claro y obvio

##### F-008: Resumen de Compra Claro
- **User Stories:** US-011
- **Puntos:** 3
- **Estado:** 📝 Pendiente
- **Descripción:** Subtotal, descuentos y total destacados
- **Beneficio:** Cliente revisa compra fácilmente antes de pagar

---

### Epic 3: Datos de Prueba Realistas
**Objetivo:** Usar datos de productos relevantes al contexto colombiano

#### Features

##### F-009: Productos de Canasta Familiar
- **User Stories:** US-006
- **Puntos:** 2
- **Estado:** 📝 Pendiente
- **Descripción:** Reemplazar productos de ejemplo con canasta familiar
- **Beneficio:** Demos más realistas y contextualizadas

**Productos incluidos:**
- Huevos
- Gaseosas
- Pan
- Leche
- Arroz
- Aceite
- Azúcar
- Sal
- Café
- Pasta

---

## 📊 Planificación por Sprints

### Sprint 1 (Semana 1) - Fundamentos
**Puntos:** 8  
**Features:**
- ✅ F-003: Métrica Precisa de Carritos (3 pts) - Crítico
- ✅ F-009: Productos de Canasta Familiar (2 pts) - Rápido
- ✅ F-004: Simplificar UI (US-004) (1 pt) - Rápido
- ✅ F-006: Controles de Cantidad (2 pts) - Mejora UX

**Entregables:**
- Dashboard muestra valores correctos
- Productos realistas en base de datos
- Interfaz más limpia

---

### Sprint 2 (Semana 2) - Características del Cliente
**Puntos:** 11  
**Features:**
- ⏳ F-002: Información de Ubicación (3 pts) - Backend required
- ⏳ F-001: Visualización de Productos (5 pts) - Backend required
- ⏳ F-005: Header Informativo (3 pts) - Depende de F-002

**Entregables:**
- Torre y apartamento visibles
- Imágenes de productos en tarjetas NO_ID
- Header de carrito completo

**Dependencias Backend:**
- Agregar campos `tower` y `apartment` a `CustomerSession`
- Incluir `cart Items` en `SessionResponse`

---

### Sprint 3 (Semana 3) - UX y Funcionalidad Administrativa
**Puntos:** 10  
**Features:**
- ⏳ F-007: Jerarquía Visual de Acciones (5 pts)
- ⏳ F-004: Autenticación de Operador (5 pts)
- ⏳ F-008: Resumen de Compra (3 pts) - Si da tiempo

**Entregables:**
- Botones de carrito rediseñados
- Modal de login de operador funcional
- Resumen visual mejorado (opcional)

---

## 🔄 Dependencias

### Cambios en Backend Necesarios

#### 1. Session Service - Agregar Campos

```java
// CustomerSession.java
@Column(name = "tower")
private String tower;

@Column(name = "apartment")
private String apartment;

// SessionResponse.java
private String tower;
private String apartment;
private Integer itemCount;      // Calculado
private BigDecimal totalAmount; // Calculado
private List<CartItemDto> cartItems; // Para mostrar en Dashboard
```

#### 2. Base de Datos - Migración

```sql
ALTER TABLE sessions.customer_sessions 
ADD COLUMN tower VARCHAR(50),
ADD COLUMN apartment VARCHAR(20);

UPDATE sessions.customer_sessions 
SET tower = 'Torre 3', apartment = '501' 
WHERE session_id = 'SES-001';
```

#### 3. Datos de Prueba - Productos

Actualizar `init-db.sql` con productos de canasta familiar.

---

## 📈 Métricas de Éxito

### Dashboard
- [ ] Accuracy: 100% de sesiones muestran valores correctos
- [ ] Claridad: 0 sessionIds técnicos visibles
- [ ] Información: 100% de clientes identificados muestran torre/apto

### Carrito
- [ ] Usabilidad: Botón de pago es 2x más grande que secundarios
- [ ] Precisión: Controles de cantidad alineados en todos los browsers
- [ ] Conversión: Tiempo para completar compra reduce en 20%

### General
- [ ] Performance: Página carga en < 2 segundos
- [ ] Responsive: Funciona en móviles y tablets
- [ ] Accesibilidad: Score WCAG AA en Lighthouse

---

## 🚀 Releases Planeados

### v1.1.0 - "Mejoras de UX Básicas"
**Fecha objetivo:** 2025-01-10  
**Incluye:**
- Sprint 1 completado
- Valores correctos en dashboard
- Productos realistas

### v1.2.0 - "Información Completa del Cliente"
**Fecha objetivo:** 2025-01-24  
**Incluye:**
- Sprint 1 + 2 completados
- Torre y apartamento visibles
- Imágenes de productos

### v1.3.0 - "Optimización de Carrito"
**Fecha objetivo:** 2025-02-07  
**Incluye:**
- Todos los sprints completados
- UX de carrito optimizada
- Autenticación de operador

---

## 📝 Notas

### Decisiones de Diseño

1. **Formato de Moneda:** Usar separador de miles (.) y decimales (,) estilo colombiano
2. **Colores de Estado:** 
   - 🟢 Verde (#10B981) para FACIAL
   - 🟡 Amarillo (#F59E0B) para PIN
   - 🔴 Rojo (#EF4444) para NO_ID
3. **Botón Principal:** Verde para acciones positivas (pagar, continuar)
4. **Iconos:** Usar emojis para máxima compatibilidad

### Consideraciones Futuras

- **Integración con PSE:** El botón de pago eventualmente inicia flujo PSE
- **Cierre de Caja:** La funcionalidad completa se implementará en v2.0
- **Multi-idioma:** Preparar strings para i18n desde el inicio
- **Tema Oscuro:** Considerar para versión futura

---

## 📚 Referencias

- [User Stories Dashboard](./user-stories/US-FRONTEND-001-Dashboard-Improvements.md)
- [User Stories Carrito](./user-stories/US-FRONTEND-002-Cart-Page-Improvements.md)
- [Guía de Estilo UI (pendiente)](./ui-style-guide.md)
- [Arquitectura Frontend (pendiente)](./frontend-architecture.md)
