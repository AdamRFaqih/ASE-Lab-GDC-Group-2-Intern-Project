extends Panel

@onready var music_val = $MarginContainer/VBoxContainer/MusicSettings/MusicVal
@onready var sfx_val = $MarginContainer/VBoxContainer/SFXSettings/SFXVal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_music_slider_value_changed(value):
	music_val.text = str(value/2)
	GlobalSettings.update_music_vol(value)

func _on_sfx_slider_value_changed(value):
	sfx_val.text = str(value/2)
	GlobalSettings.update_sfx_vol(value)
