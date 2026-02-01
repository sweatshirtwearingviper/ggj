extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.pressed.connect(hide)
	$Center/TitleScreen_anim/AnimationPlayer.current_animation = 'titleScreen_animation'
