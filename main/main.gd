extends Node

var levels = 5

func _ready() -> void:
	for i:int in levels - 1:
		var this_level = $Levels.get_child(i)
		var next_level = $Levels.get_child(i + 1)
		
		if this_level.has_node('Gravestone'):
			this_level.get_node('Gravestone')
			
