extends CharacterBody2D # Nama Lain dari KinematicBody2D kayaknya 

# Properti Karakter
@export var max_speed : float = 150
@export var speed : float = 15
@export var friction_speed : float = 10
@export var bounciness : float = 1
@export var max_bounce_speed : float = 500
@export var jump_velocity : float = 350
@export var run_to_jump_boost : float = 1

# Animasi
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO # Arah pergerakan, positif = kanan, negatif = kiri
var friction : float = 0.0  # gaya gesek
var isJumping : bool = false
var bounce_power : float = 0.0
var jump_power : float = 0.0

# TILEMAP SUPPORT
const TILE_WALL = 0
@export var tilemap : TileMap

# SPRITE CHANGING
var is_red : bool = true

# KAMERA
@export var camera : Node2D
@export var camera_follow_speed : float = 5

func _ready():
	velocity = Vector2.ZERO
	bounce_power = 0.0
	jump_power = 0.0
	debuglabel.text = "Move Speed: " + str(speed) + "\n" + "Friction Speed: " + str(friction_speed) + "\n" + "Bounciness: " + str(bounciness) + "\n" + "Jump Velocity: " + str(jump_velocity) + "\n" + "Run to jump boost: " + str(run_to_jump_boost)

func _physics_process(delta):
	update_input()
	update_gravity(delta)
	update_jump()
	update_movement()
	update_friction()
	update_wall_bounce()
	move_and_slide()
	update_animation()
	update_rotation()
	update_camera(delta)
	update_speed_mechanic()
	
func update_input():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
func update_gravity(delta):
	# lompat makin tinggi jika jalannya makin cepat
	jump_power = clampf(jump_power + (speed * direction.x), -jump_velocity, jump_velocity)
	if jump_power > 0:
		jump_power = max(jump_power - ((speed + friction)/2), 0)
	elif jump_power < 0:
		jump_power = min(jump_power + ((speed + friction)/2), 0)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		isJumping = true
		# kalau 0 artinya tidak ada pengurangan akselerasi di udara (ga ada gaya gesek),
		# mungkin ini salah tapi kurang tahu juga, maaf saya ga paham fisika
		friction = 0
		jump_power = 0
	else:
		isJumping = false
		friction = friction_speed # friction = gaya gesek
func update_jump():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = (jump_velocity + abs(jump_power * run_to_jump_boost)) * -1
		jump_power = 0.0
		SfxAutoload.play_sfx(SfxAutoload.JUMP)
func update_movement():
	velocity.x = clampf(velocity.x + (speed * direction.x), -max_speed, max_speed)
func update_friction():
	# gaya gesek
	if velocity.x > 0:
		velocity.x = max(velocity.x - friction, 0)
	elif velocity.x < 0:
		velocity.x = min(velocity.x + friction, 0);	
func update_wall_bounce():
	if is_on_floor():
		bounce_power = clampf(bounce_power + (speed * direction.x), -max_speed, max_speed)
		if bounce_power > 0:
			bounce_power = max(bounce_power - ((speed + friction)/2), 0)
		elif bounce_power < 0:
			bounce_power = min(bounce_power + ((speed + friction)/2), 0)
	# wall bounce untuk non tilemap
	if is_on_wall():
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is StaticBody2D:
				if not collider.get_collision_layer_value(2):
					velocity.x = clampf(velocity.x + (abs(bounce_power) * bounciness * collision.get_normal().x),-max_bounce_speed,max_bounce_speed)
					bounce_power = 0
					SfxAutoload.play_sfx(SfxAutoload.BOUNCE)
					break
func update_animation():
	if not get_collision_mask_value(5):
		is_red = get_collision_mask_value(3)
	if direction.x != 0:
		if isJumping:
			if is_red:
				animated_sprite.play("fire_jump")
			else:
				animated_sprite.play("ice_jump")
		else:
			if is_red:
				animated_sprite.play("fire_walk")
			else:
				animated_sprite.play("ice_walk")
	else:
		if isJumping:
			if is_red:
				animated_sprite.play("fire_jump")
			else:
				animated_sprite.play("ice_jump")
		else:
			if is_red:
				animated_sprite.play("fire_idle")
			else:
				animated_sprite.play("ice_idle")
func update_rotation():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
func update_camera(delta):
	if (get_collision_mask_value(3) or get_collision_mask_value(2)) and not get_collision_mask_value(5):
		camera.position.y = lerpf(camera.global_position.y,global_position.y,camera_follow_speed*delta)
		
@export var max_normal_speed : float = 25
@export var min_friction_speed : float = 1
@export var max_bounciness : float = 3
@export var max_jump_velocity : float = 500
@export var max_run_to_jump_boost : float = 2
@export var debuglabel : Label
func update_speed_mechanic():
	if get_collision_mask_value(6):
		set_collision_mask_value(6,false)
		speed = clampf(speed + 0.3, speed, max_normal_speed)
		friction_speed = clampf(friction_speed - 0.3, min_friction_speed, friction_speed)
		bounciness = clampf(bounciness + 0.1, bounciness, max_bounciness)
		jump_velocity = clampf(jump_velocity + 5, jump_velocity, max_jump_velocity)
		run_to_jump_boost = clampf(run_to_jump_boost + 0.1, run_to_jump_boost, max_run_to_jump_boost)
		debuglabel.text = "Move Speed: " + str(speed) + "\n" + "Friction Speed: " + str(friction_speed) + "\n" + "Bounciness: " + str(bounciness) + "\n" + "Jump Velocity: " + str(jump_velocity) + "\n" + "Run to jump boost: " + str(run_to_jump_boost)
