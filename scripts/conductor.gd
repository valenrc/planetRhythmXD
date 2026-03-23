extends AudioStreamPlayer

# Variables globales (Ajustada para cada nivel)
var bpm:int
var measures = 4  # compases de la canción

# Variables internas
var song_position:float = 0.0	# tiempo desde el inicio de la canción (en segundos)
var song_position_in_beats:int = 1 # cantidad de beats desde el inicio de la canción (relativo a los bpm)
var sec_per_beat	# cantidad de segundos entre cada beat en la canción
var last_reported_beat:int = 0	# último beat detectado
var beats_before_start:int = 0	# cantidad de beats para simular antes de que empiece la canción
var current_measure:int = 0	 # compás actual

# Señales para sincronizar el juego
signal beat(position)
signal measure(position)

var song: AudioStream # cancion eyeyey

func _ready() -> void:
	#sec_per_beat = 60.0 / float(bpm)
	pass

func _process(_delta: float) -> void:
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		
		# convierto el timing actual a la cantidad de beats ocurridos desde el inicio de la canción
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		
		# detecto si la canción loopeo (para musica de menu)
		if song_position_in_beats < last_reported_beat:
			last_reported_beat = 0
			current_measure = 0
		
		_report_beat()
		
func _report_beat():
	if song_position_in_beats > last_reported_beat:
		if current_measure > measures:
			current_measure = 1
		
		emit_signal("beat", song_position_in_beats)
		emit_signal("measure", current_measure)

		last_reported_beat = song_position_in_beats
		current_measure += 1

		#print("time: ",song_position, " time in beats: ", song_position_in_beats)
		
func _load_stream(path:String):
	"""
	El archivo mp3 de la canción debe tener el mismo nombre que el .lvl
	"""
	song = load(path)
	stream = song
