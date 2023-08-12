extends Control

@onready var sfx = $SFX
@onready var texture_rect = $CanvasLayer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ~~~DEBUG~~~
	# ESC to exit test scene and back to main menu
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	# ENTER to play vine boom sound effect cuz i hate myself
	if Input.is_action_just_pressed("ui_accept"):
		texture_rect.scale *= 1.042069
		sfx.play()
	# spin, not really necessary
	texture_rect.rotation += 2.1 * delta
