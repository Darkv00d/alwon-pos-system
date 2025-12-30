# Alwon POS - Testing Strategy

**Versión:** 1.0.0  
**Última actualización:** 2025-12-28

---

## 🎯 Testing Approach

Este documento define la estrategia de testing para el sistema Alwon POS, cubriendo Backend, Frontend, Integración y E2E.

---

## 🔧 Backend Testing

### 1. Session Service (Port 8081)

#### Health Check
```bash
curl http://localhost:8081/actuator/health
```

**Expected:** `{"status":"UP"}`

#### Create Session
```bash
curl -X POST http://localhost:8081/sessions \
  -H "Content-Type: application/json" \
  -d '{
    "clientType": "FACIAL",
    "customerName": "Test User",
    "customerPhotoUrl": "https://i.pravatar.cc/150",
    "tower": "Torre A",
    "apartment": "101"
  }'
```

#### Get Active Sessions
```bash
curl http://localhost:8081/sessions/active
```

#### Close Session
```bash
curl -X POST http://localhost:8081/sessions/{sessionId}/close
```

**Test Cases:**
- [ ] ✅ Health check returns UP
- [ ] ✅ Create session with FACIAL type
- [ ] ✅ Create session with PIN type
- [ ] ✅ Create session with NO_ID type
- [ ] ✅ Get all active sessions
- [ ] ✅ Get session by ID
- [ ] ✅ Close session successfully
- [ ] ⚠️ Attempt to create session with invalid data (400)
- [ ] ⚠️ Attempt to get non-existent session (404)

---

### 2. Cart Service (Port 8082)

#### Get Cart
```bash
curl http://localhost:8082/carts/session/{sessionId}
```

#### Add Item
```bash
curl -X POST http://localhost:8082/carts/{sessionId}/items \
  -H "Content-Type: application/json" \
  -d '{
    "productId": "prod-001",
    "quantity": 2
  }'
```

#### Update Quantity
```bash
curl -X PATCH http://localhost:8082/carts/{sessionId}/items/{itemId} \
  -H "Content-Type: application/json" \
  -d '{"quantity": 3}'
```

#### Remove Item
```bash
curl -X DELETE http://localhost:8082/carts/{sessionId}/items/{itemId}
```

**Test Cases:**
- [ ] ✅ Get cart for existing session
- [ ] ✅ Add item to cart
- [ ] ✅ Update item quantity
- [ ] ✅ Remove item from cart
- [ ] ✅ Cart totals calculated correctly
- [ ] ⚠️ Add item with quantity <= 0 (400)
- [ ] ⚠️ Update item in non-existent cart (404)

---

### 3. Product Service (Port 8083)

#### Get All Products
```bash
curl http://localhost:8083/products
```

#### Search Products
```bash
curl "http://localhost:8083/products/search?query=leche"
```

#### Get by Category
```bash
curl http://localhost:8083/products/category/LACTEOS
```

**Test Cases:**
- [ ] ✅ Get all products (21 productos canasta familiar)
- [ ] ✅ Search products by name
- [ ] ✅ Get products by category
- [ ] ✅ Get product by ID
- [ ] ✅ Get product by SKU
- [ ] ✅ Get product by barcode
- [ ] ⚠️ Search with empty query (returns all)
- [ ] ⚠️ Get non-existent product (404)

---

### 4. Auth Service (Port 8088)

#### Login
```bash
curl -X POST http://localhost:8088/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123"
  }'
```

#### Verify Code
```bash
curl -X POST http://localhost:8088/api/auth/verify-code \
  -H "Content-Type: application/json" \
  -d '{
    "operatorId": "op-001",
    "code": "123456"
  }'
```

**Test Cases:**
- [ ] ✅ Login with correct credentials
- [ ] ✅ JWT token is returned
- [ ] ✅ Token contains correct claims
- [ ] ✅ Verify correct 6-digit code
- [ ] ⚠️ Login with wrong password (401)
- [ ] ⚠️ Login with non-existent user (404)
- [ ] ⚠️ Verify wrong code (401)
- [ ] ⚠️ Rate limiting after 3 failed attempts (429)

---

### 5. Payment Service (Port 8084)

#### Initiate Payment
```bash
curl -X POST http://localhost:8084/payments/initiate \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "SES-001",
    "paymentMethod": "PSE",
    "amount": 36300
  }'
```

#### Check Status
```bash
curl http://localhost:8084/payments/{transactionId}
```

**Test Cases:**
- [ ] ✅ Initiate PSE payment
- [ ] ✅ Initiate debit card payment
- [ ] ✅ Check payment status
- [ ] ✅ Mock payment succeeds (90% probability)
- [ ] ✅ Mock payment fails (10% probability)
- [ ] ⚠️ Initiate with amount <= 0 (400)

---

### 6. Camera Service (Port 8085)

#### Facial Recognition
```bash
curl -X POST http://localhost:8085/camera/facial-recognition \
  -H "Content-Type: application/json" \
  -d '{
    "sessionId": "SES-001",
    "imageData": "base64_image_data",
    "mimeType": "image/jpeg"
  }'
```

**Test Cases:**
- [ ] ✅ Recognize face with high confidence (>90%)
- [ ] ✅ Return customer data (name, tower, apartment)
- [ ] ✅ Store evidence
- [ ] ⚠️ Face not recognized (<50% confidence)

---

### 7. Access Service (Port 8086)

#### Get Client Types
```bash
curl http://localhost:8086/access/client-types
```

**Test Cases:**
- [ ] ✅ Returns 3 client types (FACIAL, PIN, NO_ID)
- [ ] ✅ Each type has correct color

