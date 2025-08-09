# 🚀 Guía de Configuración N8N para COOGUARDPENAL Chat

## 📋 Resumen del Sistema

El chat de COOGUARDPENAL ahora está integrado con **N8N** para proporcionar respuestas inteligentes en tiempo real usando AI Agents. El flujo funciona así:

```
Usuario → Frontend → N8N Webhook → AI Agent → Respuesta → Frontend
```

## 🔧 Configuración N8N

### 1. Crear el Flujo Base

Tu flujo N8N debe tener estos nodos:

#### 📥 **Webhook de Entrada** 
- **URL**: `/webhook/cooguardpenal-chat`
- **Método**: `POST`
- **Campos esperados**:
  ```json
  {
    "user_input": "¿Cómo me afilio?",
    "session_id": "session_1672837461234_abc123",
    "conversation_id": "conv_1672837461234_def456", 
    "timestamp": "2024-01-15T10:30:00.000Z",
    "page_url": "https://cooguardpenal.com/",
    "user_agent": "Mozilla/5.0..."
  }
  ```

#### 🤖 **AI Agent Node**
- **Modelo**: OpenAI Chat Model 
- **Sistema**: Configurar prompt con información de COOGUARDPENAL
- **Memory**: Simple Memory para mantener contexto
- **Tools**: SerpAPI para búsquedas (opcional)

#### 📤 **HTTP Request - Respuesta**
- **URL**: `https://cooguardpenal.com/api/chat/n8n/response/`
- **Método**: `POST`
- **Headers**: `Content-Type: application/json`
- **Body**:
  ```json
  {
    "session_id": "{{ $('Webhook').first().json.session_id }}",
    "conversation_id": "{{ $('Webhook').first().json.conversation_id }}",
    "response": "{{ $('AI Agent').first().json.response }}"
  }
  ```

### 2. Configurar el AI Agent

#### Prompt del Sistema:
```
Eres el asistente virtual oficial de COOGUARDPENAL, una cooperativa multiactiva para trabajadores del INPEC y pensionados de Colombia.

INFORMACIÓN CLAVE:
- Fundada en 1989 (35+ años de experiencia)
- 5,000+ familias afiliadas
- Tasas preferenciales: Créditos educativos 0.8% mensual, personales 1.2% mensual
- Ubicación: Carrera 5 #16-14 Of. 402, Edificio El Globo, Bogotá
- Teléfonos: (601) 3362834 / 3362835
- Email: cooguarpenal78@gmail.com
- Horarios: Lunes a Viernes, 8:00 AM - 5:00 PM

SERVICIOS PRINCIPALES:
1. Créditos educativos (0.8% mensual, sin codeudor, hasta 60 meses)
2. Créditos personales (1.2% mensual, hasta $20M, descuento por nómina)
3. Auxilios jurídicos, solidarios, especiales y funerarios
4. Ahorros con hasta 8% EA

REQUISITOS AFILIACIÓN:
- Ser miembro activo o pensionado del sistema penitenciario
- Cédula de ciudadanía vigente
- Certificado laboral vigente
- Últimos 3 desprendibles de pago

TONO: Profesional, amable, servicial. Usa emojis apropiados. Ofrece contacto directo cuando sea necesario.

Responde de manera clara, concisa y útil. Si no tienes información específica, dirige al usuario a contactar directamente.
```

### 3. URLs de tu Configuración

Actualiza estas URLs en el código:

#### En `base.html` (línea ~3901):
```javascript
const n8nWebhookURL = 'TU_URL_N8N_AQUI/webhook/cooguardpenal-chat';
```

## 📊 Endpoints del Sistema

### Para N8N:
- **Enviar respuesta**: `POST /api/chat/n8n/response/`
- **Health check**: `GET /api/chat/health/`
- **Status**: `POST /api/chat/status/`

### Para Frontend:
- **Polling respuestas**: `POST /api/chat/poll-response/`

## 🔄 Flujo de Conversación

### 1. Usuario envía mensaje
```javascript
// Frontend detecta mensaje del usuario
sendToN8N("¿Cómo me afilio?")
```

### 2. Frontend → N8N
```http
POST https://tu-n8n.com/webhook/cooguardpenal-chat
Content-Type: application/json

{
  "user_input": "¿Cómo me afilio?",
  "session_id": "session_1672837461234_abc123",
  "conversation_id": "conv_1672837461234_def456",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "page_url": "https://cooguardpenal.com/",
  "user_agent": "Mozilla/5.0..."
}
```

### 3. N8N procesa con AI Agent
- El webhook recibe el mensaje
- El AI Agent analiza y genera respuesta
- Se ejecuta el nodo de respuesta

### 4. N8N → Frontend  
```http
POST https://cooguardpenal.com/api/chat/n8n/response/
Content-Type: application/json

{
  "session_id": "session_1672837461234_abc123", 
  "conversation_id": "conv_1672837461234_def456",
  "response": "¡Excelente! Para afiliarte a COOGUARDPENAL necesitas..."
}
```

### 5. Frontend muestra respuesta
```javascript
// El sistema de polling detecta la respuesta y la muestra al usuario
handleN8NResponse("¡Excelente! Para afiliarte...")
```

## 🛠️ Testing del Sistema

### 1. Health Check
```bash
curl -X GET https://cooguardpenal.com/api/chat/health/
```

### 2. Simular respuesta N8N
```bash
curl -X POST https://cooguardpenal.com/api/chat/n8n/response/ \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "test_session_123",
    "conversation_id": "test_conv_456", 
    "response": "Esta es una respuesta de prueba del agente N8N"
  }'
```

### 3. Verificar polling
```bash
curl -X POST https://cooguardpenal.com/api/chat/poll-response/ \
  -H "Content-Type: application/json" \
  -d '{
    "session_id": "test_session_123",
    "conversation_id": "test_conv_456"
  }'
```

## 🚀 Funcionalidades Implementadas

✅ **Sistema de sesiones**: Cada conversación tiene ID único  
✅ **Polling en tiempo real**: Respuestas aparecen automáticamente  
✅ **Fallback responses**: Si N8N falla, responde localmente  
✅ **Cache temporal**: Respuestas se almacenan por 5 minutos  
✅ **Logging completo**: Trazabilidad total del flujo  
✅ **Error handling**: Manejo robusto de errores  
✅ **Health checks**: Monitoreo del sistema  

## 🔮 Próximas Mejoras

- 🗄️ **Conexión a Base de Datos**: Para información en tiempo real
- 🔧 **Tools avanzadas**: Calculadoras de créditos, consultas de estado
- 🌐 **WebSockets**: Para chat completamente en tiempo real
- 📊 **Analytics**: Métricas de conversaciones
- 🎨 **UI mejorada**: Indicadores de estado más avanzados

## 🎯 Configuración Recomendada N8N

### Memory Settings:
- **Type**: Simple Memory
- **Max Messages**: 20
- **Session Key**: `{{ $('Webhook').first().json.session_id }}`

### Model Settings:
- **Model**: gpt-3.5-turbo o gpt-4
- **Temperature**: 0.7
- **Max Tokens**: 500
- **Top P**: 1

¡Tu sistema de chat N8N está listo para funcionar! 🚀✨
