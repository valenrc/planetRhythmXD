extends Control

var escenas_menu
var menu_opciones: bool
var puede: bool
var anterior_escena
var rebind: bool = false
var skin_menu := false
var rebind2 := false
var velocidad_planeta := false
var scroll_speed := false
@export var nivel: PackedScene

signal rebind_tecla

func mover_menu_c(boton: Control, xy: Vector2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(boton, "position", xy, 0.5)

func play():
	get_tree().change_scene_to_packed(nivel)

func controles_menu():
	$Menu_controles.position = Vector2(0, 0)
	$Menu_opciones.hide()
	$Menu_canciones.hide()
	$Start_menu.hide()
	$Menu_controles.show()
	$Menu_controles/Button.grab_focus()
	$Menu_controles/Button/Label.grab_focus()
	anterior_escena = "opciones"
	$Menu_controles/Button2/Label2.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	$Menu_controles/Button/Label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	puede = false

func start():
	$stats.hide()
	puede = true
	escenas_menu = 1
	$Menu_skins/Label.position = Vector2(228, 108)
	$Planeta.hide()
	$Menu_opciones.hide()
	$sol.hide()
	$Start_menu.show()
	$Menu_canciones/Tutorial.position = Vector2(-135, 60)
	$Menu_canciones/Cancion1.position = Vector2(-135, 97)
	$Start_menu/play.grab_focus()
	$Menu_canciones.hide()

func rebind_control():
	$Menu_controles/Button.focus_mode = Control.FOCUS_NONE
	$Menu_controles/Panel.show()
	rebind = true
	puede = false
	await get_tree().create_timer(0.2).timeout
	puede = true

func rebind_control2():
	$Menu_controles/Button2.focus_mode = Control.FOCUS_NONE
	$Menu_controles/Panel.show()
	rebind2 = true
	puede = false
	await get_tree().create_timer(0.2).timeout
	puede = true


func Canciones_menu():
	$stats.show()
	escenas_menu += 1
	anterior_escena = "menu"
	$Menu_preferences.hide()
	$Menu_canciones/Tutorial.grab_focus()
	$Menu_canciones/songs.show()
	escenas_menu += 1
	$Menu_canciones.show()
	$Start_menu.hide()
	mover_menu_c($Menu_canciones/Tutorial, Vector2(0, 60))
	await get_tree().create_timer(0.05).timeout
	mover_menu_c($Menu_canciones/Cancion1, Vector2(0, 97))
	await get_tree().create_timer(0.05).timeout
	mover_menu_c($Menu_canciones/Cancion2, Vector2(0, 135))
	puede = false


func Opciones_menu():
	$Menu_opciones/offset_cali.disabled = true
	rebind2 = false
	scroll_speed = false
	skin_menu = false
	rebind = false
	escenas_menu += 1
	$Menu_controles/Panel.hide()
	$Menu_skins.hide()
	anterior_escena = "menu"
	$Menu_controles.hide()
	$Menu_opciones/control.disabled = true
	$Menu_opciones/skins.disabled = true
	$Menu_opciones/preferences.grab_focus()
	$Menu_opciones.position = Vector2(0, 0)
	$Menu_canciones.hide()
	$Menu_preferences.hide()
	$Menu_opciones.show()
	$Start_menu.hide()
	puede = false

func skins_menu():
	$Menu_skins/Skin_planeta.scale = Vector2(0.01, 0.01)
	escenas_menu += 1
	anterior_escena = "opciones"
	$Menu_skins.position = Vector2(0, 0)
	$Menu_opciones.hide()
	skin_menu = true
	$Menu_skins.show()
	var tween = create_tween()
	tween.tween_property($Menu_skins/Skin_planeta, "scale", Vector2(0.4, 0.4), 1.21)\
		.set_trans(Tween.TRANS_QUINT)\
		.set_ease(Tween.EASE_OUT)


func preferences():
	escenas_menu += 1
	anterior_escena = "opciones"
	$Menu_preferences/Scroll_speed.grab_focus()
	$Menu_canciones.hide()
	$Menu_opciones.hide()
	$Menu_preferences.show()
	$Menu_preferences.position = Vector2(0, 0)
	$Start_menu.hide()
	$Menu_preferences/Velocidad_planeta/Label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	$Menu_preferences/Velocidad_planeta.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	puede = false

func _ready() -> void:
	set_process_input(true)
	puede = true
	start()
	$Menu_skins/Label.text = ">"
	$Start_menu/options.modulate.a = 0.5
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if GlobalScripts.completado[0]:
		$Menu_canciones/Tutorial/rank.text = str(GlobalScripts.rank_stats[0])
		if GlobalScripts.rank_stats[0] == "D":
			$Menu_canciones/Tutorial/rank.add_theme_color_override("font_color", Color(0.537, 0.537, 0.537, 1.0))
		elif GlobalScripts.rank_stats[0] == "C":
			$Menu_canciones/Tutorial/rank.add_theme_color_override("font_color", Color(0.0, 0.649, 0.209, 1.0))
		elif GlobalScripts.rank_stats[0] == "B":
			$Menu_canciones/Tutorial/rank.add_theme_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
		elif GlobalScripts.rank_stats[0] == "A":
			$Menu_canciones/Tutorial/rank.add_theme_color_override("font_color", Color(0.78, 0.432, 0.0, 1.0))
		elif GlobalScripts.rank_stats[0] == "S":
			$Menu_canciones/Tutorial/rank.add_theme_color_override("font_color", Color(0.917, 0.0, 0.104, 1.0))
		elif GlobalScripts.rank_stats[0] == "SS":
			$Menu_canciones/Tutorial/rank.add_theme_color_override("font_color", Color(0.886, 0.699, 0.0, 1.0))
	if GlobalScripts.completado[1]:
		$Menu_canciones/Cancion1/rank.text = str(GlobalScripts.rank_stats[1])
		if GlobalScripts.rank_stats[1] == "D":
			$Menu_canciones/Cancion1/rank.add_theme_color_override("font_color", Color(0.537, 0.537, 0.537, 1.0))
		elif GlobalScripts.rank_stats[1] == "C":
			$Menu_canciones/Cancion1/rank.add_theme_color_override("font_color", Color(0.0, 0.649, 0.209, 1.0))
		elif GlobalScripts.rank_stats[1] == "B":
			$Menu_canciones/Cancion1/rank.add_theme_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
		elif GlobalScripts.rank_stats[1] == "A":
			$Menu_canciones/Cancion1/rank.add_theme_color_override("font_color", Color(0.78, 0.432, 0.0, 1.0))
		elif GlobalScripts.rank_stats[1] == "S":
			$Menu_canciones/Cancion1/rank.add_theme_color_override("font_color", Color(0.917, 0.0, 0.104, 1.0))
		elif GlobalScripts.rank_stats[1] == "SS":
			$Menu_canciones/Cancion1/rank.add_theme_color_override("font_color", Color(0.886, 0.699, 0.0, 1.0))
	if GlobalScripts.completado[2]:
		$Menu_canciones/Cancion2/rank.text = str(GlobalScripts.rank_stats[2])
		if GlobalScripts.rank_stats[2] == "D":
			$Menu_canciones/Cancion2/rank.add_theme_color_override("font_color", Color(0.537, 0.537, 0.537, 1.0))
		elif GlobalScripts.rank_stats[2] == "C":
			$Menu_canciones/Cancion2/rank.add_theme_color_override("font_color", Color(0.0, 0.649, 0.209, 1.0))
		elif GlobalScripts.rank_stats[2] == "B":
			$Menu_canciones/Cancion2/rank.add_theme_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
		elif GlobalScripts.rank_stats[2] == "A":
			$Menu_canciones/Cancion2/rank.add_theme_color_override("font_color", Color(0.78, 0.432, 0.0, 1.0))
		elif GlobalScripts.rank_stats[2] == "S":
			$Menu_canciones/Cancion2/rank.add_theme_color_override("font_color", Color(0.917, 0.0, 0.104, 1.0))
		elif GlobalScripts.rank_stats[2] == "SS":
			$Menu_canciones/Cancion2/rank.add_theme_color_override("font_color", Color(0.886, 0.699, 0.0, 1.0))

func _process(delta: float) -> void:
	if skin_menu:
		$Menu_skins/Skin_planeta.rotate(0.003)

# menu --------------------------------------------------------------------

# play focus

func _on_play_focus_entered():
	$Start_menu/quit.hide()
	$Start_menu/play.grab_focus()
	$Start_menu/play.scale = Vector2(1.0, 1.0)
	$Start_menu/play.position = Vector2(74.625, 104.5)
	$Start_menu/play.modulate.a = 1
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Start_menu/Label, "position", Vector2($Start_menu/Label.position.x, 20), 0.5)

