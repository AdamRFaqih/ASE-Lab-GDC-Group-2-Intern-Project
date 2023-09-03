extends Control

@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var test_level_label = $CanvasLayer/TestLevelLabel
@onready var pause_screen = $CanvasLayer/PauseScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
	pause_screen.visible = get_tree().paused and not game_over_screen.visible

func _on_test_player_die():
	game_over_screen.visible = true
	get_tree().paused = true

func _on_retry_button_pressed():
	get_tree().reload_current_scene()

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_label_timer_timeout():
	test_level_label.hide()

func _on_pause_button_pressed():
	get_tree().paused = true

func _on_resume_button_pressed():
	get_tree().paused = false
