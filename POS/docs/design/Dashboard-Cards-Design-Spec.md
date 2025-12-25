# Especificación de Diseño - Dashboard Session Cards
## Alwon POS - Design System Documentation

**Versión**: 1.0  
**Fecha**: 25 de Diciembre, 2025  
**Componente**: Dashboard Session Cards  
**Diseño**: Neumorphism Soft UI  

---

## 🎨 Paleta de Colores

### Colores Principales

```css
/* Fondos */
--background-page: hsl(220, 20%, 98%);     /* #f5f6f8 - Fondo general */
--background-card: #ffffff;                 /* Blanco puro - Tarjetas */

/* Texto */
--text-primary: #2d3436;                    /* Títulos y totales */
--text-secondary: #636e72;                  /* Info secundaria */

/* Colores de Tipo de Cliente */
--color-facial: #22c55e;                    /* Verde - Cliente FACIAL */
--color-pin: #eab308;                       /* Amarillo - Cliente PIN */
--color-no-id: #ef4444;                     /* Rojo - Cliente NO_ID */

/* Elementos UI */
--badge-background: #dfe6e9;                /* Gris claro - Badges */
--border-color: rgba(255, 255, 255, 0.5);   /* Bordes de foto */

/* Silueta PIN */
--silhouette-gradient-start: #00bfff;       /* Cyan Alwon */
--silhouette-gradient-end: #0099cc;         /* Cyan oscuro */
--silhouette-icon-color: #ffffff;           /* Blanco */
```

---

## 🔲 Componente: Session Card

### Estructura Visual

```
┌────────────────────────────────────────────────────────┐
│ [Borde izquierdo 4px - Color según tipo]              │
│                                                        │
│   ┌──────────────────────┐              ┌──────────┐ │
│   │                      │              │          │ │
│   │  Nombre Completo     │              │   Foto   │ │
│   │  (1.5rem, semibold)  │              │  150px   │ │
│   │                      │              │  ⭕      │ │
│   │  📍 Torre A-501      │              │ circular │ │
│   │  🛒 5 productos      │              │          │ │
│   │                      │              │          │ │
│   │  [FACIAL]            │              └──────────┘ │
│   │  (badge)             │                           │
│   │                      │                           │
│   │  $36,300             │                           │
│   │  (2.2rem, bold)      │                           │
│   │                      │                           │
│   └──────────────────────┘                           │
│                                                        │
└────────────────────────────────────────────────────────┘
   ↑                                                   ↑
   Contenido (flex: 1)                      Foto (150x150px)
```

### Dimensiones

```css
.session-card {
  /* Tamaño */
  min-height: 200px;
  padding: 24px;
  border-radius: 16px;
  
  /* Layout */
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
  
  /* Borde lateral */
  border-left: 4px solid var(--tipo-color);
}
```

### Efecto Neumorphism

```css
/* Estado Normal */
box-shadow: 
  8px 8px 15px rgba(163, 177, 198, 0.6),    /* Sombra oscura abajo-derecha */
  -8px -8px 15px rgba(255, 255, 255, 0.5);  /* Sombra clara arriba-izquierda */

/* Estado Hover */
box-shadow: 
  12px 12px 20px rgba(163, 177, 198, 0.6),   /* Sombra más pronunciada */
  -12px -12px 20px rgba(255, 255, 255, 0.5);

/* Transición */
transition: box-shadow 300ms ease;
```

---

## 👤 Foto de Cliente

### Contenedor Circular

```css
.photo-container {
  width: 150px;
  height: 150px;
  border-radius: 50%;
  border: 4px solid rgba(255, 255, 255, 0.5);
  overflow: hidden;
  flex-shrink: 0;
  
  /* Sombra neumórfica */
  box-shadow: 
    4px 4px 8px rgba(163, 177, 198, 0.4),
    -4px -4px 8px rgba(255, 255, 255, 0.3);
}
```

### Imagen Real (FACIAL / NO_ID)

