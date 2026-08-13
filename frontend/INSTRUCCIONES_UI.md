# Parametrización de Interfaz de Usuario (UI) - Kiosco Turnero

Este documento establece las directrices para la modificación de recursos visuales dentro del proyecto del Kiosco.

## Especificaciones del Logo Corporativo

Para garantizar que el logo de la institución se renderice correctamente en las pantallas del Kiosco sin sufrir deformaciones ni pixelado, se deben cumplir los siguientes parámetros:

*   **Nombre del archivo:** `logo.png` (Debe ubicarse en la raíz del directorio `frontend/`).
*   **Formato exigido:** PNG con fondo transparente (Transparencia Alpha). Evitar fondos blancos sólidos que contrasten con el fondo de la aplicación.
*   **Dimensiones recomendadas:**
    *   **Alto (Height):** 120px a 150px (El CSS del sistema lo escalará dinámicamente a un máximo de 60px visuales para mantener soporte Retina/Alta Definición).
    *   **Ancho (Width):** 300px a 500px máximo.
*   **Espacio de Color:** RGB.

*Nota: Cualquier actualización del archivo `logo.png` se reflejará automáticamente en la interfaz gracias al mapeo de volúmenes locales de la infraestructura.*
