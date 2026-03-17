extends Node2D

const escala = Vector2(0.36,0.36)

func _ready() -> void:
	$Sprite2D.scale = escala

func _process(delta: float) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("note_input_1"):
		print("isdjafkl")

func beat():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "scale", Vector2(0.38,0.38), 0.1)
	tween.tween_property($Sprite2D, "scale", escala, 0.1)
