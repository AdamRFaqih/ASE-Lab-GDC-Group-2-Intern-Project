extends Panel

@onready var music_val = $MarginContainer/VBoxContainer/MusicSettings/MusicVal
@onready var music_slider = $MarginContainer/VBoxContainer/MusicSettings/MusicSlider
@onready var sfx_val = $MarginContainer/VBoxContainer/SFXSettings/SFXVal
@onready var sfx_slider = $MarginContainer/VBoxContainer/SFXSettings/SFXSlider
@onready var fullscreen_val = $MarginContainer/VBoxContainer/FullscreenSettings/FullscreenVal
@onready var fullscreen_button = $MarginContainer/VBoxContainer/FullscreenSettings/FullscreenButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# retrieve settings so they dont reset after changing scenes
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music_val.text = str(round(music_slider.value*50))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))
	sfx_val.text = str(round(sfx_slider.value*50))
	var window_mode = int(DisplayServer.window_get_mode())
	if window_mode == 0:
		fullscreen_val.text = "OFF"
		fullscreen_button.button_pressed = false
	elif window_mode == 3:
		fullscreen_val.text = "ON"
		fullscreen_button.button_pressed = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if music_slider.value == 0:
		music_val.text = "OFF"
	if sfx_slider.value == 0:
		sfx_val.text = "OFF"

func _on_music_slider_value_changed(value):
	music_val.text = str(value*50)
	GlobalSettings.set_music_volume(value)

func _on_sfx_slider_value_changed(value):
	sfx_val.text = str(value*50)
	GlobalSettings.set_sfx_volume(value)

func _on_check_button_toggled(button_pressed):
	if button_pressed:
		fullscreen_val.text = "ON"
	else:
		fullscreen_val.text = "OFF"
	GlobalSettings.set_fullscreen(button_pressed)

func _on_controls_button_pressed():
	get_tree().change_scene_to_file("res://scenes/controls_menu.tscn")

func _on_settings_close_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
