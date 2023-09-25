extends Control

@onready var controls_panel = $ControlsPanel
@onready var input_panel = $InputPanel
@onready var input_label = $InputPanel/MarginContainer/VBoxContainer/InputLabel
@onready var left_button = $ControlsPanel/MarginContainer/VBoxContainer/LeftInput/LeftButton
@onready var right_button = $ControlsPanel/MarginContainer/VBoxContainer/RightInput/RightButton
@onready var jump_button = $ControlsPanel/MarginContainer/VBoxContainer/JumpInput/JumpButton
@onready var pause_button = $ControlsPanel/MarginContainer/VBoxContainer/PauseInput/PauseButton

var input_id = 0
var current_input: InputEventKey

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1,5):
		var input_str = GlobalSettings.get_input(i)
		if input_str != "":
			match i:
				1: left_button.text = input_str
				2: right_button.text = input_str
				3: jump_button.text = input_str
				4: pause_button.text = input_str

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	controls_panel.visible = not input_panel.visible

func _input(event):
	if input_panel.visible and event is InputEventKey:
			if event.is_pressed():
				current_input = event
				input_label.text = OS.get_keycode_string(event.keycode).to_upper()

func _on_controls_close_button_pressed():
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

func _on_left_button_pressed():
	input_id = 1
	input_panel.visible = true

func _on_right_button_pressed():
	input_id = 2
	input_panel.visible = true

func _on_jump_button_pressed():
	input_id = 3
	input_panel.visible = true

func _on_pause_button_pressed():
	input_id = 4
	input_panel.visible = true

func _on_confirm_button_pressed():
	if current_input is InputEvent:
		GlobalSettings.set_input(input_id, current_input)
		match input_id:
			1: left_button.text = OS.get_keycode_string(current_input.keycode).to_upper()
			2: right_button.text = OS.get_keycode_string(current_input.keycode).to_upper()
			3: jump_button.text = OS.get_keycode_string(current_input.keycode).to_upper()
			4: pause_button.text = OS.get_keycode_string(current_input.keycode).to_upper()
		current_input = null
		input_label.text = ""
	input_panel.visible = false
