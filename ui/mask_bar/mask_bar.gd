extends Control

var is_shaking:bool = false
var flip:bool = false


func _physics_process(_delta) -> void:
	if is_shaking and Engine.get_physics_frames() % 2 == 0:
		if flip:
			position.x += 2
		else:
			position.x -= 2
		flip = false if flip else true
		get_tree().create_timer(0.5).timeout.connect(func() -> void: position.x = 0; is_shaking = false)


func _ready() -> void:
	Global.color_changed.connect(color_changed)
	Global.color_unlocked.connect(colors_unlocked)
	Global.color_blocked.connect(color_blocked)
	for child:TextureRect in $Blackouts.get_children():
		child.modulate = Color.BLACK
	for child:TextureRect in $Highlights.get_children():
		child.modulate = Color(1,1,1,0)


func color_changed() -> void:
	var count:int = 0
	for color:bool in Global.current_colors:
		if Global.current_colors[count]:
			$Highlights.get_child(count).modulate = Color.WHITE
		elif not Global.current_colors[count]:
			$Highlights.get_child(count).modulate = Color(1,1,1,0)
		count += 1


func colors_unlocked() -> void:
	var count:int = 0
	for color:bool in Global.unlocked_colors:
		if Global.unlocked_colors[count]:
			$Blackouts.get_child(count).modulate = Color(1,1,1,0)
		elif not Global.unlocked_colors[count]:
			$Blackouts.get_child(count).modulate = Color.BLACK
		count += 1


func color_blocked() -> void:
	is_shaking = true
	
