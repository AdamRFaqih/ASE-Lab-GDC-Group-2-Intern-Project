extends Control

@onready var title_menu = $CanvasLayer/TitleMenu
@onready var play_game_button = $CanvasLayer/TitleMenu/Panel/MarginContainer/VBoxContainer/PlayGameButton

# Called when the node enters the scene tree for the first time.
func _ready():
	play_game_button.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test_level2.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
