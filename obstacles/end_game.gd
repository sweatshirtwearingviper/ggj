extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(func(_body:Node2D) -> void: if _body is PlayerEasyControl: get_tree().quit())
