extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# configuración de nivel
	$Conductor.bpm = 100
	$Conductor.measures = 4
	
	# cargar nivel
	var notas:Array = load_level("./assets/level/first_processed.lvl")
	print("nivel cargado")
	
	print(notas)
	
	$Conductor.play()
	
func _process(delta: float) -> void:
	pass
	
func load_level(path: String) -> Array:
	"""
	Carga un nivel desde archivo .lvl y devuelve un Array con notas [id,type,timing].
	Toma solo líneas entre #NOTES y #ENDNOTES.
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
				data.push_back(row_data)
	nivel_file.close()
	return data
		
