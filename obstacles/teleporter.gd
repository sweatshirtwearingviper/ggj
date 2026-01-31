extends Area2D

@export var telepoint:Marker2D


func _ready() -> void:
	area_entered.connect(teleport)


func teleport() -> void:
