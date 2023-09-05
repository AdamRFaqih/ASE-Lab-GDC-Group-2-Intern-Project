extends CharacterBody2D # Nama Lain dari KinematicBody2D kayaknya 

# Properti Karakter
@export var max_speed : float = 500.0
@export var speed : float = 15.0
@export var friction_speed : float = 5.0
@export var bounciness : float = 1.0
@export var max_bounce_speed : float = 500.0
@export var jump_velocity : float = 500.0
@export var run_to_jump_boost : float = 0.637

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

func _ready():
	velocity = Vector2.ZERO
	bounce_power = 0.0
	jump_power = 0.0

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
					break
func update_animation():
	if direction.x != 0:
		if isJumping:
			animated_sprite.play("c_jump")
		else:
			animated_sprite.play("c_run")
	else:
		if isJumping:
			animated_sprite.play("c_jump")
		else:
			animated_sprite.play("c_idle")
func update_rotation():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
