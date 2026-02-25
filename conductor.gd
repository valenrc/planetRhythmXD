extends AudioStreamPlayer

# Variables globales (Ajustada para cada nivel)
@export var bpm = 100
@export var measures = 4  # compases de la canción

# Variables internas
var song_position:float = 0.0	# tiempo desde el inicio de la canción (en segundos)
var song_position_in_beats:int = 1 # cantidad de beats desde el inicio de la canción (relativo a los bpm)
var sec_per_beat:float = 60.0 / bpm	# cantidad de segundos entre cada beat en la canción
var last_reported_beat:int = 0	# último beat detectado
var beats_before_start:int = 0	# cantidad de beats para simular antes de que empiece la canción
var current_measure:int = 0	 # compás actual

# Determining how close to the beat an event is
var closest = 0.0
var time_off_beat = 0.0

# Señales para sincronizar el juego
signal beat(position)
signal measure(position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing:
		# https://docs.godotengine.org/en/stable/tutorials/audio/sync_with_audio.html
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		
		# convierto el timing actual a la cantidad de beats ocurridos desde el inicio de la canción
		#song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		#_report_beat()
		
func _report_beat():
	if song_position_in_beats > last_reported_beat:
		if current_measure > measures:
			current_measure = 1
		
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", current_measure)

		last_reported_beat = song_position_in_beats
		current_measure += 1

		#print("time: ",song_position, " time in beats: ", song_position_in_beats)
