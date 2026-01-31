## When touched, the player collects the mask and can use it

extends Area2D
class_name Mask

# For "Export Flags" the int will be a power of 2 i.e. 2, 4, 6, 8, 16
@export_flags("Red", "Green", "Blue", "Yellow", "Black") var mask_color:int = 0


func _ready() -> void:
	body_entered.connect(gain_mask)


func gain_mask(_body:Node2D) -> void:
	# Why do export flags need to use powers of two smh
	if _body is PlayerEasyControl:
		Global.gain_color(int(log(mask_color) / log(2)))
		modulate = Color(1, 1, 1, 0)
	
