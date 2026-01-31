extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(_delta:float) -> void:
	if Input.is_action_pressed('left'):
		position -= Vector2(-1, 0)
	if Input.is_action_just_pressed('right'):
		position -= Vector2(1, 0)
		
