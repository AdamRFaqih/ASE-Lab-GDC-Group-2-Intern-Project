extends Control

@onready var game_over_screen = $CanvasLayer/GameOverScreen
@onready var test_panel = $CanvasLayer/TestPanel
@onready var pause_screen = $CanvasLayer/PauseScreen
@onready var alt_pause_label = $CanvasLayer/MarginContainer/VBoxContainer/AltPauseLabel
@onready var score_label = $CanvasLayer/GameOverScreen/Panel/MarginContainer/VBoxContainer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	if GlobalSettings.get_input(4) != "":
		alt_pause_label.text = "or press [" + GlobalSettings.get_input(4) + "]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
	pause_screen.visible = get_tree().paused and not game_over_screen.visible

func _on_retry_button_pressed():
	get_tree().reload_current_scene()

func _on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_pause_button_pressed():
	get_tree().paused = true

func _on_resume_button_pressed():
	get_tree().paused = false

func _on_map_player_die():
	game_over_screen.visible = true
	get_tree().paused = true
	print(GlobalSettings.current_score)
	#score_label.text = "SCORE: " + str(GlobalSettings.get_score())
