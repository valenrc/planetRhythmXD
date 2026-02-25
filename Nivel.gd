extends Control

const ID 	= 0
const TYPE 	= 1
const TIMING = 2
const SPAWN	= 3

var note_speed:int = 1000 # tiempo en milisegundos de note speed
var next_nota:int = 0 # contador de proxima nota a renderizar

var notas:Array

@export var nota_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# configuración de nivel
	$Conductor.bpm = 160
	$Conductor.measures = 4
	
	# cargar nivel
	notas = load_level("./assets/level/first_processed.lvl")
	
	print("nivel cargado")
	print(notas)
	
	$Conductor.play()
	
func _process(delta: float) -> void:
	if next_nota >= notas.size():
		return # se acabó el nivelazo

	# posición de la canción en ms
	var song_pos_ms = $Conductor.song_position * 1000
	
	# revisar si la proxima nota está lista para ser spawneada
	if notas[next_nota][SPAWN] <= song_pos_ms:
		print("spawneo nota. spawn: ", notas[next_nota][SPAWN], " at song ms: ", song_pos_ms)
		_spawn_note()
		next_nota += 1

func _spawn_note() -> void:
	var nota_inst = nota_scene.instantiate()
	nota_inst.spawn_time = notas[next_nota][SPAWN]
	nota_inst.jl_radio = 100.0 # refactorizar: está repetido en judgementline
	nota_inst.conductor = $Conductor
	
	add_child(nota_inst)

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
		
