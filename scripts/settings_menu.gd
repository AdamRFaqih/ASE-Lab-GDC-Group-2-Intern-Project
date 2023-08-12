extends Panel

@onready var music_val = $MarginContainer/VBoxContainer/MusicSettings/MusicVal
@onready var music_slider = $MarginContainer/VBoxContainer/MusicSettings/MusicSlider
@onready var sfx_val = $MarginContainer/VBoxContainer/SFXSettings/SFXVal
@onready var sfx_slider = $MarginContainer/VBoxContainer/SFXSettings/SFXSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	# retrieve settings so they dont reset after changing scenes
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music_val.text = str(round(music_slider.value*50))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	sfx_val.text = str(round(sfx_slider.value*50))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_music_slider_value_changed(value):
	music_val.text = str(value*50)
	GlobalSettings.update_music_volume(value)

func _on_sfx_slider_value_changed(value):
	sfx_val.text = str(value*50)
	GlobalSettings.update_sfx_volume(value)

func _on_settings_close_button_pressed():
	self.visible = false
