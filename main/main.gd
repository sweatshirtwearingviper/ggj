extends Node

var levels = 5

func _ready() -> void:
	for i:int in 4:
		var this_level = $Levels.get_child(i)
		var next_level = $Levels.get_child(i + 1)
		print('this level: ' + str(this_level))
		print('next level: ' + str(next_level))
		
		var spawn:Marker2D
		if next_level.has_node('Spawn'):
			spawn = next_level.get_node('Spawn')
		else:
			print('This level does not have a spawn %s' % next_level)
			return
		
		if this_level.has_node('Gravestone'):
			this_level.get_node('Gravestone').telepoint = spawn
			print(spawn.get_parent())
		else:
			print('This level does not have a gravestone %s' % this_level)
			return
			
