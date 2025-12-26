# US-FRONTEND-004: CartView Tablet-Optimized Redesign

**Fecha de Creación:** 2025-12-26  
**Autor:** Antigravity AI  
**Estado:** 📝 Aprobado - Pendiente de Implementación  
**Prioridad:** Alta  
**Sprint:** 3  
**Estimación:** 13 puntos

---

## 🎯 Contexto

El CartView actual muestra productos en una lista horizontal que no aprovecha eficientemente el espacio de una tablet. El objetivo es rediseñar la vista del carrito para que sea más visual, compacta y permita al operador ver la mayor cantidad de productos posible en una sola pantalla.

**Referencia de Diseño:** `cart_view_mockup.html` (Mockup aprobado)

---

## 📐 Arquitectura General

### Layout Principal (2 Columnas)

```
┌────────────────────────────────────────────────────────┐
│  Header: [← Volver]    [🔒 Modificar Carrito]         │
├────────────────────────────────────────────────────────┤
│  Customer Info Rectangle (Horizontal)                  │
├───────────────────────────────┬────────────────────────┤
│  Productos (Grid 3 cols)      │  Resumen de Compra     │
│  🥛 🍞 🥚                      │  - Total items         │
│  🍚 🥤 🧀                      │  - Subtotal            │
│  ...                          │  - IVA                 │
│                               │  - TOTAL               │
│  [← 1 2 3 →]                  │                        │
│                               │  [💳 PAGAR] (Grande)   │
│                               │  [⏸️ Suspender]        │
│                               │  [❌ Cancelar]         │
└───────────────────────────────┴────────────────────────┘
```

---

## 📋 User Stories Detalladas

### US-FRONTEND-004.1: Customer Info Horizontal Rectangle

**Como** operador  
**Quiero** ver la información del cliente en un rectángulo horizontal compacto  
**Para** identificar rápidamente a quién pertenece el carrito sin ocupar mucho espacio vertical

#### Criterios de Aceptación

- [ ] El componente de información del cliente se muestra como un rectángulo horizontal
- [ ] Incluye los siguientes elementos:
  - Avatar circular (64x64px)
  - Nombre del cliente
  - **Torre y Apartamento** en formato "📍 Torre X - Apto YYY" (para clientes FACIAL/PIN)
  - Badge de tipo de cliente (FACIAL/PIN/NO_ID) con color distintivo
  - Session ID
- [ ] Borde izquierdo de color según tipo de cliente:
  - 🟢 Verde: FACIAL
  - 🟡 Amarillo: PIN
  - 🔴 Rojo: NO_ID
- [ ] El componente es responsive y se adapta al ancho de la pantalla
- [ ] Sigue el design system de Alwon (fondo blanco, sombras sutiles)

#### Componentes Afectados
- `CustomerInfo.tsx` (nuevo) o modificar sección en `CartView.tsx`

#### Datos Requeridos
```typescript
interface CustomerDisplayInfo {
  clientType: 'FACIAL' | 'PIN' | 'NO_ID';
  customerName?: string;
  customerPhotoUrl?: string;
  tower?: string;
  apartment?: string;
  sessionId: string;
}
```

---

### US-FRONTEND-004.2: Product Grid (3 Columns)

**Como** operador  
**Quiero** ver los productos del carrito en un grid de 3 columnas con cartas visuales compactas  
**Para** visualizar más productos simultáneamente en la pantalla de la tablet

#### Criterios de Aceptación

- [ ] Los productos se muestran en un grid de 3 columnas
- [ ] Cada carta de producto incluye:
  - **Imagen del producto** (140px altura, emoji placeholder si no hay imagen)
  - **Nombre del producto** (truncado con ellipsis si es muy largo)
  - **Cantidad** en badge destacado (azul claro)
  - **Precio unitario** (gris, tamaño menor)
  - **Impuesto** con formato "IVA (X%): $Y.YYY" (texto pequeño, gris)
  - **Total del producto** (verde, tamaño grande, alineado a la derecha)
- [ ] Las cartas tienen:
  - Fondo blanco
  - Bordes redondeados (12px)
  - Sombra sutil
  - Efecto hover (elevación + sombra)
- [ ] El grid es responsive:
  - 3 columnas en tablet landscape (por defecto)
  - 2 columnas en tablet portrait
- [ ] Máximo 6 productos por página

#### Componentes Afectados
- `ProductCard.tsx` (nuevo)
- `CartView.tsx` (layout)

#### Datos Requeridos
```typescript
interface CartItem {
  productId: string;
  productName: string;
  productImageUrl?: string;
  quantity: number;
  unitPrice: number;
  taxRate: number; // 0.19 para 19%, 0.05 para 5%
  taxAmount: number;
  totalAmount: number;
}
```

---

### US-FRONTEND-004.3: Pagination (Minimalist)

**Como** operador  
**Quiero** navegar entre páginas de productos usando flechas y números de página  
**Para** ver todos los productos del carrito cuando hay más de 6

#### Criterios de Aceptación

