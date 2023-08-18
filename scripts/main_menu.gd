extends Control

@onready var title_menu = $CanvasLayer/TitleMenu
@onready var settings_menu = $CanvasLayer/SettingsMenu
@onready var credits = $CanvasLayer/Credits

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	title_menu.visible = not (settings_menu.visible or credits.visible)

func _on_play_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test.tscn")

func _on_settings_button_pressed():
	settings_menu.visible = true

func _on_credits_button_pressed():
	credits.visible = true

func _on_quit_button_pressed():
	get_tree().quit()
