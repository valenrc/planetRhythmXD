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
- title
- bpm: beats por minuto (el nivel no puede tener bpm dinámico)

#### Sección de #NOTES
cada linea representa una nota a ser renderizada por el juego.

hay tres tipos de notas:

**type 1**: nota amarilla - [id,1,timing]

**type 2**: nota magenta - [id,2,timing]

**type 3**: diálogo - [id,3,d_id,timing]

Donde:
- `id`: id de la nota. (legacy, no se usa internamente)
- `type`: tipo de nota (1: Yellow; 2:Magenta; 3:Dialogue)
- `timing`: tiempo en milisegundos desde el inicio de la canción en el que la nota debe pasar por la judgement line.
- `d_id`: id interno del texto del dialogo dentro del nivel.

#### `convert_timing_lvl` script
Convierte un archivo .lvl con formato de timing "mm:ss:ms" a formato de timing "ms". 
Uso: `python convert_timing_lvl.py <input_file.lvl> <output_file.lvl>`
