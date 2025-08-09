# COOGUARPENAL - Wireframes y Mockups del Sistema

## 🎨 Guía de Diseño Visual

### Paleta de Colores
```css
/* Colores Primarios */
--cooperativo-azul: #1976D2;      /* Azul institucional */
--cooperativo-verde: #388E3C;     /* Verde cooperativo */
--cooperativo-dorado: #F57C00;    /* Dorado para destacar */

/* Colores Secundarios */
--gris-claro: #F5F5F5;           /* Fondos */
--gris-medio: #9E9E9E;           /* Textos secundarios */
--gris-oscuro: #424242;          /* Textos principales */

/* Colores de Estado */
--exito: #4CAF50;                /* Operaciones exitosas */
--advertencia: #FF9800;          /* Alertas */
--error: #F44336;                /* Errores */
--info: #2196F3;                 /* Información */
```

### Tipografía
- **Primaria:** Inter (headings)
- **Secundaria:** Open Sans (body text)
- **Monospace:** Fira Code (códigos/números)

---

## 🏠 Página de Inicio - Wireframe Detallado

```ascii
┌─────────────────────────────────────────────────────────────┐
│ [LOGO COOGUARPENAL]    [Inicio] [Servicios] [Noticias]     │
│                                 [Contacto] [Portal] 🔐      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🌟 HERO SECTION                                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  35+ AÑOS DE COMPROMISO Y SOLIDARIDAD               │   │
│  │  Cooperativa al servicio de la Guardia              │   │
│  │  Penitenciaria y Pensionados de Colombia            │   │
│  │                                                     │   │
│  │  [🚀 ACCEDER AL PORTAL]  [📞 CONTACTAR]           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  📊 SERVICIOS DESTACADOS                                   │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌──────────┐   │
│  │💰 CRÉDITOS│ │🆘 AUXILIOS│ │🤝 MUTUOS  │ │🛡️ SEGUROS│   │
│  │Educativos │ │Jurídicos  │ │Solidarios │ │Vida/Hogar│   │
│  │0.8% Interés│ │Asesoría   │ │Apoyo Mutuo│ │Protección│   │
│  │[Ver más]  │ │[Ver más]  │ │[Ver más]  │ │[Ver más] │   │
│  └───────────┘ └───────────┘ └───────────┘ └──────────┘   │
│                                                             │
│  🏛️ QUIÉNES SOMOS                                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ "Somos una cooperativa multiactiva comprometida     │   │
│  │  con el bienestar de nuestros asociados..."        │   │
│  │                                                     │   │
│  │  [📖 NUESTRA HISTORIA]  [🎯 MISIÓN Y VISIÓN]      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  📈 NUESTRO IMPACTO                                        │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │  2,500+  │ │  $2.5B   │ │   98%    │ │   15K+   │      │
│  │Asociados │ │Créditos  │ │Satisfacc.│ │Servicios │      │
│  │Activos   │ │Otorgados │ │Cliente   │ │Prestados │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
│                                                             │
│  📰 ÚLTIMAS NOTICIAS                                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ [📅 15 Ene] Convocatoria Asamblea Ordinaria 2025   │   │
│  │ [📅 10 Ene] Nuevas tasas de interés para créditos  │   │
│  │ [📅 05 Ene] Apertura de inscripciones auxilios     │   │
│  │                                        [Ver todas] │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  📍 CONTÁCTANOS                                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📍 Carrera XX #XX-XX, Bogotá D.C.                  │   │
│  │ ☎️  (601) XXX-XXXX                                 │   │
│  │ 📧 info@cooguardpenal.com                          │   │
│  │ 🕒 Lun-Vie: 8:00am - 5:00pm                        │   │
│  │    Sáb: 8:00am - 12:00pm                           │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 📊 Dashboard Portal de Asociados - Wireframe

```ascii
┌─────────────────────────────────────────────────────────────┐
│ [LOGO] Dashboard    [🔔 Notificaciones] [👤 Juan Pérez ▼]  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ 👋 ¡Bienvenido de nuevo, Juan!                             │
│ Último acceso: 15 Ene 2024, 2:30 PM                       │
│                                                             │
│ ┌─────────────────────┐ ┌─────────────────────────────────┐ │
│ │ 💰 ESTADO FINANCIERO│ │ ⚡ ACCIONES RÁPIDAS             │ │
│ │                     │ │                                 │ │
│ │ Préstamos Activos:  │ │ ┌─────────────┐ ┌─────────────┐ │ │
│ │ • Educativo: $2.5M  │ │ │💰 Solicitar │ │🆘 Solicitar │ │ │
│ │ • Personal: $800K   │ │ │  Crédito    │ │   Auxilio   │ │ │
│ │                     │ │ └─────────────┘ └─────────────┘ │ │
│ │ Próximo Pago:       │ │ ┌─────────────┐ ┌─────────────┐ │ │
│ │ 28 Ene - $245,000   │ │ │📄 Descargar │ │📊 Ver       │ │ │
│ │                     │ │ │ Certificado │ │ Historial   │ │ │
│ │ Ahorros: $1.2M      │ │ └─────────────┘ └─────────────┘ │ │
│ └─────────────────────┘ └─────────────────────────────────┘ │
│                                                             │
│ ┌─────────────────────┐ ┌─────────────────────────────────┐ │
│ │ 📋 TAREAS PENDIENTES│ │ 📈 ACTIVIDAD RECIENTE           │ │
│ │                     │ │                                 │ │
│ │ • Entregar documento│ │ • Pago procesado - $245K        │ │
│ │   para auxilio      │ │   [15 Ene 2024]                │ │
│ │   jurídico         │ │                                 │ │
│ │                     │ │ • Solicitud de certificado     │ │
│ │ • Actualizar datos  │ │   [14 Ene 2024]                │ │
│ │   de contacto       │ │                                 │ │
│ │                     │ │ • Auxilio aprobado - $150K      │ │
│ │ [Ver todas]         │ │   [12 Ene 2024]                │ │
│ └─────────────────────┘ └─────────────────────────────────┘ │
│                                                             │
│ ┌───────────────────────────────────────────────────────┐   │
│ │ 📊 EVOLUCIÓN DE TUS AHORROS                           │   │
│ │                                                       │   │
│ │     │                                   ╭─╮           │   │
│ │ 1.5M│                               ╭─╮ │ │           │   │
│ │ 1.2M│                           ╭─╮ │ │ │ │           │   │
│ │ 900K│                       ╭─╮ │ │ │ │ │ │           │   │
│ │ 600K│                   ╭─╮ │ │ │ │ │ │ │ │           │   │
│ │ 300K│               ╭─╮ │ │ │ │ │ │ │ │ │ │           │   │
│ │   0 └─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─   │   │
│ │      E F M A M J J A S O N D E F M A M J J A S O N D   │   │
│ │      2023                   2025                       │   │
│ └───────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘

