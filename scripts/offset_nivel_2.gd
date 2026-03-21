extends Control

enum {
	ID,
	TIMING,
}
const HIT_WINDOW_MS: float = 500.0

var data: Array = []
var offsets: Array = []
var next_note_to_judge: int = 0
var finished: bool = false

func _ready() -> void:
	data = load_level("res://assets/level/offset.lvl")

	$CenterContainer2/Text.text = (
		"Press " + GlobalScripts.Hit_tecla.to_upper() + " or " + GlobalScripts.Hit_tecla2.to_upper()
		+ " to the beat"
	)

	$Conductor.bpm = 80
	$Conductor.sec_per_beat = 60.0 / 80.0
	$Conductor.measures = 4

	$Conductor._load_stream("res://assets/music/offset.mp3")
	$Conductor.play()

func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	# sale independientemente de si terminó la calibración
	if (event.is_action_pressed("backspace") or event.is_action_pressed("back")):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		return

	if not (event.is_action_pressed("note_input_1") or event.is_action_pressed("note_input_2")):
		return
	
	if finished or next_note_to_judge >= data.size():
		return

	var song_pos_ms:float = _get_song_pos_ms()

	# saltar automáticamente notas ya perdidas
	while next_note_to_judge < data.size():
		var overdue_error: float = song_pos_ms - data[next_note_to_judge][TIMING]
		if overdue_error > HIT_WINDOW_MS:
			next_note_to_judge += 1
			continue
		break

	if next_note_to_judge >= data.size():
		return

	var note_timing: float = data[next_note_to_judge][TIMING]
	var error: float = song_pos_ms - note_timing

	# ignorar inputs fuera del timing window
	if abs(error) > HIT_WINDOW_MS:
		return

	# feedback solo para hits válidos.
	$PlanetaOffset.beat()

	offsets.append(error)
	next_note_to_judge += 1

	$CenterContainer/Label.text = str(snapped(offset_calibrate(), 0.1)) + " ms"

func _on_conductor_beat(_position: Variant) -> void:
	pass

func _on_conductor_finished() -> void:
	finished = true
	$CenterContainer2/Text.show()
	
	# calcular offset y aplicarlo al offset global
	if not offsets.is_empty():
		GlobalScripts.global_offset = roundi(offset_calibrate())
		$CenterContainer2/Text.text = (
			"Offset: " + str(GlobalScripts.global_offset) + " ms saved" + "\nPress X or Backspace to leave"
		)
	else:
		$CenterContainer2/Text.text = "No hits recorded.\nPress X or Backspace to leave"

func offset_calibrate() -> float:
	if offsets.is_empty():
		return 0.0

	# Media recortada para reducir impacto de outliers humanos.
	var sorted_offsets: Array = offsets.duplicate()
	sorted_offsets.sort()

	if sorted_offsets.size() < 5:
		return _mean(sorted_offsets)

	var trim_count: int = int(floor(sorted_offsets.size() * 0.2))
	var start_idx: int = trim_count
	var end_idx: int = sorted_offsets.size() - trim_count

	if end_idx <= start_idx:
		return _mean(sorted_offsets)

	var sum: float = 0.0
	for i in range(start_idx, end_idx):
		sum += sorted_offsets[i]
	return sum / float(end_idx - start_idx)

func _mean(values: Array) -> float:
	if values.is_empty():
		return 0.0

	var sum: float = 0.0
	for v in values:
		sum += v
	return sum / float(values.size())

func _get_song_pos_ms() -> float:
	if $Conductor.has_method("get_song_position_seconds"):
		return $Conductor.get_song_position_seconds() * 1000.0
	return $Conductor.song_position * 1000.0

func load_level(path: String) -> Array:
	var result: Array = []
	var nivel_file: FileAccess = FileAccess.open(path, FileAccess.READ)

	if nivel_file == null:
		printerr("Could not open file. Error code: ", FileAccess.get_open_error(), " Path: ", path)
		return result

	if not path.to_lower().ends_with(".lvl"):
		printerr("Formato inválido. Se esperaba un archivo .lvl: ", path)
		nivel_file.close()
		return result

	var in_notes: bool = false

	while not nivel_file.eof_reached():
		var raw_line: String = nivel_file.get_line()
		var line: String = raw_line.strip_edges()

		if line == "#NOTES":
			in_notes = true
			continue

		if line == "#ENDNOTES":
			break

		if in_notes and line != "":
			var row_data: PackedStringArray = line.split(",", false)
			# formato del .lvl del calibrador: id,type,timing_ms
			if row_data.size() >= 3 and row_data[0] != "":
				var note_id: int = int(row_data[0])
				# NO aplicamos global_offset: el calibrador mide desde cero
				var timing: int = int(row_data[2])
				result.push_back(PackedInt32Array([note_id, timing]))

	nivel_file.close()
	return result
