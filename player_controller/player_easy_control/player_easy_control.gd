extends CharacterBody2D
class_name PlayerEasyControl

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var double_jumped:bool = false
var is_smashing:bool = false
var can_dash:bool = true
var is_dashing:bool = false
var is_bouncing:bool = false
var is_dead:bool = false
var turned_off_particles:bool = false

@onready var sprite:AnimatedSprite2D = $MaskSpritesheets


func _ready() -> void:
	Global.color_changed.connect(color_changed)
	sprite.play('none')


func _physics_process(delta: float) -> void:
	Global.player_position.emit(position)

	if is_dead:
		if not turned_off_particles:
			turned_off_particles = true
			for child:Node in get_children():
				if child is GPUParticles2D and child.name != 'TeleportParticles':
					child.emitting = false
		velocity = Vector2.ZERO
		return

	if is_dashing:
		# HACK Get the direction in the most cursed way possible
		var sprite_face:int = 0
		if not $DashSound.playing:
			$DashSound.play()
		if sprite.flip_h:
			sprite_face = 1
			$DashParticlesLeft.emitting = true
		else:
			sprite_face = -1
			$DashParticlesRight.emitting = true
		velocity.x = JUMP_VELOCITY * 2.5 * sprite_face
		get_tree().create_timer(0.2).timeout.connect(func() -> void:
			can_dash = true
			is_dashing = false
			$DashParticlesLeft.emitting = false
			$DashParticlesRight.emitting = false
			)

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
		$JumpSound.play()
		velocity.y = JUMP_VELOCITY
		is_bouncing = false
		double_jumped = false

	# Handle jump and green doublejump
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			$JumpSound.play()
			velocity.y = JUMP_VELOCITY
		elif Global.current_colors[Global.Colors.GREEN] and not double_jumped:
			$JumpSound.play()
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
	# Black is special and doesn't disable the players collision
	for color:bool in Global.current_colors:
		if count == Global.Colors.BLACK:
			continue
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


func teleport(_position:Vector2, _time:bool = false, _is_dead:bool = false):
	$TeleportParticles.emitting = true
	sprite.modulate = Color(1,1,1,0)
	is_dead = _is_dead

	# Returns player to controllable state at teleported point
	var reset:Callable = func() -> void:
		turned_off_particles = false
		$TeleportParticles.emitting = false
		sprite.modulate = Color(1,1,1,1)
		is_dead = false
		position = _position

	if is_zero_approx(_time):
		reset.call()
	else:
		get_tree().create_timer(_time).timeout.connect(reset)
