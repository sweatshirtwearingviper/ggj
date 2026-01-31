extends Area2D

@export var telepoint:Marker2D


func _ready() -> void:
	body_entered.connect(teleport)


func teleport(_body:Node2D) -> void:
	if _body is PlayerEasyControl:
		_body.position = telepoint.position
