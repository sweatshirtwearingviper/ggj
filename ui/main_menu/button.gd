extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(func() -> void: modulate = Color.BLACK; $Hover.play())
	mouse_exited.connect(func() -> void: modulate = Color.WHITE)
