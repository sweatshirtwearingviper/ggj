# If the red mask is active and the player is smashing, break hide and make the blocks intangible

extends RigidBody2D
class_name SmashBlock

signal smashed


func _ready() -> void:
	$Area2D.body_entered.connect(smash)


func smash(_body:Node2D) -> void:
	if _body is PlayerEasyControl:
		if _body.is_smashing:
			hide()
			set_collision_layer_value(8, false)
			set_collision_mask_value(8, false)
			smashed.emit()
			
	
