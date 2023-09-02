extends CharacterBody2D

signal die

@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer

const SPEED = 500.0
const JUMP_VELOCITY = -1200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * 2.5

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	animation(direction)

	move_and_slide()

func animation(direction):
	if not direction: pass
	else: sprite_2d.flip_h = direction > 0

func _on_visible_on_screen_notifier_2d_screen_exited():
	timer.start()
	await timer.timeout
	die.emit()
