extends Node2D

var t = 0.0 # va de 0 a 2*pi en bucle
var speed = GlobalScripts.velocidad_planeta
var amplitud = 100
var desp_x
var desp_y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desp_x = get_viewport_rect().get_center().x
	desp_y = get_viewport_rect().get_center().y
	if GlobalScripts.skin == "default":
		$Sprite2D.texture = load("res://assets/img/Planet_Pack_bycancer/neptunlikeplanet.png")
	elif GlobalScripts.skin == "skin1":
		$Sprite2D.texture = load("res://assets/img/Cubawikilogo_pixelated.png")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# agrego algo
	position.x = amplitud*cos(t) + desp_x
	position.y = amplitud*sin(t) + desp_y
	
	t += 1 * speed
	if(t >= 2*PI):
		t = 0
