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
	BAD = 200
}
var n_scores = {	# cantidad de hits por juicio
	"MAX" = 0,
	"Perfect" = 0,
	"Excellent" = 0,
	"Good" = 0,
	"Bad" = 0
}

##### variables para calcular score
# Score = BaseScore + BonusScore (score para cada nota)
var score_const:float # (MaxScore * 0.5 / TotalNotes) 
# BaseScore  = score_const * (NoteScore / 320)
# BonusScore = score_const * (HitBonusValue * Sqrt(Bonus) / 320)
# Bonus = Bonus before this hit + HitBonus - HitPunishment
var bonus = 100 # limitado a [0,100]
const max_score = 100000
var total_notes
const scores = {
	"MAX": 320,
	"Perfect": 300,
	"Excellent": 200,
	"Good": 100,
	"Bad": 50,
	"Miss": 0
}
const hit_bonus_values = {
	"MAX": 32,
	"Perfect": 32,
	"Excellent": 16,
	"Good": 8,
	"Bad": 4,
	"Miss": 0
}
const hit_bonus = {
	"MAX": 2,
	"Perfect": 1,
	"Excellent": -8,
	"Good": -24,
	"Bad": -44,
	"Miss": -INF
}

#### HP
var hp:int
const hp_values = {
	"MAX": 15,
	"Perfect": 10,
	"Excellent": 5,
	"Good": 1,
	"Bad": 0,
	"Miss":-20 
}

#####
var note_speed:int = GlobalScripts.scroll_speed # tiempo en milisegundos de note speed
var next_nota:int = 0     # contador de proxima nota a renderizar
var notas:Array
var animacion := false
@export var nota_scene: PackedScene
#var score:int
@export var particulas_scene: PackedScene
@export var particulas_hit_scene: PackedScene
var score:float
var combo:float
var accuracy:float
var nmisses:int
var rotate := false
var nivel_path:String
var song_path: String
var next_note_to_judge:int = 0

var note_queue1: Array = []  # FIFO para manejar las notas activas en el nivel
var note_queue2: Array = []

#### Dialogos del tutorial
var tutorial_dialogo:Array = ["",""]

func _ready() -> void:
	tutorial_dialogo[0] = "Press " + GlobalScripts.Hit_tecla.to_upper() + " for yellow note."
	tutorial_dialogo[1] = "Press " + GlobalScripts.Hit_tecla2.to_upper() + " for purple note."
	
	nivel_path = "res://assets/level/" + GlobalScripts.nivel + ".lvl"
	song_path = "res://assets/music/" + GlobalScripts.nivel + ".mp3"
	$Sol.position = get_viewport_rect().size / 2
	# cargar nivel 
	notas = load_level(nivel_path)
	
	total_notes = notas.size()
	score_const = max_score * 0.5 / total_notes
	hp = 100 # hp inicial
	
	# configuración de nivel
	$Conductor.bpm = 146
	$Conductor.measures = 4
	
	$Conductor._load_stream(song_path)
	
	score = 0.0
	combo = 0.0
	nmisses = 0
	
	$Conductor.play()
	
func _process(delta: float) -> void:
	$Sol.rotate(0.003)
	$CenterContainer.position = get_viewport_rect().size / 2
	
	if rotate == true:
		$Planeta/Sprite2D.rotate(0.005)
	
	if next_nota >= total_notes:
		return # se acabó el nivelazo

	# posición de la canción en ms
	# un getter de toda la vida :)
	var song_pos_ms = $Conductor.song_position * 1000
	
	# revisar si la proxima nota está lista para ser spawneada
	if notas[next_nota][SPAWN] <= song_pos_ms:
		_spawn_note()
		next_nota += 1
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property($Sol, "scale", Vector2(0.2, 0.2), 0.3)
		tween.tween_property($Sol, "scale", Vector2(0.18, 0.18), 0.25)
	
