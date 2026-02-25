extends Node2D
# no lo notas?
# no lo notas?!
# ... eres un notas!

# ESTO DEBERIA SER UNA VARIABLE GLOBAL
var note_speed:float = 1000 # tiempo en ms que tarda en ir del centro al judgement line (radio 0 ->  judgementline.radio)

# Variables a instanciar por el nivel que crea la nota
var spawn_time:float # spawning time de la nota en ms
var jl_radio:float # radio de la judgement line en la escena del nivel (default: 100)
var conductor: AudioStreamPlayer

# variables locales a la instancia
var active:bool
var radio:float = 0
var center:Vector2
var del_delta:float = 0.2	 # delta para eliminar la nota despues de que haya pasado la judgement line

#var note_progress:float # progeso en ms de la nota; desde que spawnea hasta el progreso actual de la canción

func _ready() -> void:
	center = get_viewport_rect().get_center()
	active = true

func _process(delta: float) -> void:
	if conductor == null:
		printerr("[conductor we have a problem] 'error al instanciar el conductor'")
		return
	if not active:
		return
	
	var song_position_ms = conductor.song_position * 1000 # timing actual de la canción en ms
	var note_progress = (song_position_ms - spawn_time) / note_speed
	
	radio = note_progress * jl_radio
	
	queue_redraw() # re-renderizar
	
	if note_progress > 1.0 + del_delta:
		print("nukeo nota. progress: ", note_progress, " 1.0 + delta: ", 1.0 + del_delta)
		queue_free() # nukea este nodo
	
func _draw() -> void:
	# https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html
	if radio > 0:
		draw_arc(center, radio, 0, 2*PI, 64, Color.GOLD, 0.8, true)
