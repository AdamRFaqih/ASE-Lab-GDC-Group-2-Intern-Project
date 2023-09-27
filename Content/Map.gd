extends Node2D

@export var player : CharacterBody2D
@export var region_1 : Node2D # -385
@export var region_2 : Node2D
@export var minimumYDistance : float = 192.5
@export var platformRepeatDistance : float = -35
@export var camera : Camera2D
@export var debug_fog : Node2D
@export var menu_ui : Control
var target_y_position : float = 0
var target_y_position_in_region_1 : bool = false

# Fog Mechanic
var fog_position : float = 0
var fog_anchor_position : float = 0
var hasStarted : bool = false
var platform_vanish_time : int = 1000
var platform_fall_speed : float = 0.5
var fog_speed : float = 0.5
var has_platform_below : bool = true
var platform_time : Array[int]
var platforms : Array[StaticBody2D]

# Sprite Platform Changing Mechanic
@export var fire_platform_texture : CompressedTexture2D
@export var ice_platform_texture : CompressedTexture2D

# UI Mechanic
var game_ended : bool = false

# Scoring Mechanic
var last_y_position : float = 0
var current_score : int = 0
@export var score_text : Label
@export var menu_score_text : Label

# MUSIC & SOUND
@export var music : AudioStreamPlayer
@export var music_button : Button

# Player Sprite Changing Mechanic
var last_sprite_change_position : float = -385
var next_region_2 : bool = true

# Camera
@export var camera_follow_speed : float = 5

signal player_die

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
	last_y_position = 0
	last_sprite_change_position = -385
	next_region_2 = true
	current_score = 0
	has_platform_below = true
	var startplatform1 = region_1.get_child(1) as StaticBody2D
	platform_time.append(0)
	platforms.append(startplatform1)
	var platform1 = region_1.get_child(0)
	for i in range(platform1.get_child_count()):
		var child = platform1.get_child(i) as Node2D
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		platform_time.append(0)
		platform_time.append(0)
		platforms.append(a)
		platforms.append(b)
	var startplatform2 = region_2.get_child(1) as StaticBody2D
	platform_time.append(0)
	platforms.append(startplatform2)
	var platform2 = region_2.get_child(0)
	for i in range(platform2.get_child_count()):
		var child = platform2.get_child(i) as Node2D
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		platform_time.append(0)
		platform_time.append(0)
		platforms.append(a)
		platforms.append(b)
	game_ended = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_ended:
		if abs(camera.global_position.y + 26) < 5:
			game_ended = false
			player.set_collision_mask_value(5,false)
		camera.global_position = Vector2(0,-26)
		return
	if player.global_position.y < target_y_position:
		randomize_map()
		target_y_position = target_y_position - (minimumYDistance*2)
	if player.global_position.y < fog_anchor_position:
		fog_position = min(fog_anchor_position+165, fog_position)
		fog_anchor_position = fog_anchor_position - (minimumYDistance)
		hasStarted = true
	if player.global_position.y < last_sprite_change_position and player.is_on_floor():
		if player.get_collision_mask_value(3):
			set_player_blue()
		else:
			set_player_red()
		if next_region_2:
			next_region_2 = false
			randomize_color_region_2()
		else:
			next_region_2 = true
			randomize_color_region_1()
		last_sprite_change_position = last_sprite_change_position - 385 #nilai 390 diatur sesuai lokasi end point nya
	if hasStarted:
		fog_position -= fog_speed
		update_platforms()
	if not has_platform_below:
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
	var r = 0
	for i in range(platform.get_child_count()):
		var child = platform.get_child(i) as Node2D
		child.position.y = (i+1) * platformRepeatDistance
		child.modulate.a = 1
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		var sprite_a = a.get_child(0) as Sprite2D
		var sprite_b = b.get_child(0) as Sprite2D
		a.position.y = 0
		b.position.y = 0
		if i == 0:
			var start_color = randi_range(0,100)
			if start_color % 2 == 0:
				r = 0
				#a.modulate = Color(0,1,1)
				sprite_a.texture = ice_platform_texture
				a.set_collision_layer_value(2,true)
				a.set_collision_layer_value(3,false)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(1,0,0)
				sprite_b.texture = fire_platform_texture
				b.set_collision_layer_value(2,false)
				b.set_collision_layer_value(3,true)
				b.position.x = randi_range(-66,-22)
			else:
				r = 1
				#a.modulate = Color(1,0,0)
				sprite_a.texture = fire_platform_texture
				a.set_collision_layer_value(2,false)
				a.set_collision_layer_value(3,true)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(0,1,1)
				sprite_b.texture = ice_platform_texture
				b.set_collision_layer_value(2,true)
				b.set_collision_layer_value(3,false)
				b.position.x = randi_range(-66,-22)		
		else:
			if r == 1:
				r = 0
				#a.modulate = Color(0,1,1)
				sprite_a.texture = ice_platform_texture
				a.set_collision_layer_value(2,true)
				a.set_collision_layer_value(3,false)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(1,0,0)
				sprite_b.texture = fire_platform_texture
				b.set_collision_layer_value(2,false)
				b.set_collision_layer_value(3,true)
				b.position.x = randi_range(-66,-22)
			else:
				r = 1
				#a.modulate = Color(1,0,0)
				sprite_a.texture = fire_platform_texture
				a.set_collision_layer_value(2,false)
				a.set_collision_layer_value(3,true)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(0,1,1)
				sprite_b.texture = ice_platform_texture
				b.set_collision_layer_value(2,true)
				b.set_collision_layer_value(3,false)
				b.position.x = randi_range(-66,-22)	
