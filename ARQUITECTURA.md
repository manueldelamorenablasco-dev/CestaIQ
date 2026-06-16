# CestaIQ — Arquitectura MVP

## 1. RESUMEN EJECUTIVO

MVP enfocado en validación de mercado. La prioridad es velocidad de desarrollo
y simplicidad. La arquitectura está diseñada para escalar cuando sea necesario,
pero sin añadir complejidad que ralentice la validación.

---

## 2. WIREFRAMES POR PANTALLA

### PANTALLA 1 — Login
```
┌─────────────────────────────┐
│                             │
│  🛒 CestaIQ                 │
│                             │
│  Bienvenido de nuevo        │
│  Descubre dónde es más      │
│  barata tu compra           │
│                             │
│  ┌─────────────────────┐   │
│  │  G  Continuar con   │   │
│  │     Google          │   │
│  └─────────────────────┘   │
│                             │
│  ─────── o continúa ───────│
│                             │
│  ┌─────────────────────┐   │
│  │ 📧  Email           │   │
│  └─────────────────────┘   │
│  ┌─────────────────────┐   │
│  │ 🔒  Contraseña      │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │   INICIAR SESIÓN    │   │ ← verde
│  └─────────────────────┘   │
│                             │
│  ¿No tienes cuenta?         │
│  Regístrate gratis          │
│                             │
└─────────────────────────────┘
```

### PANTALLA 2 — Home (Explorar)
```
┌─────────────────────────────┐
│  Buenos días, Manuel 👋     │
│  ¿Dónde es más barata hoy?  │
│                             │
│  ┌─────────────────────┐   │
│  │ 🔍 Buscar productos │   │
│  └─────────────────────┘   │
│                             │
│  [Todos][Lácteos][Frutas]→  │ ← chips scrollables
│                             │
│  Lo más buscado             │
│  ┌───┐ ┌───┐ ┌───┐        │ ← scroll horizontal
│  │🥛 │ │🥚 │ │🍌 │        │
│  └───┘ └───┘ └───┘        │
│                             │
│  Todos los productos        │
│  ┌──────┐ ┌──────┐         │ ← grid 2 columnas
│  │  🥛  │ │  🥚  │         │
│  │Leche │ │Huevos│         │
│  │[+añadir]│[+añadir]│    │
│  └──────┘ └──────┘         │
│                             │
├─────┬──────────┬────────────┤
│ 🔍  │  🛒 (3) │    👤      │ ← bottom nav
│Expl │  Cesta  │   Perfil   │
└─────┴──────────┴────────────┘
```

### PANTALLA 3 — Detalle de Producto (Comparador)
```
┌─────────────────────────────┐
│ ←  Leche semidesnatada...   │ ← appbar
│                             │
│ ┌─────────────────────────┐ │
│ │          🥛             │ │ ← emoji grande
│ │      (200px alto)       │ │
│ └─────────────────────────┘ │
│                             │
│ [LÁCTEOS]                   │ ← badge categoría
│ Leche semidesnatada 1L      │ ← nombre
│ Hacendado                   │ ← marca
│                             │
│ Comparar precios            │
│ (de menor a mayor)          │
│                             │
│ ┌─────────────────────────┐ │
│ │ 1 [L] Lidl   0,79€ 🏆  │ │ ← MEJOR PRECIO badge
│ │    "Ahorras 0,20€"      │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 2 [M] Mercadona  0,89€  │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 3 [C] Carrefour  0,99€  │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │  🛒  AÑADIR A MI CESTA  │ │ ← verde
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

### PANTALLA 4 — Mi Cesta
```
┌─────────────────────────────┐
│  Mi Cesta         [Vaciar]  │
│                             │
│  ┌─────────────────────────┐│
│  │ 🥛 Leche semid. 1L      ││ ← slide to delete
│  │    Hacendado    [-][1][+]││
│  └─────────────────────────┘│
│  ┌─────────────────────────┐│
│  │ 🥚 Huevos L x12         ││
│  │    El Pozo      [-][2][+]││
│  └─────────────────────────┘│
│  ┌─────────────────────────┐│
│  │ 🍌 Plátanos 1kg         ││
│  │    Plátano Canarias [-][1][+]
│  └─────────────────────────┘│
│           ...               │
│                             │
│  ─────────────────────────  │
│  3 productos · 4 unidades   │
│ ┌─────────────────────────┐ │
│ │ 🔍 ¿DÓNDE ES MÁS BARATA?│ │ ← verde
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

