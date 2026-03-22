extends Panel

var song_menu_bpm:float = 114

func _ready() -> void:
	$Conductor.bpm    = song_menu_bpm
	$Conductor.sec_per_beat = 60.0 / float(song_menu_bpm)
	$Conductor._load_stream("res://assets/music/menuv2.ogg")
	$Conductor.play()

func _process(delta: float) -> void:
	pass
