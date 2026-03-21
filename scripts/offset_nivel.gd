extends Control

const bpm:float = 80.0
var beat_interval_ms: float
var offsets: Array   = []        # errores acumulados (signed float)
var finished:bool = false

var beats = 0

func _ready() -> void:
	$CenterContainer2/Text.show()
	$CenterContainer2/Text.text = "Press " + (GlobalScripts.Hit_tecla).to_upper() + " or " + (GlobalScripts.Hit_tecla2).to_upper() + " to the beat"
	
	beat_interval_ms = 60.0 / bpm * 1000.0
	
	$Conductor.bpm = int(bpm)
	$Conductor.sec_per_beat = 60.0 / 80.0
	$Conductor.measures = 4
	
	$Conductor._load_stream("res://assets/music/offset.mp3")
	$Conductor.play()

func _process(delta: float) -> void:
	pass

func _on_conductor_beat(position: Variant) -> void:
	beats += 1
	#print("bpm calculado: ", int(round(beats/($Conductor.song_position / 60 ))))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("note_input_1") or event.is_action_pressed("note_input_2"):
		if finished:
			return
			
		$CenterContainer2/Text.hide()
		$PlanetaOffset.beat()
		
		var song_pos_ms = $Conductor.song_position * 1000.0
		var next_beat_ms = round(song_pos_ms / beat_interval_ms) * beat_interval_ms
		var error = song_pos_ms - next_beat_ms
		#print(error)
		
		if abs(error) > 500.0:
			return
		
		offsets.append(error)
		var promedio = offset_calibrate()
		#print(promedio)
		$CenterContainer/Label.text = str(snapped(promedio, 0.1)) + " ms"
	if event.is_action_pressed("backspace") and not finished:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	if event.is_action_pressed("back") and finished:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func offset_calibrate():
	var sum = 0.0
	for offset in offsets:
		sum += offset
		
	return sum / offsets.size()

func _on_conductor_finished() -> void:
	# acabar con todo
	finished = true
	$CenterContainer2/Text.show()
	$CenterContainer2/Text.text = "Offset saved \n Press X to leave"
	if not offsets.is_empty():
		GlobalScripts.global_offset = offset_calibrate() 
	
