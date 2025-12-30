# Alwon POS - API Documentation

**Versión:** 1.0.0  
**Última actualización:** 2025-12-28  
**API Gateway:** `http://localhost:8080/api`

---

## 📡 Servicios Disponibles

| Servicio | Puerto | Status | Swagger UI |
|----------|--------|--------|------------|
| API Gateway | 8080 | ✅ | - |
| Session Service | 8081 | ✅ | `http://localhost:8081/swagger-ui.html` |
| Cart Service | 8082 | ✅ | `http://localhost:8082/swagger-ui.html` |
| Product Service | 8083 | ✅ | `http://localhost:8083/swagger-ui.html` |
| Payment Service | 8084 | ✅ | `http://localhost:8084/swagger-ui.html` |
| Camera Service | 8085 | ✅ | `http://localhost:8085/swagger-ui.html` |
| Access Service | 8086 | ✅ | `http://localhost:8086/swagger-ui.html` |
| Inventory Service | 8087 | ✅ | `http://localhost:8087/swagger-ui.html` |
| Auth Service | 8088 | ✅ | `http://localhost:8088/swagger-ui.html` |
| WebSocket Server | 8090 | ✅ | `http://localhost:8090/actuator/health` |
| External API | 9000 | ✅ | `http://localhost:9000/swagger-ui.html` |

---

## 🔐 Authentication Service (Port 8088)

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "operatorId": "op-001",
  "name": "Administrador",
  "role": "ADMIN",
  "expiresIn": 28800000
}
```

### Verify Code
```http
POST /api/auth/verify-code
Content-Type: application/json

{
  "operatorId": "op-001",
  "code": "123456"
}
```

---

## 👥 Session Service (Port 8081)

### Get Active Sessions
```http
GET /api/sessions/active
Authorization: Bearer {token}
```

**Response:**
```json
[
  {
    "sessionId": "SES-001",
    "clientType": "FACIAL",
    "customerName": "Juan Pérez",
    "customerPhotoUrl": "https://example.com/photo.jpg",
    "tower": "Torre A",
    "apartment": "501",
    "itemCount": 5,
    "totalAmount": 36300,
    "status": "ACTIVE",
    "createdAt": "2025-12-28T10:00:00Z"
  }
]
```

### Create Session
```http
POST /api/sessions
Content-Type: application/json

{
  "clientType": "FACIAL",
  "customerName": "María García",
  "customerPhotoUrl": "https://example.com/photo2.jpg",
  "tower": "Torre B",
  "apartment": "302"
}
```

### Close Session
```http
POST /api/sessions/{sessionId}/close
Authorization: Bearer {token}
```

---

## 🛒 Cart Service (Port 8082)

### Get Cart
```http
GET /api/carts/session/{sessionId}
```

**Response:**
```json
{
  "sessionId": "SES-001",
  "items": [
    {
      "itemId": "item-1",
      "productId": "prod-001",
      "productName": "Leche Alpina 1L",
      "quantity": 2,
      "unitPrice": 3800,
      "totalPrice": 7600,
      "imageUrl": "https://example.com/leche.jpg"
    }
  ],
  "totalItems": 5,
  "totalAmount": 36300
}
```

### Add Item to Cart
```http
POST /api/carts/{sessionId}/items
Content-Type: application/json

{
  "productId": "prod-001",
  "quantity": 2
}
```

### Update Item Quantity
```http
PATCH /api/carts/{sessionId}/items/{itemId}
Content-Type: application/json

{
  "quantity": 3
}
```

### Remove Item
```http
DELETE /api/carts/{sessionId}/items/{itemId}
```

---

## 📦 Product Service (Port 8083)

### Get All Products
```http
GET /api/products
```

### Search Products
```http
GET /api/products/search?query=leche
```

### Get Products by Category
```http
GET /api/products/category/LACTEOS
```

### Get Product by ID
```http
GET /api/products/{productId}
```

**Response:**
```json
{
  "productId": "prod-001",
  "name": "Leche Alpina 1L",
  "description": "Leche entera pasteurizada",
  "price": 3800,
  "category": "LACTEOS",
  "stockQuantity": 50,
  "imageUrl": "https://example.com/leche.jpg",
  "barcode": "7702001234567",
  "sku": "ALP-LECHE-1L"
}
```

---

## 💳 Payment Service (Port 8084)

### Initiate Payment
```http
POST /api/payments/initiate
Content-Type: application/json

