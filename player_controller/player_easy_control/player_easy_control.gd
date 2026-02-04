extends CharacterBody2D
class_name PlayerEasyControl

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var double_jumped:bool = false
var is_smashing:bool = false
var can_dash:bool = true
var is_dashing:bool = false
var is_bouncing:bool = false

@onready var sprite:AnimatedSprite2D = $MaskSpritesheets

signal teleported ## Emits when the player is teleported. One string is passed in to determine what teleported it (spikes, end of level, etc)

func _ready() -> void:
	Global.color_changed.connect(color_changed)
	sprite.play('none')


func _physics_process(delta: float) -> void:
	Global.player_position.emit(position)

	if is_dashing:
		velocity.x = JUMP_VELOCITY * 2.5 * (1 if sprite.flip_h else -1)
		get_tree().create_timer(0.2).timeout.connect(func() -> void: can_dash = true; is_dashing = false)

	# Add the gravity. Flip gravity when blue
	if is_on_floor():
		double_jumped = false
		is_smashing = false
	else:
		$FloatParticlesLeft.emitting = false
		$FloatParticlesRight.emitting = false
	# Reset double jump when on ground
		if Global.current_colors[Global.Colors.BLUE]:
			velocity -= get_gravity() / 2 * delta
		else:
			velocity += get_gravity() * delta

	# GREEN handle bounce pads
	if is_bouncing:
		velocity.y = JUMP_VELOCITY
		is_bouncing = false

	# Handle jump and green doublejump
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif Global.current_colors[Global.Colors.GREEN] and not double_jumped:
			velocity.y = JUMP_VELOCITY
			double_jumped = true

	# Red smasha
	if Input.is_action_just_pressed("down"):
		if Global.current_colors[Global.Colors.RED] and not is_on_floor():
			velocity.y = -JUMP_VELOCITY * 2
			velocity.x = 0
			is_smashing = true

	if Input.is_action_just_pressed("dash"):
		if Global.current_colors[Global.Colors.YELLOW] and can_dash:
			is_dashing = true
			can_dash = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction and not is_dashing:
		velocity.x = direction * SPEED
		# Handle sprite facing direction
		if direction > 0:
			if is_on_floor():
				$FloatParticlesLeft.emitting = false
				$FloatParticlesRight.emitting = true
			sprite.flip_h = false
		else:
			if is_on_floor():
				$FloatParticlesLeft.emitting = true
				$FloatParticlesRight.emitting = false
			sprite.flip_h = true
	else:
		$FloatParticlesLeft.emitting = false
		$FloatParticlesRight.emitting = false
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func color_changed() -> void:
	var count:int = 0
	# Collision layers 1, 2, 3, 4, and 5 correspond to the colors
	for color:bool in Global.current_colors:
		count += 1
		set_collision_layer_value(count, !color)
		set_collision_mask_value(count, !color)

	# Read the current_colors array from left to right to find the left color.
	# Then, read from right to find the right color.
	# If the left color never finds an active color, 'none' animation is played.
	var first_color:String = 'none'
	for i:int in Global.current_colors.size():
		if Global.current_colors[i]:
			first_color = Global.Colors.keys()[i]

	if first_color == 'none':
		sprite.animation = 'none'
		return

	var second_color:String = ''
	for i:int in Global.current_colors.size():
		if Global.current_colors[Global.current_colors.size() - (i + 1)]:
			second_color = Global.Colors.keys()[Global.current_colors.size() - (i + 1)]

	sprite.animation = '%s_%s' % [first_color.to_lower(), second_color.to_lower()]
