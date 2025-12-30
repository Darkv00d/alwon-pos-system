# US-FRONTEND-018: Simplified Cart Action Buttons

**Epic**: Cart & Session Management  
**Sprint**: Sprint 2 - Payment & Session Flow  
**Story Points**: 2  
**Priority**: High  
**Status**: ✅ Ready for Implementation

---

## 📋 User Story

**As a** POS operator  
**I want** simplified, focused action buttons in the cart view  
**So that** I can quickly proceed to payment or cancel the session without confusion

---

## 🎯 Acceptance Criteria

### Must Have
- [x] Only two action buttons visible: **PAGAR** and **CANCELAR**
- [x] PAGAR button is significantly larger and more prominent
- [x] CANCELAR button is secondary but clearly visible
- [x] Buttons maintain responsive behavior and hover effects
- [x] Remove "Suspender" button from the interface

### Visual Requirements
- **PAGAR Button**:
  - Height: 100px (increased from 85px)
  - Full width
  - Gradient green background
  - Large, bold text (24px)
  - Prominent icon (💳)
  - Strong visual hierarchy
  
- **CANCELAR Button**:
  - Height: 56px
  - Full width
  - Light red background (hsl(0 100% 95%))
  - Medium text (18px)
  - Icon (❌)
  - Clear but secondary visual weight

---

## 🎨 Design Specifications

### Layout Structure

```
┌─────────────────────────────────────┐
│                                     │
│         💳 PAGAR (100px)           │
│                                     │
└─────────────────────────────────────┘
          ↕ 16px gap
┌─────────────────────────────────────┐
│      ❌ CANCELAR (56px)             │
└─────────────────────────────────────┘
```

### Color Palette

- **PAGAR**: `linear-gradient(135deg, #10B981 0%, #059669 100%)`
- **CANCELAR**: `hsl(0 100% 95%)` background, `hsl(0 70% 45%)` text

### Typography

- **PAGAR**: 24px, font-weight: 700
- **CANCELAR**: 18px, font-weight: 600

---

## 💻 Technical Implementation

### Files to Modify

1. **CartActions.tsx**
   - Remove `onSuspend` prop
   - Remove Suspender button
   - Simplify layout to vertical stack

2. **CartActions.css**
   - Increase PAGAR button height to 100px
   - Remove `.btn-suspend` styles
   - Update `.btn-cancel` to full width
   - Adjust spacing and visual hierarchy

3. **CartView.tsx**
   - Remove `handleSuspend` function
   - Update CartActions props

---

## 🔄 User Flow

### Current Flow (3 buttons)
```
Cart View
├── 💳 CONTINUAR AL PAGO (85px)
├── ⏸️ Suspender (48px)
└── ❌ Cancelar (48px)
```

### New Flow (2 buttons)
```
Cart View
├── 💳 PAGAR (100px) ← Primary action, very prominent
└── ❌ CANCELAR (56px) ← Secondary action, clear but less prominent
```

---

## 🧪 Testing Scenarios

### Visual Testing
- [ ] PAGAR button is noticeably larger than CANCELAR
- [ ] Buttons are vertically stacked with appropriate spacing
- [ ] Gradient animation on PAGAR is smooth
- [ ] Hover effects work on both buttons
- [ ] Disabled state is clearly visible

### Functional Testing
- [ ] PAGAR button triggers payment flow
- [ ] CANCELAR button cancels session
- [ ] Buttons are disabled when appropriate
- [ ] No console errors
- [ ] TypeScript compilation successful

### Responsive Testing
- [ ] Buttons scale appropriately on different viewports
- [ ] Touch targets are adequate (minimum 44x44px)
- [ ] Layout doesn't break on mobile sizes

---

## 📝 Implementation Notes

### Rationale for Removing "Suspender"

The "Suspender" (Suspend) button adds complexity without significant value:
- **Low usage**: Operators rarely suspend sessions
- **Alternative exists**: They can simply navigate away (session persists)
- **Cognitive load**: Three buttons require more decision-making
- **Screen real estate**: Space better used for prominent PAGAR button

### Why Larger PAGAR Button?

- **Primary action**: 90% of cart flows end in payment
- **Visual hierarchy**: Size indicates importance
- **Reduced errors**: Larger target is easier to hit
- **Confidence**: Bold design reinforces positive action

---

## 🔗 Related Stories

- US-FRONTEND-010: Prominent Payment Button (superseded)
- US-FRONTEND-009: Balanced Secondary Actions (superseded)
- US-FRONTEND-005: Shopping Cart Management

---

## 🚀 Deployment Impact

- **Breaking Changes**: None
- **Database Changes**: None
- **API Changes**: None
- **Feature Flag**: Not required

---

## ✅ Definition of Done

- [ ] Code implemented and reviewed
- [ ] Visual design matches specification
- [ ] All tests passing
- [ ] Browser testing completed
- [ ] No accessibility regressions
- [ ] Documentation updated
- [ ] User story accepted by stakeholder