func _on_play_focus_exited():
	$Start_menu/play.modulate.a = 0.5
	$Start_menu/play.scale = Vector2(0.8, 0.8)
	$Start_menu/play.position = Vector2(86, 71.5)

# opcioones focus

func _on_play_2_focus_entered() -> void:
	$Start_menu/quit.show()
	$Start_menu/quit.modulate.a = 0.5
	$Start_menu/options.modulate.a = 1
	$Start_menu/options.grab_focus()
	$Start_menu/options.scale = Vector2(1.0, 1.0)
	$Start_menu/options.position = Vector2(74.625, 104.5)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Start_menu/Label, "position", Vector2($Start_menu/Label.position.x, 25), 0.5)


func _on_play_2_focus_exited() -> void:
	$Start_menu/options.modulate.a = 0.5
	$Start_menu/options.scale = Vector2(0.8, 0.8)
	$Start_menu/options.position = Vector2(86, 145)

func _on_quit_focus_entered() -> void:
	$Start_menu/quit.modulate.a = 1
	$Start_menu/quit.grab_focus()
	$Start_menu/play.hide()
	$Start_menu/options.position = Vector2(86, 71.5)
	$Start_menu/quit.position = Vector2(109, 104.5)

func _on_quit_focus_exited() -> void:
	$Start_menu/quit.modulate.a = 0.5
	$Start_menu/quit.position = Vector2(109, 145)
	$Start_menu/play.show()

