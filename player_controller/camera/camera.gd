extends Camera2D


func _ready() -> void:
	Global.player_position.connect(func(_pos:Vector2) -> void: position = _pos)
