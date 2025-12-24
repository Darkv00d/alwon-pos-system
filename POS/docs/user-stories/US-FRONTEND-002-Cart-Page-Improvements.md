# User Stories - Página de Carrito Mejoras

## Epic: Mejoras de UX en Página de Carrito

**Fecha:** 2025-12-23
**Versión:** 1.0
**Estado:** Pendiente

---

## US-007: Mostrar Información del Cliente en Header del Carrito

**Como** operador  
**Quiero** ver el nombre, torre y apartamento del cliente en el header del carrito  
**Para que** confirme rápidamente la identidad y ubicación del cliente

### Criterios de Aceptación

- [ ] El header muestra el nombre completo del cliente
- [ ] Debajo del nombre se muestra "Torre X - Apto YYY"
- [ ] Si es cliente NO_ID, se muestra "Cliente No Identificado"
- [ ] El tipo de cliente se indica con color (🟢 FACIAL, 🟡 PIN, 🔴 NO_ID)
- [ ] La información está visible sin hacer scroll

### Diseño del Header

```
┌──────────────────────────────────────────┐
│ ← Volver                                 │
│                                          │
│ 🟢 Juan Pérez García                    │
│ 📍 Torre 3 - Apto 501                   │
│                                          │
│ Carrito de Compras                      │
└──────────────────────────────────────────┘
```

**Componente:** `CartView.tsx`

---

## US-008: Alineación Correcta de Campos de Cantidad

**Como** usuario  
**Quiero** que los controles de cantidad estén bien alineados  
**Para que** la interfaz se vea profesional y sea fácil de usar

### Criterios de Aceptación

- [ ] Los botones [-] y [+] están alineados verticalmente
- [ ] El número de cantidad está centrado entre los botones
- [ ] Todos los items tienen el mismo espaciado
- [ ] Los controles son táctiles (mínimo 44x44px)
- [ ] El estilo es consistente en todos los items

### Diseño de Controles

```
┌─── Item ────────────────────────┐
│ Huevos AA x12                   │
│ $8,500                          │
│                                 │
│ Cantidad:  [-]  2  [+]         │
│ Total: $17,000                  │
└─────────────────────────────────┘
```

**CSS requerido:**
```css
.quantity-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.quantity-btn {
  width: 44px;
  height: 44px;
  // ... resto del estilo
}
```

---

## US-009: Aumentar Tamaño de Botones Suspender/Cancelar

**Como** usuario  
**Quiero** ver botones de suspender/cancelar más grandes  
**Para que** sean más fáciles de identificar y usar

### Criterios de Aceptación

- [ ] Los iconos de suspender/cancelar aumentan de tamaño
- [ ] Tamaño mínimo del botón: 48x48px
- [ ] Los iconos dentro tienen tamaño de al menos 24x24px
- [ ] Tienen un label de texto visible
- [ ] El hover muestra el propósito claramente

### Antes y Después

**Antes:** Iconos de 16px, difíciles de ver  
**Después:** Botones de 48px con iconos de 24px

```
[🔄 Suspender]  [❌ Cancelar]  [→ Continuar al Pago]
   48x48px         48x48px         Grande y destacado
```

---

## US-010: Botón "Continuar al Pago" Más Prominente

**Como** usuario  
**Quiero** que el botón de pago sea el elemento visual más importante  
**Para que** el flujo principal de compra sea obvio

### Criterios de Aceptación

