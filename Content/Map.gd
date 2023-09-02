extends Node2D

@export var player : CharacterBody2D
@export var region_1 : Node2D # -385
@export var region_2 : Node2D
@export var minimumYDistance : float = 192.5
@export var platformRepeatDistance : float = -35
@export var remote_transform_2d : RemoteTransform2D
@export var debug_fog : Node2D
@export var menu_ui : Control

var target_y_position : float = 0
var target_y_position_in_region_1 : bool = false
var countdown : float = 0
var fog_position : float = 0
var fog_anchor_position : float = 0
var hasStarted : bool = false
var platform_vanish_dist : float = 200
var platform_fall_speed : float = 1

# UI Mechanic
var game_ended : bool = false

# Scoring Mechanic
var last_y_position : float = 0
var current_score : int = 0
@export var score_text : Label
@export var menu_score_text : Label

# Player Sprite Changing Mechanic
var player_was_in_region_1 : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	target_y_position = minimumYDistance * -3
	fog_position = 10
	target_y_position_in_region_1 = false
	fog_anchor_position = -minimumYDistance
	hasStarted = false
	randomize_region_1()
	randomize_region_2()
	menu_ui.visible = false
	last_y_position = player.global_position.y
	current_score = 0
	player_was_in_region_1 = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_ended:
		return
	if player.global_position.y < target_y_position:
		randomize_map()
		target_y_position = target_y_position - (minimumYDistance*2)
	if player.global_position.y < fog_anchor_position:
		fog_position = min(fog_anchor_position+100, fog_position)
		fog_anchor_position = fog_anchor_position - (minimumYDistance)
		hasStarted = true
		#fog_position = min(player.global_position.y + (minimumYDistance/1.5), fog_position)
	if hasStarted:
		fog_position -= 0.7
		update_platforms()
	if abs(fog_position - player.global_position.y) > 100 and player.global_position.y > fog_position and not game_ended:
		end_game()
	debug_fog.global_position.y = fog_position
	update_score_and_player()
func randomize_map():
	if target_y_position_in_region_1:
		region_2.global_position.y -= minimumYDistance*4
		randomize_region_2()
		target_y_position_in_region_1 = false
	else:
		region_1.global_position.y -= minimumYDistance*4
		randomize_region_1()
		target_y_position_in_region_1 = true
func randomize_region_1():
	var platform = region_1.get_child(0)
	var startplatform = region_1.get_child(1) as StaticBody2D
	startplatform.modulate.a = 1
	startplatform.position.y = 0
	startplatform.set_collision_layer_value(1,true)
	for i in range(platform.get_child_count()):
		var child = platform.get_child(i) as Node2D
		child.position.y = (i+1) * platformRepeatDistance
		child.modulate.a = 1
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		var start_color = randi_range(0,100)
		if start_color % 2 == 0:
			a.modulate = Color(0,1,1)
			a.set_collision_layer_value(2,true)
			a.set_collision_layer_value(3,false)
			a.position.x = randi_range(22,66)
			b.modulate = Color(1,0,0)
			b.set_collision_layer_value(2,false)
			b.set_collision_layer_value(3,true)
			b.position.x = randi_range(-66,-22)
		else:
			a.modulate = Color(1,0,0)
			a.set_collision_layer_value(2,false)
			a.set_collision_layer_value(3,true)
			a.position.x = randi_range(22,66)
			b.modulate = Color(0,1,1)
			b.set_collision_layer_value(2,true)
			b.set_collision_layer_value(3,false)
			b.position.x = randi_range(-66,-22)		
func randomize_region_2():
	var platform = region_2.get_child(0)
	var startplatform = region_2.get_child(1) as StaticBody2D
	startplatform.modulate.a = 1
	startplatform.position.y = 0
	startplatform.set_collision_layer_value(1,true)
	for i in range(platform.get_child_count()):
		var child = platform.get_child(i) as Node2D
		child.position.y = (i+1) * platformRepeatDistance
		child.modulate.a = 1
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		var start_color = randi_range(0,100)
		if start_color % 2 == 0:
			a.modulate = Color(0,1,1)
			a.set_collision_layer_value(2,true)
			a.set_collision_layer_value(3,false)
			a.position.x = randi_range(22,66)
			b.modulate = Color(1,0,0)
			b.set_collision_layer_value(2,false)
			b.set_collision_layer_value(3,true)
			b.position.x = randi_range(-66,-22)
		else:
			a.modulate = Color(1,0,0)
			a.set_collision_layer_value(2,false)
			a.set_collision_layer_value(3,true)
			a.position.x = randi_range(22,66)
			b.modulate = Color(0,1,1)
			b.set_collision_layer_value(2,true)
			b.set_collision_layer_value(3,false)
			b.position.x = randi_range(-66,-22)
func randomize_color_region_1():
	var platform = region_1.get_child(0)
	for i in range(platform.get_child_count()):
		var child = platform.get_child(i) as Node2D
		child.modulate.a = 1
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		var start_color = randi_range(0,100)
		if start_color % 2 == 0:
			a.modulate = Color(0,1,1)
			a.set_collision_layer_value(2,true)
			a.set_collision_layer_value(3,false)
			b.modulate = Color(1,0,0)
			b.set_collision_layer_value(2,false)
			b.set_collision_layer_value(3,true)
		else:
			a.modulate = Color(1,0,0)
			a.set_collision_layer_value(2,false)
			a.set_collision_layer_value(3,true)
			b.modulate = Color(0,1,1)
			b.set_collision_layer_value(2,true)
			b.set_collision_layer_value(3,false)	
