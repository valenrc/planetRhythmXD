extends Node2D
# no lo notas?
# no lo notas?!
# ... eres un notas!

# ESTO DEBERIA SER UNA VARIABLE GLOBAL
var note_speed:float = 2000 # tiempo en ms que tarda en ir del centro al judgement line (radio 0 ->  judgementline.radio)

# Variables a instanciar por el nivel que crea la nota
var spawn_time:float # spawning time de la nota en ms
var jl_radio:float # radio de la judgement line en la escena del nivel (default: 100)
var conductor: AudioStreamPlayer
var color:Color

# variables locales a la instancia
var active:bool
var radio:float = 0
var center:Vector2
var del_delta:float = 0.2	 # delta para eliminar la nota despues de que haya pasado la judgement line

# timing para eliminar la nota del arbol de nodos
var miss_judgement_ms = 400
var late_window_normalized: float = miss_judgement_ms / note_speed
signal note_miss()

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
	
	#if note_progress > 1.0 + del_delta:
	#if abs(1.0 - note_progress) < tolerance:
	if note_progress > 1.0 + late_window_normalized:
		#print("note nuked - song_pos_ms = ", song_position_ms, " timing = ", spawn_time + note_speed, " progress = ", note_progress)
		note_miss.emit() # esto debe llegar al nivel para resetear el combo
		queue_free()
	
func _draw() -> void:
	# https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html
	if radio > 0:
		draw_arc(center, radio, 0, 2*PI, 64, color, 0.8, true)
		
func note_hit() -> void:
	queue_free()
	return
