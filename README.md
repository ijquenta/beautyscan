# BeautyScan — MVP

> Aplicación móvil de colorimetría y simulación de peinados impulsada por IA.

## Descripción
BeautyScan es una solución móvil con frontend desarrollado en Flutter que utiliza IA para democratizar el asesoramiento de imagen personal. La aplicación analiza el tono de piel del usuario para determinar su estación cromática y permite previsualizar cambios de look mediante simulación de peinados en tiempo real.

---

## Stack Tecnológico

| Capa | Tecnología | Propósito |
| :--- | :--- | :--- |
| **Desarrollo Frontend** | Flutter (Dart) | Base sólida para compilar un código único (MVP enfocado en Android). |
| **Persistencia Local** | SQLite (`sqflite`) | Base de datos local para sesiones, usuarios offline e historial sin requerir net. |
| **Almacenamiento en Nube** | Firebase Storage | Sincronización y alojamiento exclusivamente de imágenes generadas. |
| **Base de Datos Cloud** | Firebase Firestore | Sincronización de datos secundarios (Opcional). |
| **IA (Análisis Piel)** | Gemini API (gemini-2.5-flash) | Identificar los tonos, subtonos y estaciones cromáticas. |
| **IA (Peinados)** | Gemini API (gemini-2.5-flash-image) | Generación e iteración visual (Nano Banana) guiada por diálogo. |
| **Gestión Fotográfica** | `image_picker` + `camera` | Lectura desde galería nativa y captura de selfies live. |
| **Seguridad de Datos** | `crypto` | Hasheo asimétrico SHA-256 para contraseñas de las cuentas locales. |
| **Manejo de Sesión** | `shared_preferences` | Persistencia de tokens de sesión a nivel de dispositivo |

---

## Arquitectura 

El proyecto adopta un enfoque de diseño limpio (Clean Code) segmentado en capas para potenciar escalabilidad, reusabilidad y simplicidad de lectura:

### Estructura de Directorios Principal (Atomic Design)
```text
lib/
├── core/           # Configuración, temas visuales y constantes
├── data/           # DatabaseHelper y Repositorios de datos interactuando con SQLite
├── domain/         # Modelos de dominio y lógica de negocio (User, Analysis, etc.)
└── presentation/   # Capa UI organizada mediante filosofía Atomic Design
    ├── components/ # atoms (botones), molecules (tarjetas), organisms (secciones)
    └── screens/    # Definición de las pantallas principales
```

---

## Modelo y Esquema de Base de Datos (SQLite)

Contamos con 3 tablas principales para el soporte **Offline-First**, gestionando usuarios e historial sin conexión al entorno Firebase:

### `1. users`
**Propósito:** Almacén principal de identidad y validación en entorno seguro.
* `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
* `name` (TEXT NOT NULL) — Nombre del usuario
* `email` (TEXT NOT NULL UNIQUE) — Verificación de sesión
* `password_hash` (TEXT NOT NULL) — Checksum computado SHA-256 de la contraseña
* `profile_photo` (TEXT NULLABLE) — Ruta de imagen ubicable en el sandbox del OS 
* `created_at` (TEXT NOT NULL) — Sello cronológico

### `2. colorimetry_results`
**Propósito:** Trazabilidad de diagnósticos que el usuario se hace.
* `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
* `user_id` (INTEGER FOREIGN KEY)
* `photo_path` (TEXT NOT NULL) — Path local de la selfie
* `skin_tone` (TEXT NOT NULL) — Ej: "Medio-Cálido"
* `undertone` (TEXT NOT NULL) — Ej: "Dorado"
* `season` (TEXT NOT NULL) — Estación cromática (Ej: Otoño)
* `recommended_colors` (TEXT NOT NULL) — Array serializado con paleta sugerida
* `colors_to_avoid` (TEXT NOT NULL) — Array serializado de pantones a evadir
* `makeup_tips` (TEXT NULLABLE) — Recomendaciones contextuales de maquillaje
* `created_at` (TEXT NOT NULL) — Fecha

### `3. hairstyle_results`
**Propósito:** Registro temporal/permanente de la simulación gráfica del pelo impulsada por IA.
* `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
* `user_id` (INTEGER FOREIGN KEY)
* `original_photo_path` (TEXT NOT NULL)
* `hairstyle_name` (TEXT NOT NULL) — Meta-texto con el comando de peinado pedido
* `result_image_url` (TEXT NOT NULL) — URL del Storage donde se resguardó el output visual
* `created_at` (TEXT NOT NULL)

---

## Flujo de Navegación UI (17 pantallas)

Toda la aplicación está distribuida en zonas o módulos funcionales lógicos con el siguiente esquema de comportamiento principal de cara al usuario. Todo con transiciones nativas Flutter:

### **Zona 1: Autenticación y Entrada**
* **Splash Screen:** Carga de motor y auto-validación en `SharedPreferences` de token existente.
* **Onboarding:** Tres slides descriptivos mostrando ventajas y capacidades de visualización.
* **Login y Registro:** Check de cuenta mediante correo y contraseña hasheada contra el volumen SQLite, permitiendo uso completamente sin red exterior en validación.

### **Zona 2: Main Dashboard**
* **Home:** Centro unificador (Tarjetas resumen, stats pasadas, acceso a IA, mini listado reciente de peinados).

### **Zona 3: Motor Inferencia IA (Colorimetría)**
* **Scanner Fotográfico:** Área del visor (Overlay UI `camera`), centrado de rostro.
* **Pantalla de Análisis:** Animación local mientras Gemini API envía peticiones en entorno remoto y la red decodifica en un mapping JSON.
* **Resultados Diagnóstico:** Render de swatches, estación cromática detallada y consejos expandibles.

### **Zona 4: Simulación de Peinados**
* **Galería Base:** Grid donde el usuario filtra (estilos, largos, formas geométricas).
* **Work in progress:** Feed de carga mientras Gemini Nano interviene en la imagen con un prompt acoplado a la imagen del modelo local.
* **Display Simulación:** Renderización final, comparador "Antes/Después" estilo wipeo y feedback rápido (poder emitir ajustes a la IA mediante chat prompts para alterarlo).

### **Zona 5: Historial Offline**
* **Registro General:** Tarjetas de resultados anteriores divididos por peinado y análisis, cargados rápidamente debido al indexado relacional. Vista en grid para galería visual y lista para detalles.

### **Zona 6: Opciones de Perfil**
* **Settings:** Resumen biográfico, foto de avatar y descarte lógico del usuario que desencadena borrados ON CASCADE de `colorimetry_results` y `hairstyle_results`.