- [ ] El botón ocupa todo el ancho disponible (o al menos 60%)
- [ ] Tiene un color destacado (ej: verde #10B981 o azul vibrante)
- [ ] Es al menos 2x más grande que suspender/cancelar
- [ ] El texto es bold y de mayor tamaño (18-20px)
- [ ] Tiene una altura mínima de 56px para fácil toque
- [ ] Incluye un icono de flecha →

### Jerarquía Visual

**Prioridad 1 (Primario):**
```css
.btn-pay {
  width: 100%;
  height: 64px;
  background: linear-gradient(135deg, #10B981 0%, #059669 100%);
  font-size: 20px;
  font-weight: bold;
  /* Sombra para que "flote" */
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}
```

**Prioridad 2 (Secundarios):**
```css
.btn-suspend, .btn-cancel {
  width: 48%;
  height: 48px;
  background: transparent;
  border: 2px solid #gray;
}
```

### Layout de Botones

```
┌────────────────────────────────────┐
│  [🔄 Suspender] [❌ Cancelar]     │
│     150px           150px          │
│                                    │
│  [→ Continuar al Pago            ]│
│         100% width - 64px          │
└────────────────────────────────────┘
```

---

## US-011: Resumen Visual Mejorado del Carrito

**Como** usuario  
**Quiero** ver un resumen claro del carrito antes de pagar  
** Para que** pueda revisar mi compra fácilmente

### Criterios de Aceptación

- [ ] El subtotal se muestra claramente
- [ ] Si hay descuento, se muestra el ahorro
- [ ] El total final está destacado (más grande, en bold)
- [ ] Incluye contador total de items
- [ ] Formato de moneda consistente ($XX,XXX COP)

### Diseño del Resumen

```
┌────────────────────────────────────┐
│ Resumen de Compra                  │
├────────────────────────────────────┤
│ Items (5):          $45,200        │
│ Descuento 20%:     -$9,040         │
├────────────────────────────────────┤
│ TOTAL:              $36,160        │
│                     =========      │
└────────────────────────────────────┘
```

---

## Estimaciones

| User Story | Puntos | Prioridad | Componente |
|------------|--------|-----------|------------|
| US-007 | 3 | Alta | CartView Header |
| US-008 | 2 | Media | CartItem Component |
| US-009 | 2 | Media | CartView Actions |
| US-010 | 3 | Alta | CartView Actions |
| US-011 | 3 | Media | CartView Summary |

**Total:** 13 puntos de historia

---

## Diseño de Referencia - Página Completa

```
┌──────────────────────────────────────────┐
│ ← Volver                        Operador │
│                                          │
│ 🟢 Juan Pérez García                    │
│ 📍 Torre 3 - Apto 501                   │
│                                          │
│ ══════════════════════════════════════  │
│                                          │
│ 🥚 Huevos AA x12                        │
│ $8,500                                   │
│ Cantidad: [-] 2 [+]                      │
│ Total: $17,000                           │
│ ──────────────────────────────────────  │
│                                          │
│ 🥤 Coca-Cola 400ml                      │
│ $2,500                                   │
│ Cantidad: [-] 3 [+]                      │
│ Total: $7,500                            │
│ ──────────────────────────────────────  │
│                                          │
│ 🍞 Pan Tajado Bimbo                     │
│ $4,200                                   │
│ Cantidad: [-] 1 [+]                      │
│ Total: $4,200                            │
│                                          │
│ ══════════════════════════════════════  │
│                                          │
│ Resumen de Compra                       │
│ Items (6):          $28,700             │
│ Descuento 20%:     -$5,740              │
│ ──────────────────────────────────────  │
│ TOTAL:              $22,960             │
│ ══════════════════════════════════════  │
│                                          │
│  [🔄 Suspender]  [❌ Cancelar]         │
│                                          │
│  [→  CONTINUAR AL PAGO              ]   │
│         (Grande y Destacado)            │
└──────────────────────────────────────────┘
```

---

## Notas Técnicas

### Archivos a Modificar

1. `CartView.tsx` - Componente principal
2. `CartItem.tsx` - Item individual (si existe)
3. `cart-styles.css` - Estilos del carrito
4. `Button.tsx` - Componente de botón reutilizable

### Responsive Design

- Móvil: Botones apilados verticalmente
- Tablet/Desktop: Botones en fila como se muestra

### Accesibilidad

- Todos los botones tienen `aria-label`
- Los controles de cantidad tienen `role="spinbutton"`
- El resumen está en una `<section>` semántica
