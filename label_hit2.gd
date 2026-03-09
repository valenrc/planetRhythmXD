extends Label

@onready var label: Label = $"."

func _ready():
	GlobalScripts.cambiar_tecla2.connect(actualizar_ui)

func actualizar_ui(tecla):
	label.text = str(tecla)
