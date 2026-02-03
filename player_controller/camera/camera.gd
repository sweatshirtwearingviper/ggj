extends Camera2D

@export var cam_y_offset:float = 0
@export var max_y:float = -540.0 / 2.0
@export var min_y:float = (-32.0 * 32.0) + (540.0 / 2.0)
@export var max_x:float = (256.0 * 32.0) - (720.0 / 2.0)
@export var min_x:float = 720.0 / 2.0

var player_position:Vector2 = Vector2.ZERO


func _ready() -> void:
	Global.player_position.connect(func(_pos:Vector2) -> void: player_position = _pos)
	Global.camera_offset.connect(func() -> void: cam_y_offset += -2048.0)


func _physics_process(delta: float) -> void:
	#position = player_position
	#pass
	position = Vector2(clampf(player_position.x, min_x, max_x),
					   clampf(player_position.y, min_y + cam_y_offset, max_y  + cam_y_offset))