### PANTALLA 5 — Resultado de Cesta
```
┌─────────────────────────────┐
│ ←  Resultado de tu cesta    │
│                             │
│ ┌─────────────────────────┐ │
│ │         Mejor opción    │ │
│ │           LIDL          │ │ ← gradiente verde
│ │  💰 Ahorras 1,23 €     │ │
│ └─────────────────────────┘ │
│                             │
│ Coste total por supermercado│
│ 3 productos · 4 unidades    │
│                             │
│ ┌─────────────────────────┐ │
│ │ 1 [L] Lidl   ✓ Mejor   │ │ ← fondo verde claro
│ │         precio  3,47 € │ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 2 [M] Mercadona          │ │
│ │  +0,71€ más caro 4,18 €│ │
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ 3 [C] Carrefour          │ │
│ │  +1,23€ más caro 4,70 €│ │
│ └─────────────────────────┘ │
│                             │
│ Detalle de tu cesta         │
│ ┌─────────────────────────┐ │
│ │ 🥛 Leche...  x1  L M C │ │ ← precios por supermercado
│ │ 🥚 Huevos... x2  L M C │ │
│ │ 🍌 Plátanos. x1  L M C │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

### PANTALLA 6 — Perfil
```
┌─────────────────────────────┐
│  Mi Perfil                  │
│                             │
│           M                 │ ← círculo verde, inicial
│         Manuel              │
│    manuel@gmail.com         │
│                             │
│ ┌────────┬────────┬────────┐│
│ │   3    │   3    │   20   ││
│ │En cesta│Superm. │Product.││
│ └────────┴────────┴────────┘│
│                             │
│ CUENTA                      │
│ ┌─────────────────────────┐ │
│ │ 👤 Editar perfil      > │ │
│ │ 🔔 Alertas [Próxim.]  > │ │
│ └─────────────────────────┘ │
│                             │
│ APP                         │
│ ┌─────────────────────────┐ │
│ │ ⭐ Valorar CestaIQ    > │ │
│ │ 📤 Compartir          > │ │
│ │ ❓ Ayuda              > │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │      Cerrar sesión      │ │ ← borde rojo
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

---

## 3. ARQUITECTURA TÉCNICA

### Stack
- **Frontend**: Flutter 3.x
- **Backend**: Firebase (Auth + Firestore + Analytics)
- **Estado**: Riverpod 2.x
- **Persistencia de cesta**: StateNotifier (RAM → extensible a Firestore)

### Decisiones clave del MVP

| Decisión | Elección | Por qué |
|----------|----------|---------|
| Estado | Riverpod | Simple, sin boilerplate, escala bien |
| Datos | Mock local | Evita dependencia de datos reales para validar |
| Navegación | Navigator.push nativo | Sin complejidad de go_router para MVP |
| Imágenes | Emoji | Sin CDN, funciona offline, rápido de implementar |
| Auth | Firebase Auth | Google login en 30 minutos |

### Estructura de carpetas

```
lib/
├── main.dart               ← Entrada. Firebase init + ProviderScope
├── app.dart                ← MaterialApp + lógica auth state
├── firebase_options.dart   ← Generado por FlutterFire CLI
│
├── core/
│   ├── theme/
│   │   └── app_theme.dart  ← Colores, estilos, tema Material3
│   └── constants/
│       └── app_constants.dart
│
├── data/
│   ├── models/
│   │   ├── product.dart        ← Entidad Producto
│   │   ├── supermarket.dart    ← Entidad Supermercado
│   │   ├── price.dart          ← Entidad Precio
│   │   └── cart_item.dart      ← Entidad Elemento de Cesta
│   ├── mock/
│   │   └── mock_data.dart      ← 20 productos, 3 supermercados, 60 precios
│   └── services/
│       ├── auth_service.dart   ← Wrapper Firebase Auth
│       └── product_service.dart ← Datos de productos + cálculo de totales
│
├── providers/
│   ├── auth_provider.dart      ← authStateProvider (stream)
│   ├── products_provider.dart  ← products, filteredProducts, prices
│   └── cart_provider.dart      ← CartNotifier + cartTotalsProvider
│
├── screens/
│   ├── auth/login_screen.dart
│   ├── main_shell.dart         ← Bottom navigation shell
│   ├── home/home_screen.dart
│   ├── product/product_detail_screen.dart
│   ├── cart/cart_screen.dart
│   ├── cart/cart_result_screen.dart
│   └── profile/profile_screen.dart
│
└── widgets/
    └── product_card.dart       ← Reutilizable: grid + horizontal
```

---

## 4. MODELO DE DATOS FIRESTORE

### Colección: `users/{userId}`
```json
{
  "id": "uid_firebase",
  "nombre": "Manuel García",
  "email": "manuel@gmail.com",
  "fechaRegistro": "2025-06-16T10:00:00Z"
}
```

### Colección: `products/{productId}`
```json
{
  "id": "p01",
  "nombre": "Leche semidesnatada 1L",
  "marca": "Hacendado",
  "categoria": "Lácteos",
  "imageEmoji": "🥛"
}
```

### Colección: `supermarkets/{supermarketId}`
```json
{
  "id": "mercadona",
  "nombre": "Mercadona",
  "colorHex": "#007940"
}
```

