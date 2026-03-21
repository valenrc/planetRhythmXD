extends Node2D
var radio:float = 100.0
var center:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center = get_viewport_rect().get_center()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:
	draw_arc(center, radio, 0, PI*2, 64, Color.WEB_GRAY, 0.5, true)
	$".".modulate.a = 0.45