func _unhandled_input(event: InputEvent) -> void:
	var queue: Array
	if event.is_action_pressed("note_input_1"):
		$bass.play()
		queue = note_queue1
	elif event.is_action_pressed("note_input_2"):
		$kick.play()
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
	$CenterContainer.position = get_viewport_rect().size / 2
	animacion_combo()
	var juicio = judge(error)
	update_measurements(juicio)
	update_accuracy()
	update_hp(juicio)
	
	################ PRINT PARA DEBUG
	#print(juicio)
	#print("score: ",int(score))
	#print("combo: ", combo)
	#print("accuracy: ",accuracy*100)
	#print("hp: ", hp)
	
	queue.pop_front()
	
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
		# jamas va a entrar acá
		return "Miss"

func update_measurements(judgement:String) -> void:
	if judgement in scores.keys():
		particulas_hit()
		animacion_judge(judgement)
		animacion_judgement()
		update_score(judgement)
		n_scores[judgement] += 1
		animacion_label($score)

func update_score(judgement:String) -> void:
	score += score_const * (scores[judgement] / 320.0) # base score
	bonus = clampf(bonus + hit_bonus[judgement], 0.0, 100.0)
	score += score_const * (hit_bonus_values[judgement] * sqrt(bonus) / 320.0) # + bonus score

func update_accuracy() -> void:
	# https://osu.ppy.sh/wiki/en/Gameplay/Accuracy#osu%21mania
	var nmax = n_scores["MAX"]
	var n300 = n_scores["Perfect"]
	var n200 = n_scores["Excellent"]
	var n100 = n_scores["Good"]
	var n50 = n_scores["Bad"]
	
	accuracy = (300.0*(nmax + n300) + 200.0*n200 + 100.0*n100 + 50.0*n50) / (300.0*(nmax + n300 + n200 + n100 + n50 + nmisses))
	$accuracy.text = str(snapped(accuracy * 100, 0.01))
	
func update_hp(judgement:String) -> void:
	hp = clamp(hp + hp_values[judgement], 0, 100)
	
	if hp == 0: on_level_failed()
		
func on_level_failed() ->void:
	# reventar todo y poner un menu para reiniciar o ir al menu prinicipal
	# probablemente haya que usar una señal o algo asi para matar a todos los hijos
	$Conductor.stop()
	animacion_muerte()
	$pausa_handle.muerte = true
	#print("TERMINAR NIVEL")
	
func _spawn_note() -> void:
	var nota_inst = nota_scene.instantiate()
	
	var note_type = notas[next_nota][TYPE]
	
	if note_type == 3:
		var id = notas[next_nota][2]
		tutorial_printer(tutorial_dialogo[id])
		return
	
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

func _on_note_miss_type2() -> void:
	if not note_queue2.is_empty():
		miss_handle()
		note_queue2.pop_front()

func miss_handle() -> void:
	combo = 0
	nmisses += 1
	$CenterContainer/combo.text = str("x", int(combo))
	update_accuracy()
	update_hp("Miss")
	animacion_judge("Miss!")
	#print("MISS!")
	#print("accuracy: ", accuracy*100)
	#print("hp: ",hp)

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
				var timing: int = int(row_data[2]) + GlobalScripts.global_offset
				var spawn: int = timing - note_speed
				var note_data: PackedInt32Array = PackedInt32Array([note_id, note_type, timing, spawn])
				data.push_back(note_data)
			elif row_data.size() == 4 and row_data[0] != "":
				var note_id: int = int(row_data[0])
				var note_type: int = int(row_data[1])
				var spawn:int = int(row_data[3])
				var id_label:int = int(row_data[2])
				var label_data: PackedInt32Array = PackedInt32Array([note_id, note_type, id_label, spawn])
				data.push_back(label_data)
	nivel_file.close()
	return data

