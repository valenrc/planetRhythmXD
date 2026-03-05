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
var score:int
var combo:int
var nivel_path:String = "./assets/level/second_processed.lvl"
var next_note_to_judge:int = 0

var note_queue1: Array = []  # FIFO para manejar las notas activas en el nivel
var note_queue2: Array = []

func _ready() -> void:
	# cargar nivel
	notas = load_level(nivel_path)
	
	# configuración de nivel
	$Conductor.bpm = 146
	$Conductor.measures = 4
	
	#print("nivel cargado")
	#print(notas)
	
	score = 0
	combo = 0
	
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
	var queue: Array
	if event.is_action_pressed("note_input_1"):
		queue = note_queue1
	elif event.is_action_pressed("note_input_2"):
		queue = note_queue2
	else:
		return
	
	if queue.is_empty():
		return
	
	var song_pos_ms = $Conductor.song_position * 1000
	var closest_note = queue[0]
	var error = abs(song_pos_ms - closest_note[1])
	
	#print("timing: ", closest_note[1], " error: ", error)
	
	if error > judg_ms.BAD:
		#print("ignored")
		return # no hacer nada si el input no está dentro del timing windows
	
	combo += 1
	print(judge(error))
	print("score: ",score)
	print("combo: ", combo)
	queue.pop_front()
	
	# avisarle a la nota que se destruya
	if closest_note[0].has_method("note_hit"):
		closest_note[0].note_hit()
	

func judge(error) -> String:
	if error <= judg_ms.MAX:
		score += scores["MAX"]
		return "MAX"
	elif error <= judg_ms.PRF:
		score += scores["Perfect"]
		return "Perfect"
	elif error <= judg_ms.EXC:
		score += scores["Excellent"]
		return "Excellent"
	elif error <= judg_ms.GOOD:
		score += scores["Good"]
		return "Good"
	elif error <= judg_ms.BAD:
		score += scores["Good"]
		return "Bad"
	else:
		# jamas va a entrar acá
		return "Miss"

func _spawn_note() -> void:
	var nota_inst = nota_scene.instantiate()
	
	var note_type = notas[next_nota][TYPE]
	
	nota_inst.spawn_time = notas[next_nota][SPAWN]
	nota_inst.jl_radio = 100.0 # refactorizar: está repetido en judgementline
	nota_inst.conductor = $Conductor
	if note_type == 1:
		nota_inst.color = Color.GOLD
	elif note_type == 2:
		nota_inst.color = Color.MAGENTA
	else:
		# nunca debería llegar acá si el nivel está bien creado
		nota_inst.queue_free()
		return

	add_child(nota_inst)
	
	# encolar en notas activas
	var note_timing = notas[next_nota][TIMING]
	 # push back (intancia, timing)
	if note_type == 1:
		note_queue1.push_back([nota_inst, note_timing])
		nota_inst.note_miss.connect(_on_note_miss_type1)
	elif note_type == 2:
		note_queue2.push_back([nota_inst, note_timing])
		nota_inst.note_miss.connect(_on_note_miss_type2)
	else: return

func _on_note_miss_type1() -> void:
	if not note_queue1.is_empty():
		miss_handle()
		note_queue1.pop_front() # desencolar ultima nota
	# resetear combo y toda la bola
	# la nota se elimina solita

func _on_note_miss_type2() -> void:
	if not note_queue2.is_empty():
		miss_handle()
		note_queue2.pop_front()

func miss_handle() -> void:
	combo = 0
	print("MISS!")

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
