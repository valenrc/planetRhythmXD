extends Control

var clock : float # tiempo de nivel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# cargar nivel
	var notas:Array = leer_nivel_csv("./assets/level/first.csv")
	print("nivel cargado")
	
	print(notas[0])
	print(notas[1])
	print(notas[2])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func leer_nivel_csv(path: String) -> Array:
	var data: Array = []
	var nivel_file: FileAccess = FileAccess.open(path, FileAccess.READ) 
	
	if nivel_file == null:
		printerr("Could not open file. Error code: ",FileAccess.get_open_error(), " Path: ", path)
		return data
	
	# descartar la primer fila
	nivel_file.get_line()
	
	# meter todo en un array
	while not nivel_file.eof_reached():
		# get_csv_line() returns a PackedStringArray of values for the current row
		var row_data : PackedStringArray = nivel_file.get_csv_line()
		if not row_data.is_empty() and row_data[0] != "": 
			data.push_back(row_data) # meter la linea actual a data
	nivel_file.close()
	return data
		
