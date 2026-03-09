extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$score.text = str("Score: ", int(GlobalScripts.score))
	$accuracy.text = str("Accuracy: ", snapped(GlobalScripts.accuracy * 100, 0.01), "%")
	$salir.modulate.a = 0
	$flash.position = Vector2(-171, 64)

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property($score, "position", Vector2(19,$score.position.y), 0.5)
	tween.tween_property($flash, "modulate:a", 0.7, 0.1)
	tween.tween_property($flash, "modulate:a", 0, 1.1)

	tween.tween_property($accuracy, "position", Vector2(19,$accuracy.position.y), 0.5)

	tween.tween_callback(func(): $flash.position = Vector2(-171,118))

	tween.tween_property($flash, "modulate:a", 0.7, 0.1)
	tween.tween_property($flash, "modulate:a", 0, 1.1)
	tween.tween_property($salir, "modulate:a", 1, 1.1)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://main.tscn")
