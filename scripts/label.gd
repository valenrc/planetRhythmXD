extends Label

@onready var label: Label = $"."

func _ready():
	GlobalScripts.cambiar_tecla.connect(actualizargui)

func actualizargui(tecla):
	label.text = str(tecla)
