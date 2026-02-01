extends Camera2D

@export var cam_y_offset:float = 0
@export var max_y:float = -272
@export var min_y:float = -752
@export var max_x:float = 0
@export var min_x:float = 0

var player_position:Vector2 = Vector2.ZERO


func _ready() -> void:
	Global.player_position.connect(func(_pos:Vector2) -> void: player_position = _pos)


func _physics_process(delta: float) -> void:
	position = Vector2(player_position.x, clampf(player_position.y, min_y + cam_y_offset, max_y  + cam_y_offset))