Menú Lateral:
┌─────────────────┐
│ 🏠 Dashboard    │
│ 💰 Préstamos    │
│ 🆘 Auxilios     │
│ 📄 Documentos   │
│ 👤 Mi Perfil    │
│ 📞 Soporte      │
│ 🚪 Cerrar Sesión│
└─────────────────┘
```

---

## 💰 Módulo de Préstamos - Wireframe

```ascii
┌─────────────────────────────────────────────────────────────┐
│ PRÉSTAMOS Y CRÉDITOS                                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ ┌─ PESTAÑAS ─────────────────────────────────────────────┐  │
│ │ [Mis Préstamos] [Solicitar] [Simulador] [Historial]   │  │
│ └────────────────────────────────────────────────────────┘  │
│                                                             │
│ 📊 MIS PRÉSTAMOS ACTIVOS                                   │
│ ┌───────────────────────────────────────────────────────┐   │
│ │ Préstamo Educativo #PE-2024-001                      │   │
│ │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │   │
│ │ 💰 Monto: $2,500,000    📅 Plazo: 24 meses           │   │
│ │ 📈 Tasa: 0.8% mensual   💳 Cuota: $115,240          │   │
│ │ 🗓️  Próximo pago: 28 Ene 2025                        │   │
│ │ 📊 Saldo: $1,850,000 (12 cuotas pagadas)            │   │
│ │                                                       │   │
│ │ [💳 Pagar Cuota] [📄 Ver Detalle] [🧾 Descargar]    │   │
│ └───────────────────────────────────────────────────────┘   │
│                                                             │
│ ┌───────────────────────────────────────────────────────┐   │
│ │ Préstamo Personal #PP-2023-087                       │   │
│ │ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │   │
│ │ 💰 Monto: $800,000      📅 Plazo: 12 meses           │   │
│ │ 📈 Tasa: 1.2% mensual   💳 Cuota: $72,845           │   │
│ │ 🗓️  Próximo pago: 28 Ene 2025                        │   │
│ │ 📊 Saldo: $291,380 (8 cuotas pagadas)               │   │
│ │                                                       │   │
│ │ [💳 Pagar Cuota] [📄 Ver Detalle] [🧾 Descargar]    │   │
│ └───────────────────────────────────────────────────────┘   │
│                                                             │
│ 📈 GRÁFICO DE PAGOS                                        │
│ ┌───────────────────────────────────────────────────────┐   │
│ │          Evolución de Saldos de Préstamos            │   │
│ │                                                       │   │
│ │ 3M │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓              │   │
│ │ 2M │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░              │   │
│ │ 1M │▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░              │   │
│ │ 0  └─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─ │   │
│ │     E F M A M J J A S O N D E F M A M J J A S O N D  │   │
│ │     ▓▓ Educativo  ░░ Personal                        │   │
│ └───────────────────────────────────────────────────────┘   │
│                                                             │
│ ⚡ ACCIONES RÁPIDAS                                        │
│ [💰 Solicitar Nuevo Préstamo] [🧮 Usar Simulador]        │
│ [📊 Ver Historial Completo] [📞 Contactar Asesor]        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🧮 Simulador de Créditos - Wireframe

