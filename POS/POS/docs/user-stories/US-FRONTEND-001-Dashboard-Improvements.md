# User Stories - Dashboard Principal Mejoras

## Epic: Mejoras de Experiencia de Usuario en Dashboard

**Fecha:** 2025-12-23
**Versión:** 1.0
**Estado:** Pendiente

---

## US-001: Visualización de Productos para Clientes No Identificados

**Como** operador de la tienda  
**Quiero** que los clientes no identificados vean imágenes de los productos en su carrito  
**Para que** puedan confirmar visualmente qué productos se les están cargando

### Criterios de Aceptación

- [ ] Las tarjetas de sesión con `clientType: NO_ID` muestran miniaturas de productos
- [ ] Se muestran máximo 3 imágenes de productos por tarjeta
- [ ] Si hay más de 3 productos, se muestra un indicador "+N más"
- [ ] Las imágenes tienen tamaño consistente (ej: 40x40px)
- [ ] Si no hay productos, se muestra un icono de carrito vacío

### Detalles Técnicos

**Componente:** `SessionCard.tsx`  
**Props necesarios:** `cartItems: CartItem[]` o `productImages: string[]`

**Mockup:**
```
┌─────────────────────────────┐
│ 🔴 SIN IDENTIFICAR          │
│ [🥚] [🥤] [🍞] +2 más      │
│ 5 productos | $15,500       │
└─────────────────────────────┘
```

---

## US-002: Mostrar Torre y Apartamento para Clientes Identificados

**Como** operador de la tienda  
**Quiero** ver la torre y apartamento de clientes identificados  
**Para que** pueda confirmar la ubicación de entrega fácilmente

### Criterios de Aceptación

- [ ] Las tarjetas `FACIAL` y `PIN` muestran Torre y Apartamento
- [ ] El formato es claro: "Torre 3 - Apto 501"
- [ ] Se muestra debajo o junto al nombre del cliente
- [ ] Si no hay datos de torre/apto, no se muestra nada (no error)

### Campos del Backend Requeridos

```typescript
interface CustomerSession {
  // Campos nuevos necesarios
  tower?: string;        // Ej: "Torre 3"
  apartment?: string;    // Ej: "501"
}
```

**Componente afectado:** `SessionCard.tsx`

**Mockup:**
```
┌─────────────────────────────┐
│ 🟢 FACIAL                   │
│ Juan Pérez                  │
│ 📍 Torre 3 - Apto 501       │
│ 3 productos | $25,900       │
└─────────────────────────────┘
```

---

## US-003: Cálculo Correcto de Items y Total del Carrito

**Como** usuario del sistema  
**Quiero** ver la cantidad real de productos y el total correcto  
**Para que** tenga información precisa del estado de cada sesión

### Criterios de Aceptación

- [ ] El contador de items muestra la suma de `quantity` de todos los productos
- [ ] El total muestra la suma de `totalPrice` de todos los items
- [ ] Los valores se formatean correctamente (ej: $15.500 en formato colombiano)
- [ ] Si el carrito está vacío, muestra "0 items" y "$0"
- [ ] Los valores se actualizan en tiempo real cuando cambia el carrito

### Cálculo

```typescript
const itemCount = cart.items.reduce((sum, item) => sum + item.quantity, 0);
const totalAmount = cart.items.reduce((sum, item) => sum + item.totalPrice, 0);
```

**Componente:** `SessionCard.tsx`, `Dashboard.tsx`

---

## US-004: Ocultar Session ID Técnico

**Como** usuario final  
**Quiero** NO ver códigos técnicos como "SES-001"  
**Para que** la interfaz sea más amigable y menos confusa

### Criterios de Aceptación

- [ ] El `sessionId` no se muestra en las tarjetas de sesión
- [ ] Se mantiene el color/indicador visual del tipo de cliente
- [ ] El sessionId sigue usado internamente en rutas y lógica
- [ ] Solo se muestra: Nombre, Torre/Apto, Items, Total

**Antes:**
```
Juan Pérez #SES-001
```

**Después:**
```
Juan Pérez
Torre 3 - Apto 501
```

---

## US-005: Popup de Autenticación de Operador

**Como** operador  
**Quiero** poder autenticarme haciendo click en mi badge  
**Para que** pueda acceder a funciones administrativas como cierre de caja

### Criterios de Aceptación

**Popup de Login:**
- [ ] Click en el badge "Operador" abre un modal/popup
- [ ] El modal contiene:
  - Campo de texto: "Usuario"
  - Campo de password: "Contraseña"
  - Botón principal: "Aceptar"
  - Botón secundario: "Cancelar"
- [ ] El modal se puede cerrar con Escape o click fuera (cuenta como cancelar)
- [ ] Los campos tienen validación básica (no vacíos)

