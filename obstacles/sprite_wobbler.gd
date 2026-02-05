## This wobbles whatever Node2D it is attached to

extends Node2D

@onready var origin:Vector2 = position

@export var distance:Vector2 = Vector2(0, 2) ## The maximum distance the sprite will wobble.
@export var speed:float = 1.0 ## The speed the sprite will wobble at.
@export var progress:float = 0.0 ## Set this to a different starting value to offset.


func _process(_delta:float) -> void:
	if distance:
		progress = wrapf(progress, 0.0, 1.0)
		progress += _delta * speed
		position = origin + Vector2(distance.x * cos(progress * TAU), distance.y * sin(progress * TAU))
