## When the player touches this, runs the player's dash ability next frame
extends Area2D

# For "Export Flags" the int will be a power of 2 i.e. 2, 4, 6, 8, 16
@export_flags("Red", "Green", "Blue", "Yellow", "Black") var mask_color:int = 0


func _ready() -> void:
	body_entered.connect(jump)
	$Sprite2D.modulate = Color(1, 1, 1, 0.2)

	if mask_color == 0:
		set_collision_layer_value(8, true)
		set_collision_mask_value(8, true)
	else:
		Global.color_changed.connect(color_changed)


func jump(_body:Node2D) -> void:
	if _body is PlayerEasyControl:
		_body.is_dashing = true


func color_changed() -> void:
	print(mask_color)
	var count:int = 0
	for color:bool in Global.current_colors:
		if int(pow(2, count)) == mask_color and color:
			$Sprite2D.modulate = Color(1, 1, 1, 1)
			set_collision_layer_value(count + 1, true)
			set_collision_mask_value(count + 1, true)
		elif int(pow(2, count)) == mask_color and not color:
			$Sprite2D.modulate = Color(1, 1, 1, 0.2)
			set_collision_layer_value(count + 1, false)
			set_collision_mask_value(count + 1, false)
		count += 1