# input ----------------------------------------------------------

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		if $Start_menu/play.has_focus():
			Canciones_menu()
		
		elif $Start_menu/options.has_focus():
			Opciones_menu()
		
		elif $Menu_canciones/Tutorial.has_focus():
			GlobalScripts.nivel = "flow"
			GlobalScripts.tutorial = true
			play()
		
		elif $Menu_opciones/preferences.has_focus():
			preferences()
		
		elif $Menu_opciones/control.has_focus():
			controles_menu()
		
		elif $Menu_opciones/skins.has_focus():
			skins_menu()
		
		elif $Menu_controles/Button.has_focus():
			if rebind == false:
				rebind_control()
		elif $Menu_controles/Button2.has_focus():
			if rebind2 == false:
				rebind_control2()
		elif $Menu_canciones/Cancion1.has_focus():
			GlobalScripts.nivel = "spaced_out"
			play()
		elif $Menu_canciones/Cancion2.has_focus():
			GlobalScripts.nivel = "space_hardstyle"
			play()
		elif $Start_menu/quit.has_focus():
			get_tree().quit()
		elif $Menu_opciones/offset_cali.has_focus():
			get_tree().change_scene_to_file("res://offset_nivel.tscn")

	if event.is_action_pressed("back"):
		if escenas_menu > 1:
			if rebind2 == false:
				if rebind == false:
					escenas_menu -= 1
					puede = true
					$Menu_canciones/Tutorial.position = Vector2(-135, 60)
					$Menu_canciones/Cancion1.position = Vector2(-135, 97)
					if anterior_escena == "menu":
						start()
					if anterior_escena == "opciones":
						Opciones_menu()
	if event.is_action_pressed("backspace"):
		if rebind:
			$Menu_controles/Panel.hide()
			rebind = false
			$Menu_controles/Button.focus_mode = FOCUS_ALL
			$Menu_controles/Button.grab_focus()
		elif rebind2:
			$Menu_controles/Panel.hide()
			rebind2 = false
			$Menu_controles/Button2.focus_mode = FOCUS_ALL
			$Menu_controles/Button2.grab_focus()
	if rebind == true:
		if puede:
			if event is InputEventKey and event.pressed and not event.echo:
				GlobalScripts.Hit_tecla = (OS.get_keycode_string(event.keycode))
				GlobalScripts.cambiar_tecla.emit(GlobalScripts.Hit_tecla)
				InputMap.action_erase_events("note_input_1")
				InputMap.action_add_event("note_input_1", event)
				$Menu_controles/Panel.hide()
				rebind = false
				$Menu_controles/Button.focus_mode = FOCUS_ALL
				$Menu_controles/Button.grab_focus()
	if rebind2 == true:
		if puede:
			if event is InputEventKey and event.pressed and not event.echo:
				GlobalScripts.Hit_tecla2 = (OS.get_keycode_string(event.keycode))
				GlobalScripts.cambiar_tecla2.emit(GlobalScripts.Hit_tecla2)
				InputMap.action_erase_events("note_input_2")
				InputMap.action_add_event("note_input_2", event)
				$Menu_controles/Panel.hide()
				rebind2 = false
				$Menu_controles/Button2.focus_mode = FOCUS_ALL
				$Menu_controles/Button2.grab_focus()
	
	if event.is_action_pressed("right"):
		if scroll_speed:
			if not GlobalScripts.scroll_speed >= 20000:
				GlobalScripts.scroll_speed += 100
				$Menu_preferences/Scroll_speed/Label.text = str(GlobalScripts.scroll_speed / 1000.0)
		if velocidad_planeta:
			if not GlobalScripts.velocidad_planeta >= 0.2:
				GlobalScripts.velocidad_planeta += 0.01
				$Menu_preferences/Velocidad_planeta/Label.text = str(GlobalScripts.velocidad_planeta)
		if skin_menu == true:
			$Menu_skins/Skin_planeta.texture = load("res://assets/img/Cubawikilogo_pixelated.png")
			GlobalScripts.skin = "skin1"
			$Menu_skins/Label.position = Vector2(20, 108)
			$Menu_skins/Label.text = "<"
	if event.is_action_pressed("left"):
		if scroll_speed:
			if not GlobalScripts.scroll_speed <= 500:
				GlobalScripts.scroll_speed -= 100
				$Menu_preferences/Scroll_speed/Label.text = str(GlobalScripts.scroll_speed / 1000.0)
		if velocidad_planeta:
			if not GlobalScripts.velocidad_planeta <= 0.01:
				GlobalScripts.velocidad_planeta -= 0.01
				$Menu_preferences/Velocidad_planeta/Label.text = str(GlobalScripts.velocidad_planeta)
		if skin_menu == true:
			$Menu_skins/Skin_planeta.texture = load("res://assets/img/Planet_Pack_bycancer/neptunlikeplanet.png")
			GlobalScripts.skin = "default"
			$Menu_skins/Label.position = Vector2(228, 108)
			$Menu_skins/Label.text = ">"

