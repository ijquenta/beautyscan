# BeautyScan — MVP

> Aplicación móvil de colorimetría y simulación de peinados impulsada por Inteligencia Artificial y un diseño editorial minimalista.

## Descripción
BeautyScan es una sofisticada solución móvil desarrollada en Flutter que utiliza IA (Gemini) para democratizar y elevar el asesoramiento de imagen personal. La aplicación analiza el tono de piel del usuario para determinar su estación cromática y permite previsualizar cambios de look estructurales (cortes y color) mediante simulación visual.

Se distingue por su rigurosa interfaz de usuario basada en diseño editorial de moda de alta gama, reemplazando convenciones habituales (iconos genéricos, sombras y botones) por una poderosa jerarquía y pureza tipográfica.

---

## Estructura del Documentación

La documentación detallada del proyecto ha sido dividida en áreas especializadas dentro del directorio `docs/` para su fácil lectura:

1. [**UI & UX Guidelines (`docs/ui_ux_guidelines.md`)**](./docs/ui_ux_guidelines.md)
   Información sobre la filosofía de interfaz (Vogue Editorial Concept), jerarquías tipográficas y el estricto Atomic Design sin ruido visual que rige a la app.

2. [**Architecture & Database (`docs/architecture_and_db.md`)**](./docs/architecture_and_db.md)
   Detalles del stack tecnológico (Flutter, Firebase, Gemini), y los esquemas estructurales de las bases de datos locales (SQLite) gestionando sesiones de colorimetría y peluquería en un entorno Offline-First.

---

## Flujo Lógico Principal

Toda la aplicación está distribuida en zonas o módulos funcionales lógicos con el siguiente esquema de comportamiento principal de cara al usuario. Todo mediante transiciones nativas limpias de Flutter:

1. **Entrada y Cuentas**: `SplashScreen` silencioso → `Onboarding` inmersivo → Validación Local de Cuentas (SQLite offline).
2. **Dashboard Pincipal**: Un hub minimalista puramente textual.
3. **Escáner & Colorimetría**: Lectura "edge-to-edge" seguida de una decodificación animada tipográfica mientras Gemini clasifica la estación del usuario.
4. **Archivo (Historial)**: Visualización estructurada de un índice temporal (fechas y titulares) guardados en caché local de previas simulaciones IA faciales.