{
  "sessionId": "SES-001",
  "paymentMethod": "PSE",
  "amount": 36300
}
```

**Response:**
```json
{
  "transactionId": "TXN-001",
  "status": "PENDING",
  "paymentUrl": "https://pse.example.com/checkout/12345",
  "expiresAt": "2025-12-28T11:00:00Z"
}
```

### Get Payment Status
```http
GET /api/payments/{transactionId}
```

---

## 📷 Camera Service (Port 8085)

### Facial Recognition
```http
POST /api/camera/facial-recognition
Content-Type: application/json

{
  "sessionId": "SES-001",
  "imageData": "base64_encoded_image_data",
  "mimeType": "image/jpeg"
}
```

**Response:**
```json
{
  "customerId": "CUST-001",
  "confidence": 95.5,
  "name": "Juan Pérez",
  "tower": "Torre A",
  "apartment": "501",
  "photoUrl": "https://example.com/photo.jpg"
}
```

### Get Evidence
```http
GET /api/camera/evidence/session/{sessionId}
```

---

## 🚪 Access Service (Port 8086)

### Get Client Types
```http
GET /api/access/client-types
```

**Response:**
```json
[
  {
    "type": "FACIAL",
    "displayName": "Reconocimiento Facial",
    "color": "#22c55e"
  },
  {
    "type": "PIN",
    "displayName": "Código PIN",
    "color": "#eab308"
  },
  {
    "type": "NO_ID",
    "displayName": "Sin Identificar",
    "color": "#ef4444"
  }
]
```

---

## 📊 Inventory Service (Port 8087)

### Get Stock Availability
```http
GET /api/inventory/products/{productId}/availability
```

### Record Stock Movement
```http
POST /api/inventory/movements
Content-Type: application/json

{
  "productId": "prod-001",
  "movementType": "SALE",
  "quantity": 2,
  "sessionId": "SES-001"
}
```

---

## 🌐 External API Service (Port 9000)

### Receive Customer Data (from Concentrador)
```http
POST /api/external/customer
Content-Type: application/json

{
  "customerId": "CUST-001",
  "name": "Juan Pérez",
  "tower": "Torre A",
  "apartment": "501",
  "photoUrl": "https://example.com/photo.jpg"
}
```

### Receive Purchase Data (from AI System)
```http
POST /api/external/purchase
Content-Type: application/json

{
  "customerId": "CUST-001",
  "sessionId": "SES-001",
  "items": [
    {
      "productId": "prod-001",
      "quantity": 2
    }
  ]
}
```

---

## 🔌 WebSocket (Port 8090)

### Connect to WebSocket
```javascript
const socket = new SockJS('http://localhost:8090/ws');
const stompClient = Stomp.over(socket);

stompClient.connect({}, () => {
  // Subscribe to session updates
  stompClient.subscribe('/topic/sessions', (message) => {
    console.log('Session update:', JSON.parse(message.body));
  });
  
  // Subscribe to cart updates
  stompClient.subscribe('/topic/carts', (message) => {
    console.log('Cart update:', JSON.parse(message.body));
  });
});
```

---

## 🔧 Common Headers

```http
Content-Type: application/json
Authorization: Bearer {jwt_token}
Accept: application/json
```

---

## ⚠️ Error Responses

### 400 Bad Request
```json
{
  "error": "BAD_REQUEST",
  "message": "Invalid request parameters",
  "timestamp": "2025-12-28T10:00:00Z"
}
```

### 401 Unauthorized
```json
{
  "error": "UNAUTHORIZED",
  "message": "Invalid or expired token",
  "timestamp": "2025-12-28T10:00:00Z"
}
```

### 404 Not Found
```json
{
  "error": "NOT_FOUND",
  "message": "Resource not found",
  "timestamp": "2025-12-28T10:00:00Z"
}
```

### 500 Internal Server Error
```json
{
  "error": "INTERNAL_ERROR",
  "message": "An unexpected error occurred",
  "timestamp": "2025-12-28T10:00:00Z"
}
```

---

## 📝 Notes

- Todos los endpoints (excepto login) requieren autenticación JWT
- Los timestamps están en formato ISO 8601 (UTC)
- Los precios están en pesos colombianos (COP)
- Las imágenes se pueden enviar como Base64 o URLs
- El API Gateway enruta automáticamente a los microservicios
