extends Control

# For "Export Flags" the int will be a power of 2 i.e. 2, 4, 6, 8, 16
@export_flags("Red", "Green", "Blue", "Yellow", "Black") var mask_color:int = 32


func _ready() -> void:
	Global.color_changed.connect(color_changed)


func color_changed() -> void:
	var count:int = 0
	for color:bool in Global.current_colors:
		if int(pow(2, count)) == mask_color and color:
			# Hide UI item here
			pass
		elif int(pow(2, count)) == mask_color and not color:
			# Show UI item here
			pass
		count += 1