#opciones GUI --------------------------------------------------------

func _on_control_focus_entered() -> void:
	$Menu_opciones/control.disabled = false

func _on_control_focus_exited() -> void:
	$Menu_opciones/control.disabled = true

func _on_preferences_focus_entered() -> void:
	$Menu_opciones/preferences.disabled = false

func _on_preferences_focus_exited() -> void:
	$Menu_opciones/preferences.disabled = true

func _on_test_2_focus_entered() -> void:
	$Menu_opciones/skins.disabled = false

func _on_test_2_focus_exited() -> void:
	$Menu_opciones/skins.disabled = true

#preferences --------------------------------------------------------------

func _on_button_focus_entered() -> void:
	$Menu_controles/Button/Label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_controles/Button/Label/Label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_controles/Button2/Label2.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	$Menu_controles/Button2/Label2/Label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))

func _on_button_2_focus_entered() -> void:
	$Menu_controles/Button2/Label2.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_controles/Button2/Label2/Label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_controles/Button/Label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	$Menu_controles/Button/Label/Label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))

func _on_scroll_speed_focus_entered() -> void:
	scroll_speed = true
	$Menu_preferences/Scroll_speed.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_preferences/Scroll_speed/Label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_preferences/Scroll_speed.grab_focus()

func _on_scroll_speed_focus_exited() -> void:
	scroll_speed = false
	$Menu_preferences/Scroll_speed.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	$Menu_preferences/Scroll_speed/Label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))


func _on_velocidad_planeta_focus_entered() -> void:
	velocidad_planeta = true
	$Menu_preferences/Velocidad_planeta.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_preferences/Velocidad_planeta/Label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$Menu_preferences/Velocidad_planeta.grab_focus()

func _on_velocidad_planeta_focus_exited() -> void:
	velocidad_planeta = false
	$Menu_preferences/Velocidad_planeta/Label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	$Menu_preferences/Velocidad_planeta.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))

func _on_tutorial_focus_entered() -> void:
	$stats/high_score.text = str("High score: ", GlobalScripts.score_stats[0])
	$stats/accuracy.text = str("Accuracy: ", GlobalScripts.accuracy_stats[0], "%")
	$stats/rank.text = str("Rank: ", GlobalScripts.rank_stats[0])

func _on_cancion_1_focus_entered() -> void:
	$stats/high_score.text = str("High score: ", GlobalScripts.score_stats[1])
	$stats/accuracy.text = str("Accuracy: ", GlobalScripts.accuracy_stats[1], "%")
	$stats/rank.text = str("Rank: ", GlobalScripts.rank_stats[1])

func _on_cancion_2_focus_entered() -> void:
	$stats/high_score.text = str("High score: ", GlobalScripts.score_stats[2])
	$stats/accuracy.text = str("Accuracy: ", GlobalScripts.accuracy_stats[2], "%")
	$stats/rank.text = str("Rank: ", GlobalScripts.rank_stats[2])


func _on_offset_cali_focus_entered() -> void:
	$Menu_opciones/offset_cali.grab_focus()
	$Menu_opciones/offset_cali.disabled = false


func _on_offset_cali_focus_exited() -> void:
	$Menu_opciones/offset_cali.disabled = true
