extends Control

enum { # constantes para acceder a campos de las notas en el array
	ID,
	TYPE,
	TIMING,
	SPAWN
}

enum judg_ms{ # timing windows en ms (kinda como los de osu pero sin OD)
	MAX = 30,
	PRF = 64,
	EXC = 97,
	GOOD = 127,
	BAD = 180
}

const scores = {
	"MAX": 320,
	"Perfect": 300,
	"Excellent": 200,
	"Good": 100,
	"Bad": 50
}

var note_speed:int = 2000 # tiempo en milisegundos de note speed
var next_nota:int = 0     # contador de proxima nota a renderizar
var notas:Array
@export var nota_scene: PackedScene
var score:int = 0
var nivel_path:String = "./assets/level/first_processed.lvl"
var next_note_to_judge:int = 0

var note_queue: Array = []  # FIFO para manejar las notas activas en el nivel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# cargar nivel
	notas = load_level(nivel_path)
	
	# configuración de nivel
	$Conductor.bpm = 146
	$Conductor.measures = 4
	
	#print("nivel cargado")
	#print(notas)
	
	score = 0
	
	$Conductor.play()
	
func _process(delta: float) -> void:
	if next_nota >= notas.size():
		return # se acabó el nivelazo

	# posición de la canción en ms
	# un getter de toda la vida :)
	var song_pos_ms = $Conductor.song_position * 1000
	
	# revisar si la proxima nota está lista para ser spawneada
	if notas[next_nota][SPAWN] <= song_pos_ms:
		_spawn_note()
		next_nota += 1
	
func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("note_input_1"): # modificar cuando se agregue el segundo input
		return
	if note_queue.is_empty():
		return
	
	var song_pos_ms = $Conductor.song_position * 1000
	var closest_note = note_queue[0]
	var error = abs(song_pos_ms - closest_note[1])
	
	print(error)
	
	if error > judg_ms.BAD:
		return # no hacer nada si el input no está dentro del timing windows
	
	note_queue.pop_front()
	
	# avisarle a la nota que se destruya
	if closest_note[0].has_method("note_hit"):
		closest_note[0].note_hit()
	

func judge(error) -> String:
	if error <= judg_ms.MAX:
		return "MAX"
	elif error <= judg_ms.PRF:
		return "Perfect"
	elif error <= judg_ms.EXC:
		return "Excellent"
	elif error <= judg_ms.GOOD:
		return "Good"
	elif error <= judg_ms.BAD:
		return "Bad"
	else:
		return "Miss"

func _spawn_note() -> void:
	var nota_inst = nota_scene.instantiate()
	nota_inst.spawn_time = notas[next_nota][SPAWN]
	nota_inst.jl_radio = 100.0 # refactorizar: está repetido en judgementline
	nota_inst.conductor = $Conductor
	add_child(nota_inst)
	
	# encolar en notas activas
	var note_timing = notas[next_nota][TIMING]
	note_queue.push_back([nota_inst, note_timing]) # push back (intancia, timing)
	
	nota_inst.note_miss.connect(_on_note_miss)

func _on_note_miss() -> void:
	note_queue.pop_front() # desencolar ultima nota
	# resetear combo y toda la bola
	# la nota se elimina solita
	

func load_level(path: String) -> Array:
	"""
	Carga un nivel desde archivo .lvl y devuelve un Array con notas [id,type,timing,spawn].
	"""
	var data: Array = []
	var nivel_file: FileAccess = FileAccess.open(path, FileAccess.READ) 
	
	if nivel_file == null:
		printerr("Could not open file. Error code: ",FileAccess.get_open_error(), " Path: ", path)
		return data

	if not path.to_lower().ends_with(".lvl"):
		printerr("Formato inválido. Se esperaba un archivo .lvl: ", path)
		nivel_file.close()
		return data

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
			if row_data.size() == 3 and row_data[0] != "":
				var note_id: int = int(row_data[0])
				var note_type: int = int(row_data[1])
				var timing: int = int(row_data[2])
				var spawn: int = timing - note_speed
				var note_data: PackedInt32Array = PackedInt32Array([note_id, note_type, timing, spawn])
				data.push_back(note_data)
	nivel_file.close()
	return data
