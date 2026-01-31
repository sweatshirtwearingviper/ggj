extends CharacterBody2D
class_name PlayerEasyControl

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var double_jumped:bool = false

@onready var sprite:Sprite2D = $Character


func _ready() -> void:
	Global.color_changed.connect(color_changed)
	
	# Get the sprite's child animation node and play it here
	var animations:AnimationPlayer = sprite.get_node('AnimationPlayer')
	animations.current_animation = 'Idle'


func _physics_process(delta: float) -> void:
	Global.player_position.emit(position)
	
	# Add the gravity. Flip gravity when blue
	if not is_on_floor():
		if Global.current_colors[Global.Colors.BLUE]:
			velocity -= get_gravity() * delta
		else:
			velocity += get_gravity() * delta
	else:
		# Reset double jump when on ground
		double_jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("up"):
		if Global.current_colors[Global.Colors.GREEN]:
			velocity.y = JUMP_VELOCITY
			double_jumped = true
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		# Handle sprite facing direction
		if direction > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func color_changed() -> void:
	var count:int = 1
	for color:bool in Global.current_colors:
		set_collision_layer_value(count, !color)
		set_collision_mask_value(count, !color)
		count += 1
		
	
