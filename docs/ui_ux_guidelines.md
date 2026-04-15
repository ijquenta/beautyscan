# UI & UX Guidelines: "Vogue Editorial Concept"

La directriz fundamental de **BeautyScan** es rechazar de tajo el estándar visual de las "aplicaciones móviles convencionales" (Material Design genérico, botones gruesos flotantes, exceso de íconos, sombras difusas múltiples y cajas de contención). En su lugar, el sistema de diseño adopta un formato de _Revista de Alta Costura_ (Editorial, Estricto y Tipográfico).

## 1. El Silencio Visual (Espacio Negativo)
El lienzo (background) en BeautyScan es sagrado. Toda la interfaz se enmarca en fondos blancos o translúcidos absolutos de alto contraste. No se emplean los "Glassmorphism Containers" (cajas de cristal desenfocadas) para separar secciones. La separación se logra mediante el espacio, el margen y las líneas de cuadrícula extremadamente finas (1px black12).

## 2. Guerra a los Iconos Universales
Cualquier acción en el sistema debe preferir expresarse a través de **tipografía firme** en lugar de usar librerías de íconos como Material Icons o FontAwesome.
- Si un botón sirve para guardar: `GUARDAR` en mayúsculas `Inter`.
- Si se necesita retroceder: Un pequeño texto `VOLVER` arrinconado en la esquina superior izquierda. 
- Únicamente se permiten íconos si son representaciones abstractas de navegación estricta (ej. una flecha delgada de 1px `chevron_right`).

## 3. Jerarquía y Tipografía
Toda la aplicación reposa sobre el contraste y uso de dos familias tipográficas:
- **`PlayfairDisplay`**: Usada exclusivamente para grandes titulares, métricas dominantes, nombres de resultados y presentaciones de alto impacto. Transmite elegancia, moda y clasicismo.
- **`Inter`**: Usada en texto técnico, descripciones métricas, botones funcionales espaciados (`letterSpacing: 2.0` o `3.0`) en todas mayúsculas, entregando precisión suiza para contrarrestar la ornamentación del Playfair.

## 4. Fotografía Inmersiva (Edge-to-Edge)
Las fotografías del usuario y los resultados de simulación de cabello no van en pequeños avatares encerrados en círculos con bordes gruesos. Las fotos protagonizan cada visual.
* **Escáner**: Usa la cámara al 100% de la pantalla sin franjas negras obstructivas superiores o inferiores.
* **Resultados**: Las fotos simulan un carrete cuadrado o extendido, usando fondos negros sólidos de contraste donde la imagen destaca en aislamiento absoluto. Las paletas de colores que la acompañan no son circunferencias, sino "swatches" cuadrados limpios.

## 5. Menos es Más (Ej: Settings)
La experiencia de usuario prioriza no saturar cognitivamente a quien la usa. Los perfiles y pantallas de configuración fueron rigurosamente podados. Los sliders, switches de notificaciones e interfaces de configuración verbosas fueron eliminadas a favor de únicamente mostrar lo indispensable para operar la cuenta, haciendo la app sumamente exclusiva en sus funciones expuestas.
