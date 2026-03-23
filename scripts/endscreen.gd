extends Control
var animacion_terminada := false
var tween: Tween

func _ready() -> void:
	$aliensin.play()
	$BG_music.play()
	await get_tree().create_timer(0.5).timeout
	$score.text = str("Score: ", int(GlobalScripts.score))
	$accuracy.text = str("Accuracy: ", snapped(GlobalScripts.accuracy * 100, 0.01), "%")
	$salir.modulate.a = 0
	$flash.position = Vector2(-171, 64)
	
	
	if GlobalScripts.accuracy >= 0 and GlobalScripts.accuracy < 0.70:
		$Panel/CenterContainer/FinalScore.add_theme_color_override("font_color", Color(0.537, 0.537, 0.537, 1.0))
		$Panel/CenterContainer/FinalScore.text = "D"
	elif GlobalScripts.accuracy >= 0.70 and GlobalScripts.accuracy < 0.85:
		$Panel/CenterContainer/FinalScore.add_theme_color_override("font_color", Color(0.0, 0.649, 0.209, 1.0))
		$Panel/CenterContainer/FinalScore.text = "C"
	elif GlobalScripts.accuracy >= 0.85 and GlobalScripts.accuracy < 0.90:
		$Panel/CenterContainer/FinalScore.add_theme_color_override("font_color", Color(1.0, 1.0, 0.0, 1.0))
		$Panel/CenterContainer/FinalScore.text = "B"
	elif GlobalScripts.accuracy >= 0.90 and GlobalScripts.accuracy < 0.95:
		$Panel/CenterContainer/FinalScore.add_theme_color_override("font_color", Color(0.78, 0.432, 0.0, 1.0))
		$Panel/CenterContainer/FinalScore.text = "A"
	elif GlobalScripts.accuracy >= 0.95 and GlobalScripts.accuracy < 1:
		$Panel/CenterContainer/FinalScore.add_theme_color_override("font_color", Color(0.917, 0.0, 0.104, 1.0))
		$Panel/CenterContainer/FinalScore.text = "S"
	elif GlobalScripts.accuracy >= 1:
		$Panel/CenterContainer/FinalScore.add_theme_color_override("font_color", Color(0.886, 0.699, 0.0, 1.0))
		$Panel/CenterContainer/FinalScore.text = "SS"
	if GlobalScripts.nivel == "flow":
		if GlobalScripts.score > int(GlobalScripts.score_stats[0]):
			GlobalScripts.completado[0] = true
			GlobalScripts.rank_stats[0] = str($Panel/CenterContainer/FinalScore.text)
	if GlobalScripts.nivel == "spaced_out":
		if GlobalScripts.score > int(GlobalScripts.score_stats[1]):
			GlobalScripts.completado[1] = true
			GlobalScripts.rank_stats[1] = str($Panel/CenterContainer/FinalScore.text)
	if GlobalScripts.nivel == "space_hardstyle":
		if GlobalScripts.score > int(GlobalScripts.score_stats[2]):
			GlobalScripts.completado[2] = true
			GlobalScripts.rank_stats[2] = str($Panel/CenterContainer/FinalScore.text)
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	
	
	tween.tween_property($score, "position", Vector2(19,$score.position.y), 0.5)
	tween.tween_property($flash, "modulate:a", 0.7, 0.1)
	tween.tween_callback(func(): $score2.play())
	tween.tween_property($flash, "modulate:a", 0, 1.1)

	tween.tween_property($accuracy, "position", Vector2(19,$accuracy.position.y), 0.5)

	tween.tween_callback(func(): $flash.position = Vector2(-171,118))

	tween.tween_property($flash, "modulate:a", 0.7, 0.1)
	tween.tween_callback(func(): $score2.play())
	tween.tween_property($flash, "modulate:a", 0, 1.1)
	tween.tween_property($Panel, "modulate:a", 1, 0)
	tween.tween_property($Pane_skip_animacionl, "self_modulate:a", 1, 0)
	tween.tween_callback(func(): $"final score".play())
	tween.tween_property($Panel, "self_modulate:a", 0.9, 0.04)
	tween.tween_property($Panel, "self_modulate:a", 0, 1.12)
	if randi() % 100 > 67:
		tween.tween_property($aliensin, "position", Vector2(234.0, $aliensin.position.y), 1.2)
	tween.tween_property($salir, "modulate:a", 1, 1.1)
	
	tween.finished.connect(func(): animacion_terminada = true)
	
	#await get_tree().create_timer(5.0).timeout

func _skip_animacion() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	$score.position.x = 19
	$accuracy.position.x = 19
	$flash.modulate.a = 0
	$Panel.modulate.a = 1
	$Panel.self_modulate.a = 0
	if randi() % 100 > 80:
		tween.tween_property($aliensin, "position", Vector2(234.0, $aliensin.position.y), 1.2)
	$salir.modulate.a = 1
	animacion_terminada = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if animacion_terminada:
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		else:
			_skip_animacion()
