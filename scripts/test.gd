extends Node

@onready var sfx = $UI/SFX

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ~~~DEBUG~~~
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	if Input.is_action_just_pressed("ui_accept"):
		sfx.play()
