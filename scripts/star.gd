extends Node2D

var viewport_size
var colores = [Color(1.00,1.00,0.40,0.29), Color(0.918, 0.426, 0.993, 0.29)]

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	visible = false
	_spawn_random()

func _process(delta: float) -> void:
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	visible = false
	await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
	_spawn_random()
	visible = true
	$AnimatedSprite2D.play()

func _spawn_random():
	position = Vector2(randf_range(0, viewport_size.x), randf_range(0, viewport_size.y))
	var scale_x = randf_range(0.5, 0.8)
	var color:Color = colores[randi_range(0,1)]
	rotation_degrees = randf_range(-120.0, 30.0)
	scale = Vector2(scale_x, scale_x)
	$AnimatedSprite2D.modulate = color