---

### 8. External API Service (Port 9000)

#### Customer Endpoint
```bash
curl -X POST http://localhost:9000/api/external/customer \
  -H "Content-Type: application/json" \
  -d '{
    "customerId": "CUST-001",
    "name": "Test User",
    "tower": "Torre A",
    "apartment": "101",
    "photoUrl": "https://example.com/photo.jpg"
  }'
```

#### Purchase Endpoint
```bash
curl -X POST http://localhost:9000/api/external/purchase \
  -H "Content-Type: application/json" \
  -d '{
    "customerId": "CUST-001",
    "sessionId": "SES-001",
    "items": [
      {"productId": "prod-001", "quantity": 2}
    ]
  }'
```

**Test Cases:**
- [ ] ✅ Receive customer data from Concentrador
- [ ] ✅ Create session automatically
- [ ] ✅ Receive purchase data from AI system
- [ ] ✅ Populate cart automatically

---

## 🌐 Frontend Testing

### Manual UI Tests

#### Dashboard
- [ ] ✅ Shows active sessions (2 columns)
- [ ] ✅ FACIAL clients show real photo
- [ ] ✅ PIN clients show cyan silhouette
- [ ] ✅ NO_ID clients show AI photo
- [ ] ✅ Displays tower and apartment
- [ ] ✅ Item count is correct
- [ ] ✅ Total amount is correct (COP format)
- [ ] ✅ Click card navigates to CartView

#### CartView
- [ ] ✅ Shows customer info header
- [ ] ✅ Displays all cart items
- [ ] ✅ Quantity controls work (+/-)
- [ ] ✅ Remove item works
- [ ] ✅ Totals update in real-time
- [ ] ✅ "Continuar al Pago" button is prominent
- [ ] ✅ Suspend/Cancel buttons work

#### Login Modal
- [ ] ✅ Opens when clicking "Operador" badge
- [ ] ✅ Login with correct credentials works
- [ ] ✅ JWT token is stored
- [ ] ✅ "Cierre de Caja" button appears after login
- [ ] ⚠️ Wrong credentials show error

---

## 🔄 Integration Testing

### Flow 1: Complete Customer Journey (FACIAL)
```bash
# 1. Create session
SESSION_ID=$(curl -X POST http://localhost:8081/sessions \
  -H "Content-Type: application/json" \
  -d '{"clientType":"FACIAL","customerName":"Juan Pérez","tower":"Torre A","apartment":"501"}' \
  | jq -r '.sessionId')

# 2. Add items to cart
curl -X POST http://localhost:8082/carts/$SESSION_ID/items \
  -H "Content-Type: application/json" \
  -d '{"productId":"prod-001","quantity":2}'

# 3. Get cart total
TOTAL=$(curl http://localhost:8082/carts/session/$SESSION_ID | jq -r '.totalAmount')

# 4. Initiate payment
curl -X POST http://localhost:8084/payments/initiate \
  -H "Content-Type: application/json" \
  -d "{\"sessionId\":\"$SESSION_ID\",\"paymentMethod\":\"PSE\",\"amount\":$TOTAL}"

# 5. Close session
curl -X POST http://localhost:8081/sessions/$SESSION_ID/close
```

### Flow 2: External System Integration
```bash
# 1. Concentrador sends customer data
curl -X POST http://localhost:9000/api/external/customer \
  -H "Content-Type: application/json" \
  -d '{"customerId":"CUST-001","name":"María García","tower":"Torre B","apartment":"302"}'

# 2. AI system sends purchase data
curl -X POST http://localhost:9000/api/external/purchase \
  -H "Content-Type: application/json" \
  -d '{"customerId":"CUST-001","items":[{"productId":"prod-001","quantity":3}]}'

# 3. Verify session was created
curl http://localhost:8081/sessions/active | jq '.[] | select(.customerName=="María García")'
```

---

## 📊 Performance Testing

### Load Test with Apache Bench
```bash
# Test GET /sessions/active
ab -n 1000 -c 10 http://localhost:8081/sessions/active

# Test GET /products
ab -n 5000 -c 50 http://localhost:8083/products
```

**Success Criteria:**
- [ ] 95% of requests complete in < 200ms
- [ ] 0% error rate
- [ ] Server handles 100 concurrent users

---

## ✅ Test Execution Checklist

### Pre-requisites
- [ ] Docker and Docker Compose installed
- [ ] PostgreSQL running (port 5432)
- [ ] RabbitMQ running (port 5672)
- [ ] Redis running (port 6379)
- [ ] All SQL scripts executed

### Backend
- [ ] All 9 services start successfully
- [ ] All health checks pass
- [ ] API Gateway routes correctly

### Frontend
- [ ] npm run dev starts without errors
- [ ] Can login as operator
- [ ] Dashboard loads sessions
- [ ] Cart page works

### Integration
- [ ] Frontend → API Gateway → Services
- [ ] External API → Session/Cart services
- [ ] WebSocket broadcasts updates

---

## 🐛 Known Issues

1. **Auth Service:** Rate limiting resets on service restart
2. **Payment Service:** Mock only, not real PSE integration
3. **Camera Service:** Mock facial recognition (95% confidence always)

---

## 📝 Test Data

### Default Operator
```json
{
  "username": "admin",
  "password": "admin123",
  "role": "ADMIN"
}
```

### Sample Products (21 total)
- Leche Alpina 1L - $3,800
- Huevos AA x12 - $8,500
- Pan Tajado Bimbo - $4,200
- Coca-Cola 400ml - $2,500
- Arroz Diana 500g - $2,100

---

**Última actualización:** 2025-12-28