func randomize_color_region_2():
	var platform = region_2.get_child(0)
	for i in range(platform.get_child_count()):
		var child = platform.get_child(i) as Node2D
		child.modulate.a = 1
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		var start_color = randi_range(0,100)
		if start_color % 2 == 0:
			a.modulate = Color(0,1,1)
			a.set_collision_layer_value(2,true)
			a.set_collision_layer_value(3,false)
			b.modulate = Color(1,0,0)
			b.set_collision_layer_value(2,false)
			b.set_collision_layer_value(3,true)
		else:
			a.modulate = Color(1,0,0)
			a.set_collision_layer_value(2,false)
			a.set_collision_layer_value(3,true)
			b.modulate = Color(0,1,1)
			b.set_collision_layer_value(2,true)
			b.set_collision_layer_value(3,false)
func update_platforms():
	var fogPosition = abs(fog_position)
	
	var platform1 = region_1.get_child(0)
	for i in range(platform1.get_child_count()):
		var child = platform1.get_child(i) as Node2D
		var platformPosition = abs(child.global_position.y)
		if platformPosition < fogPosition:
			var a = child.get_child(0) as StaticBody2D
			var b = child.get_child(1) as StaticBody2D
			child.position.y += platform_fall_speed
			if abs(fogPosition - platformPosition) > platform_vanish_dist:
				child.modulate.a = 0
				a.set_collision_layer_value(2, false)
				a.set_collision_layer_value(3, false)
				b.set_collision_layer_value(2, false)
				b.set_collision_layer_value(3, false)
	var startplatform1 = region_1.get_child(1) as StaticBody2D
	var startplatform1_pos = abs(startplatform1.global_position.y)
	if startplatform1_pos < fogPosition:
		startplatform1.position.y += platform_fall_speed
		if abs(fogPosition - startplatform1_pos) > platform_vanish_dist:
			startplatform1.modulate.a = 0
			startplatform1.set_collision_layer_value(1,false)
			
	var platform2 = region_2.get_child(0)
	for i in range(platform2.get_child_count()):
		var child = platform2.get_child(i) as Node2D
		var platformPosition = abs(child.global_position.y)
		if platformPosition < fogPosition:
			var a = child.get_child(0) as StaticBody2D
			var b = child.get_child(1) as StaticBody2D
			child.position.y += platform_fall_speed
			if abs(fogPosition - platformPosition) > platform_vanish_dist:
				child.modulate.a = 0
				a.set_collision_layer_value(2, false)
				a.set_collision_layer_value(3, false)
				b.set_collision_layer_value(2, false)
				b.set_collision_layer_value(3, false)
	var startplatform2 = region_2.get_child(1) as StaticBody2D
	var startplatform2_pos = abs(startplatform2.global_position.y)
	if startplatform2_pos < fogPosition:
		startplatform2.position.y += platform_fall_speed
		if abs(fogPosition - startplatform2_pos) > platform_vanish_dist:
			startplatform2.modulate.a = 0
			startplatform2.set_collision_layer_value(1,false)
			
func end_game():
	remote_transform_2d.update_position = false
	remote_transform_2d.update_rotation = false
	remote_transform_2d.update_scale = false
	fog_position -= 1
	if abs(remote_transform_2d.global_position.y)-abs(fog_position) > 500:
		player.set_process(false)
		player.set_physics_process(false)
		game_ended = true
		menu_ui.visible = true	
		region_1.visible = false
		region_2.visible = false
		player.visible = false
		score_text.visible = false
		menu_score_text.text = "SCORE: " + str(current_score)
func _on_restart_button_pressed():
	target_y_position = minimumYDistance * -3
	fog_position = 10
	target_y_position_in_region_1 = false
	fog_anchor_position = -minimumYDistance
	hasStarted = false
	region_1.position = Vector2(0,0)
	region_2.position = Vector2(0,-385)
	randomize_region_1()
	randomize_region_2()
	game_ended = false
	remote_transform_2d.update_position = true
	remote_transform_2d.update_rotation = true
	remote_transform_2d.update_scale = true
	player.set_process(true)
	player.set_physics_process(true)
	player.position = Vector2(0,-26)
	player.velocity = Vector2.ZERO
	menu_ui.visible = false
	last_y_position = player.global_position.y
	current_score = 0
	region_1.visible = true
	region_2.visible = true
	player.visible = true
	score_text.visible = true
	score_text.text = "SCORE: 0"
	menu_score_text.text = "SCORE: 0"
	set_player_red()
	player_was_in_region_1 = true
	
func update_score_and_player():
	if player.is_on_floor() and player.global_position.y < last_y_position:
		current_score = current_score + 10
		score_text.text = "SCORE: " + str(current_score)
		last_y_position = player.global_position.y
		
		# Changing sprite mechanic
		for i in range(player.get_slide_collision_count()):
			var platform = player.get_slide_collision(i)
			var platform_collider = platform.get_collider() as StaticBody2D
			if platform_collider.get_collision_layer_value(1):
				var r = randi_range(1,10)
				if r > 5:
					set_player_blue()
				else:
					set_player_red()
				if player_was_in_region_1:
					randomize_color_region_2()
					player_was_in_region_1 = false
				else:
					randomize_color_region_1()
					player_was_in_region_1 = true
				print("aaa")
				break
func set_player_blue():
	player.modulate = Color(0,1,1)
	player.set_collision_mask_value(2,true) # blue collision
	player.set_collision_mask_value(3,false) # red collision
func set_player_red():
	player.modulate = Color(1,0,0)
	player.set_collision_mask_value(2,false) # blue collision
	player.set_collision_mask_value(3,true) # red collision
