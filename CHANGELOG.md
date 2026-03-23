# Changelog - Features post-submission

Este archivo documenta todas las features y cambios agregados después del **commit para submit definitivo** (2026-03-09).

---

## [2026-03-23] Contenido, Audio y Versión 0.0.2m

### 6026b99 - version 0.0.2m
- **Autor:** valenrc
- **Descripción:** Release de versión 0.0.2m con todas las mejoras acumuladas.

### a2d5f20 - alien pixelado
- **Autor:** valenrc
- **Descripción:** Nuevo sprite de alien en estilo pixel art.

### c23d2f0 - alien 100% real + endscreen fix (parcial)
- **Autor:** Batuel3
- **Descripción:**
  - Nuevo asset de alien
  - Fix parcial de la pantalla de resultados (endscreen)

### 8e5af7b - musica de endscreen
- **Autor:** valenrc
- **Descripción:** Música dedicada para la pantalla de resultados.

### d487816 - eliminar assets no usados
- **Autor:** valenrc
- **Descripción:** Limpieza del proyecto eliminando assets que ya no se utilizaban.

### fb736cd - update README.md
- **Autor:** valenrc
- **Descripción:** Actualización de la documentación del proyecto.

### 80a9297 - update README.md
- **Autor:** valenrc
- **Descripción:** Actualización de la documentación del proyecto.

---

## [2026-03-22] Rework de Menú e Identidad Visual

### 9b89430 - delete font imports
- **Autor:** valenrc
- **Descripción:** Limpieza de imports de fuentes no utilizadas.

### 09ca522 - menu rework + logo
- **Autor:** valenrc
- **Descripción:**
  - Rediseño completo del menú principal
  - Integración del logo del juego

### bc4cf38 - icono
- **Autor:** valenrc
- **Descripción:** Nuevo ícono de aplicación para el juego.

---

## [2026-03-21] Reestructuración y Bugfixes

### ed87862 - arreglar crash de conductor por bpm en Nivel.gd
- **Autor:** valenrc
- **Descripción:** Fix de crash causado por el sistema de BPM del conductor en la escena de Nivel.

### 75a3780 - remove audioStream path
- **Autor:** valenrc
- **Descripción:** Eliminación de paths hardcodeados de AudioStream para mejor portabilidad.

### bcab644 - reestructuración
- **Autor:** valenrc
- **Descripción:** Reestructuración general del proyecto y organización de archivos.

### 9ed71b0 - Update README.md
- **Autor:** valenrc
- **Descripción:** Actualización de la documentación del proyecto.

### 036012d - update globalscripts path
- **Autor:** valenrc
- **Descripción:** Actualización de las rutas de scripts globales tras la reestructuración.

---

## [2026-03-20] Optimización de exportación y configuración

### 577ef5e - exclude filters + thread pool sizes y config de texture compression
- **Autor:** valenrc
- **Descripción:** Configuración de filtros de exclusión, tamaños de thread pool y compresión de texturas para optimizar el build del juego.

### 4b2b1a0 - audio configuration settings y texture compression
- **Autor:** valenrc
- **Descripción:** Ajustes de configuración de audio y compresión de texturas para mejorar rendimiento y calidad.

### 39de045 - animacion de endscreen + offset calibration + bugfixs
- **Autor:** valenrc
- **Descripción:** 
  - Nueva animación para la pantalla de fin de nivel (endscreen)
  - Sistema de calibración de offset de audio
  - Corrección de varios bugs

---

## [2026-03-17] Sistema de Offset y Ajustes

### 9171336 - fix de offset
- **Autor:** Batuel3
- **Descripción:** Corrección de problemas con el sistema de offset de audio.

### 396dcfa - v.0.0.2
- **Autor:** Batuel3
- **Descripción:** Release de versión 0.0.2 con los fixes de offset.

### 75eff17 - agregar offset y cambiar el tween del planeta
- **Autor:** valenrc
- **Descripción:** 
  - Implementación del sistema de offset configurable
  - Mejora de la animación tween del planeta para mejor feedback visual

---

## [2026-03-16] Offset Global

### 4fb60db - offset global
- **Autor:** valenrc
- **Descripción:** Implementación del sistema de offset global para compensación de latencia de audio/video.

---

## [2026-03-13] Fixes Post-Submission

### dd0621d - fixes de post-submission
- **Autor:** valenrc
- **Descripción:** Correcciones generales detectadas después de la primera submission del juego.

---

## Resumen de Features Agregadas

| Feature | Commit | Fecha |
|---------|--------|-------|
| Versión 0.0.2m | 6026b99 | 2026-03-23 |
| Alien pixelado | a2d5f20 | 2026-03-23 |
| Alien + endscreen fix parcial | c23d2f0 | 2026-03-23 |
| Música de endscreen | 8e5af7b | 2026-03-23 |
| Limpieza de assets no usados | d487816 | 2026-03-23 |
| Rework de menú + logo | 09ca522 | 2026-03-22 |
| Ícono de aplicación | bc4cf38 | 2026-03-22 |
| Fix crash de conductor por BPM | ed87862 | 2026-03-21 |
| Reestructuración del proyecto | bcab644 | 2026-03-21 |
| Update globalscripts path | 036012d | 2026-03-21 |
| Animación de endscreen | 39de045 | 2026-03-20 |
| Calibración de offset | 39de045 | 2026-03-20 |
| Configuración de audio | 4b2b1a0 | 2026-03-20 |
| Compresión de texturas | 4b2b1a0, 577ef5e | 2026-03-20 |
| Optimización de build (filtros, thread pools) | 577ef5e | 2026-03-20 |
| Sistema de offset global | 4fb60db | 2026-03-16 |
| Offset configurable + tween de planeta | 75eff17 | 2026-03-17 |
| Fixes de offset | 9171336 | 2026-03-17 |
| Fixes post-submission | dd0621d | 2026-03-13 |

---

*Generado automáticamente desde los commits del repositorio GitHub: valenrc/dc-uba-jam*
