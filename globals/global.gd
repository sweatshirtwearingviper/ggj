extends Node
class_name Global

const COLOR_MAX = 2
enum Colors {RED, BLUE, GREEN, YELLOW, VIOLET}

var current_colors:Array = [false, false, false, false, false]

signal color_changed
signal color_blocked

func toggle_color(_color:Colors) -> void:
	var color_count:int = 0
	for color:bool in current_colors:
		if color:
			color_count += 1
			
	if color_count >= COLOR_MAX:
		# If there are two colors active, don't activate a new one
		if current_colors[_color] == false:
			color_blocked.emit()
			return
		# Otherwise, the color is activated
		else:
			current_colors[_color] = true;
	# If the colors are not at the max, then just toggle it
	else:
		current_colors[_color] = !current_colors[_color]
		
	color_changed.emit()
