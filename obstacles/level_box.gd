## Gets the parent's Spawn node and connects the killplanes to it.
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn:Marker2D = get_parent().get_node('Spawn')
	
	for child:Node in get_children():
		if child is Teleporter:
			child.telepoint = spawn