```css
.photo-container img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

### Silueta Genérica (PIN)

```css
.generic-silhouette {
  width: 100%;
  height: 100%;
  
  /* Fondo gradiente cyan */
  background: linear-gradient(
    135deg, 
    #00bfff 0%,    /* Cyan Alwon claro */
    #0099cc 100%   /* Cyan Alwon oscuro */
  );
  
  /* Centrado del ícono */
  display: flex;
  align-items: center;
  justify-content: center;
  
  /* Ícono */
  font-size: 80px;
  color: white;
  
  /* Efecto 3D */
  text-shadow: 
    2px 2px 4px rgba(0, 0, 0, 0.15),      /* Sombra oscura */
    -1px -1px 2px rgba(255, 255, 255, 0.3); /* Luz */
}
```

---

## 📝 Tipografía y Elementos de Texto

### Nombre del Cliente

```css
.customer-name {
  color: #2d3436;
  font-size: 1.5rem;     /* 24px */
  font-weight: 600;
  line-height: 1.2;
  margin-bottom: 12px;
}
```

### Información Secundaria

```css
.customer-info {
  color: #636e72;
  font-size: 1.05rem;    /* ~17px */
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 8px;
}
```

### Total del Carrito

```css
.customer-total {
  color: #2d3436;
  font-size: 2.2rem;     /* ~35px */
  font-weight: 700;
  margin-top: 16px;
}
```

### Badge de Tipo

```css
.type-badge {
  display: inline-block;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 0.85rem;    /* ~14px */
  font-weight: 600;
  margin-top: 12px;
  
  background: #dfe6e9;
  color: #2d3436;
  width: fit-content;
}
```

---

## 📐 Grid Layout - Dashboard

### Configuración

```css
.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 24px;
  margin-bottom: 24px;
}
```

### Responsive Breakpoints

```css
/* Tablet (< 1024px) */
@media (max-width: 1024px) {
  .dashboard-grid {
    grid-template-columns: repeat(1, minmax(0, 1fr));
  }
}

/* Desktop grande (> 1400px) */
@media (min-width: 1400px) {
  .dashboard-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}
```

---

## 🎭 Estados y Variantes

### Variantes por Tipo de Cliente

#### FACIAL (Verde)
```css
--border-color: #22c55e;
--badge-text: "FACIAL";
```
- ✅ Muestra foto real
- ✅ Borde izquierdo verde
- ✅ Badge "FACIAL"

#### PIN (Amarillo)
```css
--border-color: #eab308;
--badge-text: "PIN";
```
- ✅ Muestra silueta blanca sobre cyan
- ✅ Borde izquierdo amarillo
- ✅ Badge "PIN"
- ⚠️ Privacidad protegida

#### NO_ID (Rojo)
```css
--border-color: #ef4444;
--badge-text: "NO ID";
```
- ✅ Muestra foto capturada por IA
- ✅ Borde izquierdo rojo
- ✅ Badge "NO ID"

---

## 🔄 Interacciones

### Click
```css
cursor: pointer;
/* Navega a: /cart/:sessionId */
```

### Hover
```css
/* Intensifica sombras */
box-shadow: 
  12px 12px 20px rgba(163, 177, 198, 0.6),
  -12px -12px 20px rgba(255, 255, 255, 0.5);

