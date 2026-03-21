extends Panel

var muerte2 := false

func _ready() -> void:
		$reiniciar_muerte.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		$reiniciar_muerte.grab_focus()
		$salir_muerte.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))

func _unhandled_input(event: InputEvent) -> void:
	if muerte2 == true:
		if event.is_action_pressed("ui_accept"):
			if $reiniciar_muerte.has_focus():
				get_tree().change_scene_to_file("res://scenes/Nivel.tscn")
			elif $salir_muerte.has_focus():
				get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_reiniciar_muerte_focus_entered() -> void:
	$reiniciar_muerte.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$reiniciar_muerte.grab_focus()

func _on_reiniciar_muerte_focus_exited() -> void:
	$reiniciar_muerte.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))

func _on_salir_muerte_focus_entered() -> void:
	$salir_muerte.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	$salir_muerte.grab_focus()

func _on_salir_muerte_focus_exited() -> void:
	$salir_muerte.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