- [ ] La paginación se muestra debajo del grid de productos
- [ ] Incluye:
  - Botón flecha izquierda `←` (deshabilitado en página 1)
  - Números de página clickeables (ej: 1, 2, 3)
  - Botón flecha derecha `→` (deshabilitado en última página)
- [ ] El número de página activa se destaca con fondo azul (`hsl(195 100% 50%)`)
- [ ] Los números de página inactivos tienen fondo blanco con borde gris
- [ ] Diseño minimalista con botones compactos (40px min-width)
- [ ] Máximo 6 productos por página
- [ ] La navegación es funcional (cambia productos mostrados)

#### Componentes Afectados
- `Pagination.tsx` (nuevo)
- `CartView.tsx` (estado de paginación)

#### Estado Requerido
```typescript
const [currentPage, setCurrentPage] = useState(1);
const itemsPerPage = 6;
const totalPages = Math.ceil(cartItems.length / itemsPerPage);
```

---

### US-FRONTEND-004.4: Summary Panel (Right Sidebar)

**Como** operador  
**Quiero** ver un resumen claro del total a pagar en la columna derecha  
**Para** informar al cliente rápidamente sobre el monto final

#### Criterios de Aceptación

- [ ] El panel de resumen se ubica en la columna derecha (sidebar)
- [ ] Incluye las siguientes filas:
  - **Total de productos:** X items
  - **Subtotal:** $X.XXX
  - **IVA (19%):** $X.XXX (solo 1 tipo de impuesto por ahora)
  - **TOTAL A PAGAR:** $XX.XXX (destacado, grande, verde)
- [ ] El TOTAL se destaca visualmente:
  - Fuente más grande (28px)
  - Color verde (`hsl(140 70% 40%)`)
  - Separado del resto con borde superior
- [ ] Todas las filas tienen alineación:
  - Label a la izquierda (gris)
  - Valor a la derecha (negro, bold)
- [ ] Fondo blanco, bordes redondeados, sombra sutil

#### Componentes Afectados
- `CartSummary.tsx` (nuevo)
- `CartView.tsx` (cálculos)

#### Datos Requeridos
```typescript
interface CartSummary {
  totalItems: number;
  subtotal: number;
  taxAmount: number;
  totalAmount: number;
}
```

---

### US-FRONTEND-004.5: Action Buttons (Vertical Stack)

**Como** operador  
**Quiero** tener botones de acción verticales grandes y claros  
**Para** proceder al pago, suspender o cancelar la sesión fácilmente

#### Criterios de Aceptación

- [ ] Los botones se apilan verticalmente en la columna derecha (debajo del resumen)
- [ ] **Botón PAGAR:**
  - Color verde (`hsl(140 70% 45%)`)
  - Texto blanco, ícono 💳
  - Tamaño de fuente: 28px
  - Padding vertical: **80px** (muy grande)
  - Efecto hover: color más oscuro + leve escala
- [ ] **Botón Suspender:**
  - Color gris (`hsl(220 15% 92%)`)
  - Texto negro, ícono ⏸️
  - Tamaño normal (16px padding)
- [ ] **Botón Cancelar:**
  - Color rojo claro (`hsl(0 75% 95%)`)
  - Texto rojo oscuro, ícono ❌
  - Tamaño normal (16px padding)
- [ ] Los 3 botones tienen:
  - Ancho completo (fill container)
  - Bordes redondeados (8px)
  - Gap de 12px entre ellos
  - Cursor pointer
- [ ] Las acciones son funcionales:
  - PAGAR: navega a pantalla de pago
  - Suspender: guarda sesión y vuelve al dashboard
  - Cancelar: muestra confirmación y cancela sesión

#### Componentes Afectados
- `CartActions.tsx` (nuevo)
- `CartView.tsx` (handlers)

---

## 🎨 Design System

### Colores

```css
/* Customer Type Borders */
--color-facial: hsl(140 70% 50%);   /* Verde */
--color-pin: hsl(45 95% 55%);       /* Amarillo */
--color-no-id: hsl(0 75% 60%);      /* Rojo */

/* Primary Actions */
--color-primary: hsl(140 70% 45%);  /* Verde - PAGAR */
--color-info: hsl(195 100% 50%);    /* Azul - Modificar */

/* Secondary Actions */
--color-secondary: hsl(220 15% 92%); /* Gris - Suspender */
--color-danger: hsl(0 75% 95%);      /* Rojo claro - Cancelar */

/* Text */
--text-primary: hsl(220 10% 20%);
--text-secondary: hsl(220 10% 45%);
--text-tertiary: hsl(220 10% 55%);

/* Background */
--bg-page: hsl(220 20% 98%);
--bg-card: white;

/* Borders */
--border-color: hsl(220 15% 88%);
```

### Spacing

```css
--spacing-xs: 4px;
--spacing-sm: 8px;
--spacing-md: 12px;
--spacing-lg: 16px;
--spacing-xl: 24px;
--spacing-2xl: 32px;

/* Borders */
--radius-sm: 8px;
--radius-md: 12px;

/* Shadows */
--shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.06);
--shadow-md: 0 4px 12px rgba(0, 0, 0, 0.1);
```