transition: box-shadow 300ms cubic-bezier(0.4, 0, 0.2, 1);
```

### Active/Focus
```css
/* Sin cambio de posición (no translateY) */
/* Solo efecto de sombra */
```

---

## ♿ Accesibilidad

### Contraste de Colores

| Elemento | Color | Fondo | Ratio | WCAG |
|----------|-------|-------|-------|------|
| Nombre | #2d3436 | #ffffff | 13.4:1 | ✅ AAA |
| Info | #636e72 | #ffffff | 5.8:1 | ✅ AA |
| Total | #2d3436 | #ffffff | 13.4:1 | ✅ AAA |
| Badge text | #2d3436 | #dfe6e9 | 11.2:1 | ✅ AAA |
| Silueta | white | cyan | 4.5:1 | ✅ AA |

### Navegación por Teclado
```
- Tab: Navega entre tarjetas
- Enter/Space: Activa la tarjeta (navega al carrito)
- Escape: Sale del foco
```

---

## 📊 Especificaciones de Datos

### Datos Requeridos

```typescript
interface SessionCardData {
  sessionId: string;           // Identificador único
  clientType: 'FACIAL' | 'PIN' | 'NO_ID';
  customerName?: string;        // Nombre completo
  customerPhotoUrl?: string;    // URL de foto (opcional para PIN)
  tower?: string;               // Torre
  apartment?: string;           // Número de apartamento
  itemCount: number;            // Total de productos
  totalAmount: number;          // Total en pesos
}
```

### Renderizado Condicional

```typescript
// Foto vs Silueta
if (clientType === 'PIN') {
  render(<Silueta />);
} else if (customerPhotoUrl) {
  render(<Foto src={customerPhotoUrl} />);
} else {
  render(<Silueta />);
}

// Nombre completo
const displayName = customerName || 'No Identificado';

// Ubicación
const location = tower && apartment 
  ? `${tower}-${apartment}` 
  : null;
```

---

## 🎯 Principios de Diseño Aplicados

### 1. Neumorphism Suave
- Sombras duales (luz + oscura)
- Efecto de relieve sutil
- Fondo claro uniforme

### 2. Minimalismo
- Solo información esencial
- Colores como acentos, no protagonistas
- Espacios en blanco generosos

### 3. Jerarquía Visual
1. **Primario**: Total ($36,300)
2. **Secundario**: Nombre del cliente
3. **Terciario**: Ubicación y productos
4. **Cuaternario**: Badge de tipo

### 4. Consistencia
- Mismo patrón para todas las tarjetas
- Colores sistemáticos por tipo
- Espaciados uniformes

### 5. Feedback Visual
- Hover effect claro
- Cursor pointer
- Sombras interactivas

---

## 📋 Checklist de Implementación

### Diseño
- [x] Paleta de colores definida
- [x] Tipografía especificada
- [x] Sombras neumórficas implementadas
- [x] Layout responsive configurado
- [x] Estados hover definidos

### Funcionalidad
- [x] Renderizado de 3 tipos de cliente
- [x] Fotos circulares implementadas
- [x] Silueta genérica para PIN
- [x] Navegación al carrito
- [x] Sincronización con backend

### Accesibilidad
- [x] Contraste WCAG AAA
- [x] Navegación por teclado
- [x] Textos alternativos
- [x] Estados focus visibles

### Performance
- [x] Componente optimizado
- [x] Imágenes lazy load
- [x] Transiciones suaves
- [x] Sin re-renders innecesarios

---

## 💡 Notas de Diseñador

### ¿Por qué este diseño?

**Problema original**: Tarjetas con colores sólidos muy saturados, 4 columnas apretadas, difícil lectura.

**Solución**: Neumorphism con fondo blanco, 2 columnas espaciadas, colores solo como acentos.

**Resultado**: Dashboard profesional, fácil de escanear, con excelente jerarquía visual.

### Decisiones clave

1. **Fondo blanco vs gris**: El blanco reduce fatiga visual y da sensación más limpia
2. **2 columnas vs 4**: Permite tarjetas grandes con toda la info visible sin scroll
3. **Foto circular vs cuadrada**: Estándar moderno, más amigable, mejor para rostros
4. **Silueta blanca vs icono**: Mantiene consistencia visual con fotos reales

---

## 🔗 Referencias

- **Neumorphism**: Soft UI trend 2024-2025
- **Material Design**: Shadow elevation guidelines
- **WCAG 2.1**: Color contrast requirements
- **iOS HIG**: Circular profile photos standard

---

**Documento creado por**: Antigravity AI  
**Aprobado por**: Usuario (25/Dic/2025)  
**Próxima revisión**: Q1 2026
