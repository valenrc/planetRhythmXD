extends Node2D

const escala = Vector2(0.5,0.5)

func _ready() -> void:
	$Sprite2D.scale = escala

func _process(delta: float) -> void:
	pass

func _on_conductor_beat(position: Variant) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "scale", escala + Vector2(0.01, 0.01), 0.1)
	tween.tween_property($Sprite2D, "scale", escala, 0.1)