func randomize_region_2():
	var platform = region_2.get_child(0)
	var startplatform = region_2.get_child(1) as StaticBody2D
	startplatform.modulate.a = 1
	startplatform.position.y = 0
	startplatform.set_collision_layer_value(1,true)
	var r = 0
	for i in range(platform.get_child_count()):
		var child = platform.get_child(i) as Node2D
		child.position.y = (i+1) * platformRepeatDistance
		child.modulate.a = 1
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		var sprite_a = a.get_child(0) as Sprite2D
		var sprite_b = b.get_child(0) as Sprite2D
		a.position.y = 0
		b.position.y = 0
		if i == 0:
			var start_color = randi_range(0,100)
			if start_color % 2 == 0:
				r = 0
				#a.modulate = Color(0,1,1)
				sprite_a.texture = ice_platform_texture
				a.set_collision_layer_value(2,true)
				a.set_collision_layer_value(3,false)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(1,0,0)
				sprite_b.texture = fire_platform_texture
				b.set_collision_layer_value(2,false)
				b.set_collision_layer_value(3,true)
				b.position.x = randi_range(-66,-22)
			else:
				r = 1
				#a.modulate = Color(1,0,0)
				sprite_a.texture = fire_platform_texture
				a.set_collision_layer_value(2,false)
				a.set_collision_layer_value(3,true)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(0,1,1)
				sprite_b.texture = ice_platform_texture
				b.set_collision_layer_value(2,true)
				b.set_collision_layer_value(3,false)
				b.position.x = randi_range(-66,-22)		
		else:
			if r == 1:
				r = 0
				#a.modulate = Color(0,1,1)
				sprite_a.texture = ice_platform_texture
				a.set_collision_layer_value(2,true)
				a.set_collision_layer_value(3,false)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(1,0,0)
				sprite_b.texture = fire_platform_texture
				b.set_collision_layer_value(2,false)
				b.set_collision_layer_value(3,true)
				b.position.x = randi_range(-66,-22)
			else:
				r = 1
				#a.modulate = Color(1,0,0)
				sprite_a.texture = fire_platform_texture
				a.set_collision_layer_value(2,false)
				a.set_collision_layer_value(3,true)
				a.position.x = randi_range(22,66)
				#b.modulate = Color(0,1,1)
				sprite_b.texture = ice_platform_texture
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
		var sprite_a = a.get_child(0) as Sprite2D
		var sprite_b = b.get_child(0) as Sprite2D
		if sprite_a.texture == fire_platform_texture:
			#a.modulate = Color(0,1,1)
			sprite_a.texture = ice_platform_texture
			a.set_collision_layer_value(2,true)
			a.set_collision_layer_value(3,false)
			#b.modulate = Color(1,0,0)
			sprite_b.texture = fire_platform_texture
			b.set_collision_layer_value(2,false)
			b.set_collision_layer_value(3,true)
		else:
			#a.modulate = Color(1,0,0)
			sprite_a.texture = fire_platform_texture
			a.set_collision_layer_value(2,false)
			a.set_collision_layer_value(3,true)
			#b.modulate = Color(0,1,1)
			sprite_b.texture = ice_platform_texture
			b.set_collision_layer_value(2,true)
			b.set_collision_layer_value(3,false)	
