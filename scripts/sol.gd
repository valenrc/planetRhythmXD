extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_viewport_rect().size / 2

func _process(delta: float) -> void:
	$Sol.rotate(0.04)
