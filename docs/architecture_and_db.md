# Architecture & Database Layout

## Arquitectura de Software

El proyecto adopta un enfoque de diseño limpio (Clean Architecture) segmentado en capas para potenciar escalabilidad, reusabilidad y simplicidad de lectura.

### Estructura de Directorios Principal (Atomic Design)
```text
lib/
├── core/           # Configuración, temas visuales y constantes globales.
├── data/           # DatabaseHelper, modelos DTO y repositorios interactuando con SQLite local.
├── domain/         # Lógica de negocio (User, Analysis) y reglas estrictas del sistema.
└── presentation/   # Capa UI organizada rigurosamente mediante la filosofía Atomic Design
    ├── components/ # atoms (botones de texto), molecules (inputs), organisms (sliders).
    └── screens/    # Definición de las pantallas orquestadas y modulares.
```

## Stack Tecnológico

| Capa | Tecnología | Propósito |
| :--- | :--- | :--- |
| **Desarrollo Frontend** | Flutter (Dart) | Base sólida para compilar un código único (MVP enfocado en Android). |
| **Persistencia Local** | SQLite (`sqflite`) | Base de datos local para sesiones, usuarios offline e historial sin requerir red. |
| **Almacenamiento Cloud**| Firebase Storage | Sincronización y alojamiento exclusivamente de imágenes generadas. |
| **IA (Análisis Piel)** | Gemini API (Flash) | Identificar los tonos, subtonos y estaciones cromáticas. |
| **IA (Peinados)** | Gemini API (Image) | Generación e iteración visual guiada por lenguaje natural. |
| **Manejo de Archivos**| `image_picker` + `camera` | Lectura desde galería nativa y captura de selfies live. |
| **Criptografía** | `crypto` | Hasheo asimétrico SHA-256 para contraseñas locales. |

## Modelo y Esquema de Base de Datos (SQLite)

Contamos con 3 tablas principales para el soporte **Offline-First**, gestionando identidades e historiales en el propio dispositivo:

### `1. users`
**Propósito:** Almacén principal de identidad y validación en entorno local seguro.
* `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
* `name` (TEXT NOT NULL) — Nombre de pila del usuario.
* `email` (TEXT NOT NULL UNIQUE) — Llave de verificación de sesión.
* `password_hash` (TEXT NOT NULL) — Checksum computado en SHA-256 de la contraseña.
* `profile_photo` (TEXT NULLABLE) — Ruta física de imagen en el OS.
* `created_at` (TEXT NOT NULL)

### `2. colorimetry_results`
**Propósito:** Trazabilidad de diagnósticos fotográficos que el usuario se realiza.
* `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
* `user_id` (INTEGER FOREIGN KEY)
* `photo_path` (TEXT NOT NULL) — Path local de la selfie.
* `skin_tone` (TEXT NOT NULL) — Ej: "Medio-Cálido".
* `undertone` (TEXT NOT NULL) — Ej: "Dorado".
* `season` (TEXT NOT NULL) — Estación cromática (Ej: Otoño).
* `recommended_colors` (TEXT NOT NULL) — Array JSON serializado con paletas válidas.
* `colors_to_avoid` (TEXT NOT NULL) — Array JSON serializado de pantones a evadir.
* `makeup_tips` (TEXT NULLABLE) — Recomendaciones editoriales de maquillaje.
* `created_at` (TEXT NOT NULL)

### `3. hairstyle_results`
**Propósito:** Registro gráfico y metadata de simulaciones de peinados generados mediante IA.
* `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
* `user_id` (INTEGER FOREIGN KEY)
* `original_photo_path` (TEXT NOT NULL)
* `hairstyle_name` (TEXT NOT NULL) — Meta-texto sobre el peinado (Ej. Bob Caoba Cálida).
* `result_image_url` (TEXT NOT NULL) — URL del Storage donde reside el output definitivo de la IA.
* `created_at` (TEXT NOT NULL)