func randomize_color_region_2():
	var platform = region_2.get_child(0)
	for i in range(platform.get_child_count()):
		var child = platform.get_child(i) as Node2D
		child.modulate.a = 1
		var a = child.get_child(0) as StaticBody2D
		var b = child.get_child(1) as StaticBody2D
		var sprite_a = a.get_child(0) as Sprite2D
		var sprite_b = b.get_child(0) as Sprite2D
		if sprite_a.texture == fire_platform_texture:
			#a.modulate = Color(0,1,1)
			sprite_a.texture = ice_platform_texture
			a.set_collision_layer_value(2,true)
			a.set_collision_layer_value(3,false)
			#b.modulate = Color(1,0,0)
			sprite_b.texture = fire_platform_texture
			b.set_collision_layer_value(2,false)
			b.set_collision_layer_value(3,true)
		else:
			#a.modulate = Color(1,0,0)
			sprite_a.texture = fire_platform_texture
			a.set_collision_layer_value(2,false)
			a.set_collision_layer_value(3,true)
			#b.modulate = Color(0,1,1)
			sprite_b.texture = ice_platform_texture
			b.set_collision_layer_value(2,true)
			b.set_collision_layer_value(3,false)
func update_platforms():
	# check apakah masih ada platform di bawah ketika dekat fog
	has_platform_below = true
	for i in range(len(platforms)):
		if platforms[i].global_position.y > fog_position: # cek apakah platform di bawah fog
			if abs(platforms[i].global_position.y - fog_position) > 160:
				# hilangkan platform
				platform_time[i] = 0
				platforms[i].modulate.a = 0
				platforms[i].set_collision_layer_value(1, false)
				platforms[i].set_collision_layer_value(2, false)
				platforms[i].set_collision_layer_value(3, false)
				# jika player berada di bawah platform yg invisible maka tidak ada harapan lagi untuk naik ke platform atas
				if player.global_position.y > platforms[i].global_position.y:
					has_platform_below = false
			elif abs(platforms[i].global_position.y - fog_position) > 30:
				# mulai platform jatuh
				if platform_time[i] > platform_vanish_time:
					platform_time[i] = 0
					platforms[i].modulate.a = 0
					platforms[i].set_collision_layer_value(1, false)
					platforms[i].set_collision_layer_value(2, false)
					platforms[i].set_collision_layer_value(3, false)
				else:
					platform_time[i] += 1
					platforms[i].position.y += platform_fall_speed
			else:
				platform_time[i] = 0
				platforms[i].modulate.a = 1
		else:
			platform_time[i] = 0
			platforms[i].modulate.a = 1
			
func end_game():
	player.set_collision_mask_value(2,false) #fix this karena nnti sprite char berubah ketika kalah
	player.set_collision_mask_value(3,false)
	player.set_collision_mask_value(5,true) # flag for ending game
	fog_position -= 1
	if abs(camera.global_position.y-player.global_position.y) > 125:
		player.set_process(false)
		player.set_physics_process(false)
		game_ended = true
		#menu_ui.visible = true
		player_die.emit()
		#region_1.visible = false
		#region_2.visible = false
		#player.visible = false
		score_text.visible = false
		#GlobalSettings.store_score(current_score)
		menu_score_text.text = "SCORE: " + str(current_score)
		music.stop()
		SfxAutoload.play_sfx(SfxAutoload.GAME_OVER)

func update_score_and_player():
	var distance = abs(last_y_position-player.global_position.y)
	if player.is_on_floor() and player.global_position.y < last_y_position and distance > 5: # > 5 utk floating error
		current_score = current_score + (10*floori(distance/34))
		score_text.text = "SCORE: " + str(current_score)
		last_y_position = player.global_position.y
func set_player_blue():
	player.set_collision_mask_value(2,true) # blue collision
	player.set_collision_mask_value(3,false) # red collision
func set_player_red():
	player.set_collision_mask_value(2,false) # blue collision
	player.set_collision_mask_value(3,true) # red collision

func _on_music_button_pressed():
	pass
	#if music.playing:
	#	music.stop()
	#	music_button.text = "MUSIC DISABLED"
	#else:
	#	music.play()
	#	music_button.text = "MUSIC ENABLED"
	#music_button.release_focus()

