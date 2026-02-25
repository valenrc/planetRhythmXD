## ASSETS
Planet_Pack_bycancer by Batuhan https://andelrodis.itch.io/solar-system-pack

## Documentación
### .lvl file format
```
#METADATA
title:<title>
bpm:<bpm>
#ENDMETADATA
#NOTES
<notas>
#ENDNOTES
```
#### Sección de #METADATA
(puede tener mas campos)
- title: nombre del nivel

- bpm: beats por minuto en específico (el nivel no puede tener bpm dinámico)

#### Sección de #NOTES
cada linea representa una nota a ser renderizada por el juego.

formato: `id,type,timing`
- id (int): id de la nota
- type (int): tipo de nota (1: Sun)
- timing (int): tiempo en milisegundos desde el inicio de la canción en el que la nota debe pasar por la judgement line  

#### `convert_timing_lvl` script
Convierte un archivo .lvl con formato de timing "mm:ss:ms" a formato de timing "ms". 
Uso: `python convert_timing_lvl.py <input_file.lvl> <output_file.lvl>`
