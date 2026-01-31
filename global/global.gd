extends Node

const COLOR_MAX = 2
enum Colors {RED, GREEN, BLUE, YELLOW, VIOLET}

var current_colors:Array = [false, false, false, false, false]

signal player_position
signal color_changed
signal color_blocked


func _input(_event:InputEvent) -> void:
	if _event is InputEventKey:
		if _event.is_action_pressed('toggle_red'):
			toggle_color(Colors.RED)
		if _event.is_action_pressed('toggle_green'):
			toggle_color(Colors.GREEN)
		if _event.is_action_pressed('toggle_blue'):
			toggle_color(Colors.BLUE)
		if _event.is_action_pressed('toggle_yellow'):
			toggle_color(Colors.YELLOW)
		if _event.is_action_pressed('toggle_violet'):
			toggle_color(Colors.VIOLET)


func toggle_color(_color:Colors) -> void:
	print('toggling %s' % Colors.keys()[_color])
	var color_count:int = 0
	for color:bool in current_colors:
		if color:
			color_count += 1
			
	if color_count >= COLOR_MAX:
		# If there are two colors active, don't activate a new one
		if not current_colors[_color]:
			color_blocked.emit()
		# Otherwise, the color is activated
		else:
			current_colors[_color] = false;
	# If the colors are not at the max, then just toggle it
	else:
		current_colors[_color] = !current_colors[_color]
		
	color_changed.emit()
	print('current colors: %s' % str(current_colors))