```ascii
┌─────────────────────────────────────────────────────────────┐
│ SIMULADOR DE CRÉDITOS                                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ 🧮 Calcula tu préstamo ideal                               │
│                                                             │
│ ┌─────────────────┐ ┌─────────────────────────────────────┐ │
│ │ DATOS DEL       │ │ RESULTADOS DE LA SIMULACIÓN         │ │
│ │ PRÉSTAMO        │ │                                     │ │
│ │                 │ │ 💰 Cuota Mensual                    │ │
│ │ Tipo de crédito:│ │ ┌─────────────────────────────────┐ │ │
│ │ [Educativo  ▼]  │ │ │        $115,240                 │ │ │
│ │                 │ │ └─────────────────────────────────┘ │ │
│ │ Monto solicitado│ │                                     │ │ │
│ │ [$2,500,000 ]   │ │ 📊 Detalles del Crédito           │ │ │
│ │                 │ │ • Monto: $2,500,000                │ │ │
│ │ Plazo (meses):  │ │ • Plazo: 24 meses                  │ │ │
│ │ [24      ▼]     │ │ • Tasa mensual: 0.8%               │ │ │
│ │                 │ │ • Total a pagar: $2,765,760        │ │ │
│ │ Salario base:   │ │ • Total intereses: $265,760        │ │ │
│ │ [$1,500,000 ]   │ │                                     │ │ │
│ │                 │ │ ⚠️  Tu cuota representa el 7.7%     │ │ │
│ │ [🧮 SIMULAR]    │ │    de tu salario (máximo 30%)      │ │ │
│ └─────────────────┘ │                                     │ │
│                     │ ✅ Préstamo viable                  │ │ │
│                     └─────────────────────────────────────┘ │
│                                                             │
│ 📈 TABLA DE AMORTIZACIÓN                                   │
│ ┌───────────────────────────────────────────────────────┐   │
│ │ Cuota │  Fecha    │  Capital  │ Interés │  Saldo      │   │
│ │───────│───────────│───────────│─────────│─────────────│   │
│ │   1   │ Feb 2025  │  95,240   │ 20,000  │ 2,404,760   │   │
│ │   2   │ Mar 2025  │  96,001   │ 19,239  │ 2,308,759   │   │
│ │   3   │ Abr 2025  │  96,769   │ 18,471  │ 2,211,990   │   │
│ │   4   │ May 2025  │  97,544   │ 17,696  │ 2,114,446   │   │
│ │   5   │ Jun 2025  │  98,325   │ 16,915  │ 2,016,121   │   │
│ │  ...  │    ...    │    ...    │   ...   │     ...     │   │
│ │  24   │ Ene 2026  │ 114,327   │   913   │      0      │   │
│ │───────│───────────│───────────│─────────│─────────────│   │
│ │ TOTAL │           │2,500,000  │ 265,760 │             │   │
│ └───────────────────────────────────────────────────────┘   │
│                                                             │
│ [📄 Generar PDF] [💰 Solicitar Este Préstamo]            │
└─────────────────────────────────────────────────────────────┘
```

