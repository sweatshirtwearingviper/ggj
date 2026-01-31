## When the player touches this, runs the player's dash ability next frame
extends Area2D

# For "Export Flags" the int will be a power of 2 i.e. 2, 4, 6, 8, 16
@export_flags("Red", "Green", "Blue", "Yellow", "Black") var mask_color:int = 0


func _ready() -> void:
	body_entered.connect(dash)

	if mask_color == 0:
		set_collision_layer_value(8, true)
		set_collision_mask_value(8, true)
	else:
		Global.color_changed.connect(color_changed)


func dash(_body:Node2D) -> void:
	if not is_instance_valid(telepoint):
		printerr('%s cannot teleport! No telepoint destination defined.' % self)
		return
	if _body is PlayerEasyControl:
		_body.teleported.emit()
		_body.position = telepoint.position


func color_changed() -> void:
	print(mask_color)
	var count:int = 0
	for color:bool in Global.current_colors:
		if int(pow(2, count)) == mask_color and color:
			$Sprite2D.modulate = Color(1, 1, 1, 0.2)
			set_collision_layer_value(count + 1, false)
			set_collision_mask_value(count + 1, false)
		elif int(pow(2, count)) == mask_color and not color:
			$Sprite2D.modulate = Color(1, 1, 1, 1)
			set_collision_layer_value(count + 1, true)
			set_collision_mask_value(count + 1, true)
		count += 1
