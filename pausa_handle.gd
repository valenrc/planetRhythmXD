extends Node
var muerte := false


func _unhandled_input(event: InputEvent) -> void:
	if muerte == true:
		return
	
	if event.is_action_pressed("pausa"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused == true:
			$"../pausa_menu".show()
		else:
			$"../pausa_menu".hide()
		$"../pausa_menu/VBoxContainer/reset".add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
		$"../pausa_menu/VBoxContainer/reanudar".add_theme_color_override("font_color", Color(1, 1, 1, 1))
		$"../pausa_menu/VBoxContainer/reanudar".grab_focus()
		$"../pausa_menu/VBoxContainer/salir".add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	if event.is_action_pressed("ui_accept"):
		if $"../pausa_menu/VBoxContainer/reanudar".has_focus():
			get_tree().paused = false
			$"../pausa_menu".hide()
		elif $"../pausa_menu/VBoxContainer/salir".has_focus():
			get_tree().paused = false
			get_tree().change_scene_to_file("res://main.tscn")
		elif $"../pausa_menu/VBoxContainer/reset".has_focus():
			get_tree().paused = false
			get_tree().change_scene_to_file("res://Nivel.tscn")

func _on_reanudar_focus_entered() -> void:
	$"../pausa_menu/VBoxContainer/reanudar".grab_focus()
	$"../pausa_menu/VBoxContainer/reanudar".add_theme_color_override("font_color", Color(1, 1, 1, 1))

func _on_salir_focus_entered() -> void:
	$"../pausa_menu/VBoxContainer/salir".grab_focus()
	$"../pausa_menu/VBoxContainer/salir".add_theme_color_override("font_color", Color(1, 1, 1, 1))

func _on_reanudar_focus_exited() -> void:
	$"../pausa_menu/VBoxContainer/reanudar".add_theme_color_override("font_color", Color(1, 1, 1, 0.5))

func _on_salir_focus_exited() -> void:
	$"../pausa_menu/VBoxContainer/salir".add_theme_color_override("font_color", Color(1, 1, 1, 0.5))

func _on_reset_focus_entered() -> void:
	$"../pausa_menu/VBoxContainer/reset".grab_focus()
	$"../pausa_menu/VBoxContainer/reset".add_theme_color_override("font_color", Color(1, 1, 1, 1))

func _on_reset_focus_exited() -> void:
	$"../pausa_menu/VBoxContainer/reset".add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
