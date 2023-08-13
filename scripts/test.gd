extends Node

@onready var sfx = $UI/SFX
@onready var pause_screen = $UI/CanvasLayer/PauseScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ~~~DEBUG~~~
	if not get_tree().paused:
		if Input.is_action_just_pressed("ui_cancel"):
			pause_screen.visible = true
			get_tree().paused = true
		if Input.is_action_just_pressed("ui_accept"):
			sfx.play()
