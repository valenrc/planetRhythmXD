![Logo](assets/img/PRXDlogov2.png)

Juego de ritmo 2k de tématica espacial y notas circulares.

>Sos un planeta enano resistiendo por mantenerse en su sistema. Luchá contra el olvido al ritmo de la música"

Desarrollado para la DCUBA-JAM 2026.

## ASSETS

### Imágenes (`assets/img/`)
- `Cubawikilogo_pixelated.png`: [Jugoprex (Cubawiki)]
- `FallingStar_Sprites.png`: [https://pixel-salvaje.itch.io/]
- `pixelart_starfield.png` / `pixelart_starfield_corona.png`: [https://space-spheremaps.itch.io/pixelart-starfields]
- `Planet_Pack_bycancer`: [https://andelrodis.itch.io/solar-system-pack]

### Música y Sonidos (`assets/music/`)
- `flow.ogg`: ["Flow" by Creo]
- `menu.ogg` / `menuv2.ogg`: [Awake! (Megawall-10) - cynicmusic (opengameart.org)]
- `space_hardstyle.ogg`: [dax1n - space hardstyle]
- `spaced_out.ogg`: [Spaced Out - Ready Go Music]
- `endscreen.ogg`: [Space Sprinkles - Matthew Pablo]
- `galaxy.ogg`: [UK GARAGE x JERSEY CLUB TYPE BEAT - "GALAXY"
 - JVD]
- `drum-hitnormalh.wav`: [osu!resources]
- `heartbeat.wav`: [osu!resources]

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
