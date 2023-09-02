extends Control

@onready var game_over_screen = $CanvasLayer/GameOverScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_tree().paused = game_over_screen.visible

func _on_test_player_die():
	game_over_screen.visible = true

func _on_retry_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
