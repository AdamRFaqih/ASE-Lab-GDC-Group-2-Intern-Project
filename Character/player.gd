extends CharacterBody2D # Nama Lain dari KinematicBody2D kayaknya 

# Properti Karakter
@export var max_speed : float = 500.0
@export var speed : float = 15.0
@export var friction_speed : float = 5.0
@export var bounciness : float = 1.0
@export var max_bounce_speed : float = 500.0
@export var jump_velocity : float = -500.0
@export var run_to_jump_boost : float = 0.637
# Collision disabling untuk menghindari stuck di tepi platform
# value = 60 = 1 detik delay
# value = 8 = 8/60 detik delay
#@export var invalid_collision_delay : int = 8 
#var current_invalid_collision_frame = 1

# Animasi
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO # Arah pergerakan, positif = kanan, negatif = kiri
var friction : float = 0.0  # gaya gesek
var isJumping : bool = false
var bounce_power : float = 0.0

func _ready():
	velocity = Vector2.ZERO
	bounce_power = 0.0
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		isJumping = true
		# kalau 0 artinya tidak ada pengurangan akselerasi di udara (ga ada gaya gesek),
		# mungkin ini salah tapi kurang tahu juga, maaf saya ga paham fisika
		friction = 0
	else:
		isJumping = false
		friction = friction_speed # friction = gaya gesek

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity.x = clampf(velocity.x + (speed * direction.x), -max_speed, max_speed)
	# gaya gesek
	if velocity.x > 0:
		velocity.x = max(velocity.x - friction, 0)
	elif velocity.x < 0:
		velocity.x = min(velocity.x + friction, 0);	
		
	bounce_power = clampf(bounce_power + (speed * abs(direction.x)), 0, max_speed)
	bounce_power = clampf(bounce_power - ((speed + friction)/2), 0, max_speed)
	# Cek wall dan tepi platform
	# Layer 2 digunakan untuk platform
	# Layer 1 digunakan untuk dinding
#	if is_on_wall():
#		for i in range(get_slide_collision_count()):
#			var collision = get_slide_collision(i)
#			var collider = collision.get_collider()
#			if collider is StaticBody2D:
#				if collider.get_collision_layer_value(2):
#					set_collision_mask_value(2,false)
#					isJumping = true
#				else:
#					velocity.x = clampf(velocity.x + (bounciness * collision.get_normal().x), -speed, speed)
	handle_wall_bounce()
	move_and_slide()
	update_animation()
	update_rotation()
	#handle_invalid_collision()
	#print(velocity)
func update_animation():
	if direction.x != 0:
		if isJumping:
			animated_sprite.play("run_to_jump_low")
		else:
			animated_sprite.play("run")
	else:
		if isJumping:
			animated_sprite.play("run_to_jump_low")
		else:
			animated_sprite.play("idle")
func update_rotation():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
func jump():
	velocity.y = jump_velocity + (abs(velocity.x * run_to_jump_boost) * -1)
func handle_wall_bounce():
	if is_on_wall():
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is StaticBody2D:
				if not collider.get_collision_layer_value(2):
					velocity.x = clampf(velocity.x + (bounce_power * bounciness * collision.get_normal().x),-max_bounce_speed,max_bounce_speed)
					bounce_power = 0.0
					break

#func handle_invalid_collision():
#	# Frame skip / delay
#	if not get_collision_mask_value(2):
#		if current_invalid_collision_frame >= invalid_collision_delay:
#			current_invalid_collision_frame = 1
#			set_collision_mask_value(2,true)
#		else:
#			current_invalid_collision_frame += 1
#	else:
#		current_invalid_collision_frame = 1