**Post-Autenticación:**
- [ ] Al hacer click en "Aceptar" con credenciales correctas:
  - El modal se cierra
  - Aparece un botón "Cierre de Caja" al lado del logo del operador (header superior derecho)
- [ ] Si las credenciales son incorrectas:
  - Se muestra mensaje de error
  - El modal permanece abierto
  - Los campos se limpian

**Botón Cierre de Caja:**
- [ ] Aparece solo cuando el operador está autenticado
- [ ] Se ubica en el header, al lado del badge "Operador"
- [ ] Click en "Cierre de Caja" por ahora solo muestra un alert (sin lógica backend)
- [ ] El botón persiste mientras la sesión del operador esté activa

### Diseño del Modal de Login

**Componente nuevo:** `OperatorAuthModal.tsx`

```
┌────────────────────────────────┐
│  Autenticación de Operador     │
├────────────────────────────────┤
│  Usuario:                      │
│  [________________]            │
│                                │
│  Contraseña:                   │
│  [________________]            │
│                                │
│  [  Cancelar  ]  [  Aceptar  ] │
└────────────────────────────────┘
```

### Diseño del Header Post-Login

**Antes del login:**
```
┌──────────────────────────────────────┐
│ Alwon POS            👤 Operador     │
└──────────────────────────────────────┘
```

**Después del login:**
```
┌────────────────────────────────────────────┐
│ Alwon POS    [💰 Cierre Caja] 👤 Operador │
└────────────────────────────────────────────┘
```

### Flujo de Usuario

1. Usuario hace click en badge "Operador"
2. Se abre modal de autenticación
3. Usuario ingresa credenciales
4. Usuario hace click en "Aceptar"
5. **Si credenciales válidas:**
   - Modal se cierra
   - Aparece botón "Cierre de Caja" en header
   - Se guarda estado de sesión (localStorage o state)
6. **Si credenciales inválidas:**
   - Se muestra error: "Usuario o contraseña incorrectos"
   - Modal permanece abierto

### Validaciones

**Frontend (Por ahora - Mock):**
```typescript
// Credenciales hardcodeadas para prototipo
const MOCK_CREDENTIALS = {
  username: "admin",
  password: "admin123"
};

function validateLogin(user: string, pass: string): boolean {
  return user === MOCK_CREDENTIALS.username && 
         pass === MOCK_CREDENTIALS.password;
}
```

**Estado de Sesión:**
```typescript
interface OperatorSession {
  isAuthenticated: boolean;
  username: string;
  loginTime: Date;
}
```


---

## US-006: Actualizar Productos a Canasta Familiar

**Como** usuario del sistema  
**Quiero** ver productos de la canasta familiar en los ejemplos  
**Para que** sea más relevante al contexto de una tienda de conveniencia

### Criterios de Aceptación

- [ ] Los datos de prueba usan productos de canasta familiar
- [ ] Ejemplos incluyen: Huevos, Gaseosas, Pan, Leche, Arroz, Aceite, etc.
- [ ] Los precios son realistas para Colombia (COP)
- [ ] Las categorías reflejan alimentos y productos de primera necesidad

### Productos Sugeridos

```sql
-- Ejemplo de productos
('Huevos AA x12', 'Huevos frescos AA por docena', 8500, 'Lácteos y Huevos')
('Coca-Cola 400ml', 'Gaseosa Coca-Cola personal', 2500, 'Bebidas')
('Pan Tajado Bimbo', 'Pan de molde tajado 450g', 4200, 'Panadería')
('Leche Alpina 1L', 'Leche entera pasteurizada', 3800, 'Lácteos y Huevos')
('Arroz Diana 500g', 'Arroz blanco de primera', 2100, 'Granos y Cereales')
```

**Archivo afectado:** `init-db.sql`

---

## Estimaciones

| User Story | Puntos | Prioridad | Dependencias |
|------------|--------|-----------|--------------|
| US-001 | 5 | Alta | Backend debe enviar cartItems |
| US-002 | 3 | Alta | Backend debe enviar tower/apartment |
| US-003 | 3 | Crítica | Ninguna |
| US-004 | 1 | Media | Ninguna |
| US-005 | 5 | Media | Ninguna |
| US-006 | 2 | Baja | Ninguna |

**Total:** 19 puntos de historia

---

## Notas de Implementación

### Cambios en el Backend Necesarios

1. `SessionResponse` debe incluir:
   ```java
   private String tower;
   private String apartment;
   private List<CartItemDto> cartItems; // Para imágenes
   ```

2. La tabla `customer_sessions` podría necesitar campos adicionales

### Orden de Implementación Sugerido

1. US-003 (crítico, sin dependencias)
2. US-004 (rápido, mejora UX)
3. US-006 (datos de prueba)
4. US-002 (requiere backend)
5. US-001 (requiere backend)
6. US-005 (funcionalidad independiente)