---

## 📱 Versión Móvil - Layout Responsivo

```ascii
MÓVIL - DASHBOARD
┌─────────────────┐
│ ☰ [LOGO] 🔔 👤  │
├─────────────────┤
│ 👋 ¡Hola Juan!  │
│                 │
│ ┌─────────────┐ │
│ │💰 PRÉSTAMOS │ │
│ │             │ │
│ │ Educativo   │ │
│ │ $1,850,000  │ │
│ │             │ │
│ │ Próximo:    │ │
│ │ 28 Ene      │ │
│ │ $115,240    │ │
│ └─────────────┘ │
│                 │
│ ┌─────────────┐ │
│ │🆘 AUXILIOS  │ │
│ │             │ │
│ │ 2 Activos   │ │
│ │ 1 Pendiente │ │
│ │             │ │
│ │ [Ver Todo]  │ │
│ └─────────────┘ │
│                 │
│ ┌─────────────┐ │
│ │⚡ ACCIONES  │ │
│ │             │ │
│ │ • Solicitar │ │
│ │   Crédito   │ │
│ │ • Descargar │ │
│ │   Certific. │ │
│ │ • Ver       │ │
│ │   Historial │ │
│ └─────────────┘ │
│                 │
│ [🏠][💰][🆘][📄]│
└─────────────────┘

MÓVIL - MENÚ HAMBURGUESA
┌─────────────────┐
│ ✕ MENÚ          │
├─────────────────┤
│ 👤 Juan Pérez   │
│ 📧 juan@mail... │
├─────────────────┤
│ 🏠 Dashboard    │
│ 💰 Préstamos    │
│ 🆘 Auxilios     │
│ 📄 Documentos   │
│ 👤 Mi Perfil    │
│ ⚙️  Configurac. │
│ 📞 Soporte      │
├─────────────────┤
│ 🚪 Cerrar Sesión│
└─────────────────┘
```

---

## 🎯 Principios de UX/UI Aplicados

### 1. **Simplicidad y Claridad**
- Interfaces limpias con información jerarquizada
- Uso de iconos universales para acciones comunes
- Textos claros y directos, evitando tecnicismos

### 2. **Accesibilidad**
- Contraste adecuado para cumplir WCAG 2.1 AA
- Navegación por teclado en todos los elementos
- Textos alternativos para elementos gráficos
- Tamaños de fuente escalables

### 3. **Responsive Design**
- Mobile-first approach
- Layouts flexibles que se adaptan a cualquier pantalla
- Menús colapsables para dispositivos móviles
- Touch-friendly (botones mínimo 44px)

### 4. **Feedback Visual**
- Estados claros para botones (hover, active, disabled)
- Indicadores de carga para procesos largos
- Mensajes de confirmación para acciones importantes
- Animaciones sutiles para transiciones

### 5. **Consistencia**
- Patrones de diseño uniformes en toda la aplicación
- Nomenclatura consistente para acciones similares
- Colores y tipografía coherentes con la marca

---

## 🔄 Flujos de Usuario Principales

### Flujo 1: Solicitud de Crédito Educativo
```
1. Login → 2. Dashboard → 3. Préstamos → 4. Solicitar → 
5. Formulario → 6. Documentos → 7. Revisión → 8. Envío → 
9. Confirmación → 10. Seguimiento
```

### Flujo 2: Consulta de Estado de Cuenta
```
1. Login → 2. Dashboard → 3. Documentos → 4. Estados de Cuenta → 
5. Seleccionar Período → 6. Visualizar/Descargar
```

### Flujo 3: Solicitud de Auxilio Jurídico
```
1. Login → 2. Dashboard → 3. Auxilios → 4. Solicitar → 
5. Tipo de Auxilio → 6. Formulario → 7. Documentos → 
8. Envío → 9. Seguimiento
```

---

*Wireframes v1.0 - Listos para validación y desarrollo*
