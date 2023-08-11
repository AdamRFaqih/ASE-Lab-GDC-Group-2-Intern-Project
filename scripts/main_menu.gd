extends Control

@export var level : PackedScene

@onready var title_menu = $CanvasLayer/TitleMenu
@onready var settings_menu = $CanvasLayer/SettingsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_game_button_pressed():
	get_tree().change_scene_to_packed(level)

func _on_settings_button_pressed():
	settings_menu.visible = true
	title_menu.visible = false

func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_close_button_pressed():
	title_menu.visible = true
	settings_menu. visible = false
