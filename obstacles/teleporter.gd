## Teleports the player to an assigned marker node. Click the "Assign..." button next to the
## Telepoint property in the inspector, and select a currently present Marker2D node in the scene.
extends Area2D
class_name Teleporter

@export var telepoint:Marker2D

# For "Export Flags" the int will be a power of 2 i.e. 2, 4, 6, 8, 16
@export var level_end:bool = false ## If true, clears the player's collected masks
@export var offset_camera:bool = false ## If true, offsets the camera restrictions to the next level
@export var kills_player:bool = false ## If true, makes the player wait 1 second to teleport and gain access to controls again
@export_flags("Red", "Green", "Blue", "Yellow", "Black") var mask_color:int = 0


func _ready() -> void:
	if has_node('AnimatedSprite2D'):
		$AnimatedSprite2D.play('default')
	if has_node('Portal'):
		$Portal/AnimationPlayer.play('Portal_Idle')
	body_entered.connect(teleport)

	if level_end:
		body_entered.connect(func(_body:Node2D) -> void: if _body is PlayerEasyControl: Global.clear_colors())
	if offset_camera:
		body_entered.connect(func(_body:Node2D) -> void: if _body is PlayerEasyControl: Global.camera_offset.emit())


	if mask_color == 0:
		set_collision_layer_value(8, true)
		set_collision_mask_value(8, true)
	else:
		Global.color_changed.connect(color_changed)


func teleport(_body:Node2D) -> void:
	if has_node('Portal'):
		$Portal/AnimationPlayer.play('Portal_Warp')
		$Portal/AnimationPlayer.animation_finished.connect(func(_name:String) -> void: if _name == 'Portal_Warp': $Portal/AnimationPlayer.play('Portal_Warp'))
	if not is_instance_valid(telepoint):
		printerr('%s cannot teleport! No telepoint destination defined.' % self)
		return
	if _body is PlayerEasyControl:
		_body.teleport(telepoint.global_position, 1.0 if kills_player else 0.0, kills_player)


func color_changed() -> void:
	var count:int = 0
	for color:bool in Global.current_colors:
		if int(pow(2, count)) == mask_color and color:
			if has_node('Portal'):
				$Portal.modulate = Color(1, 1, 1, 0.2)
			elif has_node('Sprite2D'):
				$Sprite2D.modulate = Color(1, 1, 1, 0.2)
			set_collision_layer_value(count + 1, false)
			set_collision_mask_value(count + 1, false)
		elif int(pow(2, count)) == mask_color and not color:
			if has_node('Portal'):
				$Portal.modulate = Color(1, 1, 1, 1)
			elif has_node('Sprite2D'):
				$Sprite2D.modulate = Color(1, 1, 1, 1)
			set_collision_layer_value(count + 1, true)
			set_collision_mask_value(count + 1, true)
		count += 1
