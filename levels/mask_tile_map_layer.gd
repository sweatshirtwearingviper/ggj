## This script handles the visual appearance and dissapearance of this TileMapLayer
## by connecting to the global color_changed signal and checking if Global's
## current_colors has its color as true. If true, it shows itself. If false,
## it hides.

extends TileMapLayer
class_name MaskTileMapLayer

# For "Export Flags" the int will be a power of 2 i.e. 2, 4, 6, 8, 16
@export_flags("Red", "Green", "Blue", "Yellow", "Violet") var mask_color:int = 32


func _ready() -> void:
	Global.color_changed.connect(color_changed)
	
	
func color_changed() -> void:
	var count:int = 0
	for color:bool in Global.current_colors:
		if int(pow(2, count)) == mask_color and color:
			modulate = Color(1, 1, 1, 0.2)
		elif int(pow(2, count)) == mask_color and not color:
			modulate = Color(1, 1, 1, 1)
		count += 1
	
