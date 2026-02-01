extends Node

const COLOR_MAX = 2
enum Colors {RED, GREEN, BLUE, YELLOW, BLACK}

var current_colors:Array = [false, false, false, false, false]
var unlocked_colors:Array = [false, false, false, false, false]

var mask_collect_dialogues:Array = [
	PackedStringArray([
		"HEY. PUT ME DOWN!",
	]),
	PackedStringArray([
		"Hi!!! I'm so happy to see you!!",
	]),
	PackedStringArray([
		"Oh....",
	]),
	PackedStringArray([
		"Who are you?!",
	]),
	PackedStringArray([
		":)",
	]),
]
var mask_equipped_dialogues:Array = [
	PackedStringArray([
		"I'M WARNING YOU!!!",
		"LET GO OF ME!",
		"I DON'T DESERVE THIS",
	]),
	PackedStringArray([
		"Who are you, by the way?",
		"Whee!!",
		"How fun!",
	]),
	PackedStringArray([
		"I'm so disoriented...",
		"This doesn't feel right...",
		"Where'd the ground go..?",
	]),
	PackedStringArray([
		"Help me!",
		"Where am I?!",
		"Run Away!",
	]),
	PackedStringArray([
		":]",
		":D",
		":3",
	]),
]
var mask_unequip_dialogue:Array = [
	PackedStringArray([
		"RUDE!",
	]),
	PackedStringArray([
		"Oh! Byebye!",
	]),
	PackedStringArray([
		"goodbye...",
	]),
	PackedStringArray([
		"I'm sorry...",
	]),
	PackedStringArray([
		":(",
	]),
]

@export var black_mask_time:float = 1.0 ## Delay between black mask switching
var black_mask_index:int = 0 ## Tracks which mask should be active when black mask is used
var last_black_mask_index:int = 3 ## The previous mask that was on should be toggled off

signal player_position
signal color_changed
signal color_blocked
signal color_unlocked
signal color_locked
signal colors_cleared

signal send_dialogue
signal clear_dialogue


func _ready() -> void:
	$DialogueTimer.timeout.connect(clear_dialogue.emit)
	$Timer.timeout.connect(move_mask)
	$Red.play()
	$Green.play()
	$Blue.play()
	$Yellow.play()


func _input(_event:InputEvent) -> void:
	# If the current worn mask is black, block mask input 
	if current_colors[Colors.BLACK]:
		color_locked.emit()
		return
	if _event is InputEventKey:
		if _event.is_action_pressed('toggle_red'):
			toggle_color(Colors.RED)
		if _event.is_action_pressed('toggle_green'):
			toggle_color(Colors.GREEN)
		if _event.is_action_pressed('toggle_blue'):
			toggle_color(Colors.BLUE)
		if _event.is_action_pressed('toggle_yellow'):
			toggle_color(Colors.YELLOW)
		if _event.is_action_pressed('toggle_black'):
			toggle_color(Colors.BLACK)


func toggle_color(_color:Colors) -> void:
	print('toggling %s' % Colors.keys()[_color])
	
	# The player doesn't have the color yet, no toggle allowed
	if not unlocked_colors[_color]:
		color_locked.emit()
		return
	
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
		
	if current_colors[_color]:
		dialogue_parse_and_send(mask_equipped_dialogues, _color)
		unmute_color(wrapi(_color, 0, 4))
	else:
		dialogue_parse_and_send(mask_unequip_dialogue, _color)
		mute_color(wrapi(_color, 0, 4))
		
	color_changed.emit()
	print('current colors: %s' % str(current_colors))


func gain_color(_color:Colors) -> void:
	# Color already unlocked, don't process
	if unlocked_colors[_color]:
		return
	
	dialogue_parse_and_send(mask_collect_dialogues, _color)
	unlocked_colors[_color] = true
	color_unlocked.emit()
	
	if unlocked_colors[Colors.BLACK]:
		start_black_mask()


func clear_colors() -> void:
	stop_black_mask()
	for i:int in unlocked_colors.size():
		unlocked_colors[i] = false
	print('unlocked colors: %s' % str(unlocked_colors))
	colors_cleared.emit()
	pass
	

func start_black_mask() -> void:
	for i:int in current_colors.size():
		current_colors[i] = false
	toggle_color(Colors.BLACK)
	toggle_color(Colors.YELLOW)
	last_black_mask_index = 3
	black_mask_index = 0
	$Timer.wait_time = black_mask_time
	$Timer.start()
	
	
func stop_black_mask() -> void:
	for i:int in current_colors.size():
		current_colors[i] = false
		mute_color(wrapi(i, 0, 4))
	print('current colors: %s' % str(current_colors))
	$Timer.stop()
	pass


func move_mask() -> void:
	if black_mask_index == 0:
		$Bell.play()
	else:
		$Tick.play()
	toggle_color(last_black_mask_index)
	toggle_color.call_deferred(black_mask_index)
	last_black_mask_index = black_mask_index
	black_mask_index = wrapi(black_mask_index + 1, 0, 4)


func dialogue_parse_and_send(_array:Array, _color:Colors) -> void:
	# If black mask is equipped, just override the color
	if current_colors[Colors.BLACK]:
		_color = Colors.BLACK
	send_dialogue.emit(_array[_color][randi_range(0, _array[_color].size() - 1)])
	$DialogueTimer.start()


func mute_color(_color:Colors) -> void:
	var offset:int = 2
	AudioServer.set_bus_mute(offset + _color, true)
	
	
func unmute_color(_color:Colors) -> void:
	var offset:int = 2
	AudioServer.set_bus_mute(offset + _color, false)