### Colección: `prices/{productId_supermarketId}`
```json
{
  "productoId": "p01",
  "supermercadoId": "mercadona",
  "precio": 0.89,
  "fechaActualizacion": "2025-06-16T00:00:00Z"
}
```
**Índice compuesto necesario**: `productId ASC` + `amount ASC`

### Colección: `carts/{userId}`
```json
{
  "usuarioId": "uid_firebase",
  "productos": [
    { "productoId": "p01", "cantidad": 2 },
    { "productoId": "p05", "cantidad": 1 }
  ],
  "fechaActualizacion": "2025-06-16T10:00:00Z"
}
```

---

## 5. PASOS PARA PONER EN MARCHA

### Requisitos previos
1. Instalar Flutter SDK: https://flutter.dev/docs/get-started/install/windows
2. Instalar Android Studio + emulador Android
3. Cuenta en Firebase Console: https://console.firebase.google.com

### Configuración Firebase
```bash
# 1. Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# 2. En Firebase Console:
#    - Crear proyecto "cestaiq"
#    - Activar Authentication (Google + Email/Contraseña)
#    - Crear base de datos Firestore
#    - Activar Analytics

# 3. Configurar el proyecto Flutter
cd cestaiq
flutterfire configure

# 4. Instalar dependencias
flutter pub get

# 5. Ejecutar en emulador
flutter run
```

### Para Google Login en Android
Necesitas añadir la huella SHA-1 en Firebase Console:
```bash
# En Android Studio → Execute Gradle Task → signingReport
# O en la terminal:
cd android
./gradlew signingReport
```

---

## 6. ROADMAP DESPUÉS DEL MVP

### FASE 1 — Validación (semanas 1-4)
Objetivo: 100 usuarios reales, 50 con ≥3 sesiones

- [ ] Lanzar en Google Play (Internal Testing)
- [ ] Compartir con familia y amigos
- [ ] Medir: sesiones/semana, cestas creadas, pantallas visitadas
- [ ] Recoger feedback por WhatsApp/email

### FASE 2 — Mejoras según datos (semanas 5-8)

Si los usuarios crean cestas → priorizar:
- [ ] Guardar cestas en Firestore (persistencia entre sesiones)
- [ ] Historial de cestas anteriores

Si los usuarios buscan productos que no existen → priorizar:
- [ ] Ampliar catálogo a 100+ productos
- [ ] Añadir supermercados (Aldi, Alcampo, DIA)

Si hay abandono en el comparador → priorizar:
- [ ] Mejorar UI del resultado con más detalle
- [ ] Compartir resultado por WhatsApp

### FASE 3 — Crecimiento (mes 3-4)

- [ ] Alertas de precio (push notifications con FCM)
- [ ] Histórico de precios (gráfico simple)
- [ ] Compartir cesta con pareja/familia
- [ ] Onboarding de 3 pantallas para nuevos usuarios
- [ ] SEO/landing page web

### FASE 4 — Monetización (mes 5-6)

Solo si tienes ≥500 usuarios activos semanales:
- [ ] Plan Premium 24,99€/año
- [ ] Alertas personalizadas (Premium)
- [ ] Estadísticas de ahorro mensual (Premium)
- [ ] Predicciones de oferta (Premium + IA)

### FASE 5 — Datos reales (mes 6+)

Estrategia de datos reales (por orden de viabilidad):
1. **Crowdsourcing** (usuarios suben precios) — Costo: 0€, Riesgo: calidad
2. **Tickets de compra** (OCR de fotos de ticket) — Costo: bajo, Riesgo: medio
3. **Acuerdos comerciales** — Costo: negociación, Riesgo: bajo
4. **Scraping** (solo donde sea legal) — Costo: infraestructura, Riesgo: legal

---

## 7. MÉTRICAS A MEDIR DESDE DÍA 1

Con Firebase Analytics, rastrear estos eventos:

| Evento | Qué valida |
|--------|-----------|
| `product_search` | ¿Buscan productos? |
| `product_view` | ¿Comparan precios? |
| `add_to_cart` | ¿Crean cestas? |
| `view_cart_result` | ¿Llegan al comparador final? |
| `session_count` | ¿Vuelven? |
| `share_result` | ¿Es viral? |

**Criterio de éxito del MVP**:
- ≥ 40% de usuarios que crean una cesta vuelven en la semana siguiente
- ≥ 25% de usuarios visualizan el resultado de su cesta
- Valoración ≥ 4/5 en feedback cualitativo

---

## 8. RIESGOS PRINCIPALES

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|-----------|
| Los precios mock no son reales | Alta | Medio | Comunicar claramente que son de ejemplo |
| Usuario no entiende el valor | Media | Alto | Onboarding claro desde el inicio |
| Competencia ya establecida (Rastreador) | Alta | Medio | Diferenciarse en UX y velocidad |
| Datos reales costosos de obtener | Alta | Alto | Validar demanda primero, luego invertir en datos |
| App Store rejectada | Baja | Alto | Seguir guías de Google Play desde el inicio |