---

## 🔧 Consideraciones Técnicas

### Estado del CartView

```typescript
interface CartViewState {
  sessionId: string;
  customer: CustomerDisplayInfo;
  cartItems: CartItem[];
  currentPage: number;
  isModifying: boolean;
}
```

### Props de Componentes Nuevos

#### ProductCard
```typescript
interface ProductCardProps {
  product: CartItem;
  isReadOnly: boolean;
}
```

#### Pagination
```typescript
interface PaginationProps {
  currentPage: number;
  totalPages: number;
  onPageChange: (page: number) => void;
}
```

#### CartSummary
```typescript
interface CartSummaryProps {
  summary: {
    totalItems: number;
    subtotal: number;
    taxAmount: number;
    totalAmount: number;
  };
}
```

#### CartActions
```typescript
interface CartActionsProps {
  sessionId: string;
  onPay: () => void;
  onSuspend: () => void;
  onCancel: () => void;
  disabled?: boolean;
}
```

---

## 📱 Responsive Breakpoints

```css
/* Tablet Landscape (por defecto) - 1024px+ */
.products-grid {
  grid-template-columns: repeat(3, 1fr);
}

/* Tablet Portrait - 768px - 1023px */
@media (max-width: 1024px) {
  .main-content {
    grid-template-columns: 1fr; /* Stack vertical */
  }
  .products-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Mobile - < 768px */
@media (max-width: 768px) {
  .products-grid {
    grid-template-columns: 1fr;
  }
}
```

---

## ✅ Definición de Hecho (DoD)

- [ ] Todos los componentes visuales coinciden con el mockup aprobado
- [ ] El layout es responsive (3 cols → 2 cols → 1 col)
- [ ] La paginación funciona correctamente
- [ ] Los cálculos de subtotal, impuestos y total son correctos
- [ ] Los botones de acción ejecutan las funciones correctas
- [ ] El componente se integra con el store de Zustand
- [ ] El código cumple con las convenciones del proyecto
- [ ] No hay errores de TypeScript ni ESLint
- [ ] El diseño sigue el design system de Alwon
- [ ] Funciona correctamente en Chrome/Edge (navegador de tablet Android)
- [ ] El rendimiento es fluido con hasta 50 productos en el carrito

---

## 🔗 Dependencias

### Backend APIs
- ✅ `GET /api/session/{sessionId}` - Obtener datos de sesión y cliente
- ✅ `GET /api/cart/{sessionId}` - Obtener items del carrito
- ⚠️ **Nota:** El Concentrador envía TODA la info del producto (nombre, precio, imagen), el POS NO consulta Product Service

### Componentes Reutilizables
- `SessionCard.tsx` - Referencia para formato de cliente (Torre/Apto)
- Store de Zustand (`useCartStore`, `useSessionStore`)

---

## 📊 Estimación de Esfuerzo

| Tarea | Puntos | Tiempo Est. |
|-------|--------|-------------|
| US-004.1: Customer Info Rectangle | 2 | 1-2 horas |
| US-004.2: Product Grid | 5 | 3-4 horas |
| US-004.3: Pagination | 2 | 1-2 horas |
| US-004.4: Summary Panel | 2 | 1-2 horas |
| US-004.5: Action Buttons | 2 | 1 hora |
| **TOTAL** | **13** | **7-11 horas** |

---

## 🚀 Plan de Implementación

### Fase 1: Estructura (2-3 horas)
1. Crear componentes base:
   - `ProductCard.tsx`
   - `Pagination.tsx`
   - `CartSummary.tsx`
   - `CartActions.tsx`
2. Modificar `CartView.tsx` para layout de 2 columnas
3. Implementar customer info horizontal

### Fase 2: Funcionalidad (3-4 horas)
1. Implementar paginación funcional
2. Conectar con store de Zustand
3. Cálculos de subtotal/impuestos/total
4. Handlers de botones de acción

### Fase 3: Polish (2-4 horas)
1. Aplicar design system completo
2. Efectos hover y transiciones
3. Responsive design
4. Testing en diferentes resoluciones

---

## 📝 Notas Adicionales

- **Impuestos parametrizados:** Por ahora solo se muestra 1 tipo de IVA (19%), pero el sistema debe estar preparado para soportar múltiples tipos de impuestos en el futuro
- **Imágenes de productos:** Usar emojis como placeholder si no hay `productImageUrl`
- **Modificación de carrito:** El botón "🔒 Modificar Carrito" abre el flujo de autenticación del operador (US-FRONTEND-003)
- **Sin edición directa:** El cliente NO puede modificar productos desde las cartas; todo se hace en el "Modo Operador"

---

**Aprobado por:** Usuario  
**Fecha de Aprobación:** 2025-12-26  
**Mockup de Referencia:** `cart_view_mockup.html`