func animacion_label(label: Label):
		$score.text = str(int(score))
		var tween = create_tween()
		
		tween.tween_property(label, "scale", Vector2(0.85, 0.85), 0.05)
		
		tween.tween_property(label, "scale", Vector2(0.8, 0.8), 0.25)\
		.set_trans(Tween.TRANS_QUINT)\
		.set_ease(Tween.EASE_OUT)

func animacion_judgement():
	var tween = create_tween()
	
	
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property($JudgementLine, "modulate:a", 1.0, 0.2)
	tween.tween_interval(0.1)
	tween.tween_property($JudgementLine, "modulate:a", 0.45, 0.4)

func animacion_judge(juicio):
	$Planeta/CenterContainer.hide()
	$Planeta/CenterContainer.modulate.a = 0.0
	$Planeta/CenterContainer/Label.text = str(juicio)
	$Planeta/CenterContainer.show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Planeta/CenterContainer, "modulate:a", 1.0, 0.8)
	tween.tween_property($Planeta/CenterContainer, "modulate:a", 0.0, 0.8)

func shake():
	var tween = create_tween()
	
	for i in 40:
		var offset = Vector2(randf_range(-6,6), randf_range(-6,6))
		tween.tween_property($Planeta/Sprite2D, "position", Vector2(0, 0) + offset, 0.03)
	tween.tween_property($Planeta/Sprite2D, "position", Vector2(0, 0) , 0.05)

func mover_camara():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	$Panel2.muerte2 = true
	#print($Panel2.muerte2)
	tween.tween_property($Camera2D, "offset", Vector2(127.9, 360), 1.4)

func animacion_muerte():
	animacion = true
	var tween = create_tween()
	$Planeta.muerte = true
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($Panel, "modulate:a", 1.0, 1)
	tween.parallel().tween_property($Planeta/Sprite2D, "scale", Vector2(0.4,0.4), 1.45)
	tween.parallel().tween_property($Planeta, "position", get_viewport_rect().size / 2, 1.45)
	await get_tree().create_timer(0.4).timeout
	shake()
	await get_tree().create_timer(0.9).timeout
	particulas()
	$explosion.play()
	$Planeta/Sprite2D.texture = load("res://assets/img/Planet_Pack_bycancer/lava_planet.png")
	await get_tree().create_timer(0.2).timeout
	rotate = true
	var tween2 = create_tween()
	tween2.set_trans(Tween.TRANS_EXPO)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.parallel().tween_property($Planeta, "modulate:a",0.2, 4.5)
	tween2.parallel().tween_property($Planeta, "position", Vector2(320, $Planeta.position.y), 22)
	await get_tree().create_timer(1.8).timeout
	mover_camara()
	

func particulas():
	var particulas = particulas_scene.instantiate()
	particulas.position = Vector2.ZERO
	particulas.emitting = true
	$Planeta.add_child(particulas)

func animacion_combo():
	$CenterContainer.hide()
	$CenterContainer.show()
	$CenterContainer/combo.text = str("x", int(combo))
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($CenterContainer, "position", Vector2($CenterContainer.position.x, 64), 0.8)

func particulas_hit():
	var particulas = particulas_hit_scene.instantiate()
	particulas.position = Vector2.ZERO
	particulas.emitting = true
	$Planeta.add_child(particulas)

func _input(event: InputEvent) -> void:
	if animacion == false:
		if event.is_action_pressed("note_input_1") or event.is_action_pressed("note_input_2"):
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_EXPO)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property($Planeta/Sprite2D, "scale", Vector2(0.06,0.06), 0.2)
			tween.tween_property($Planeta/Sprite2D, "scale", Vector2(0.05,0.05), 0.1)


func _on_conductor_finished() -> void:
	GlobalScripts.accuracy = accuracy
	GlobalScripts.score = score
	#print("nivel superado")
	get_tree().change_scene_to_file("res://endscreen.tscn")

func tutorial_printer(label:String):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($tutorial, "modulate:a", 1, 2.5)
	$tutorial.text = label
	tween.tween_property($tutorial, "modulate:a", 0, 2)
