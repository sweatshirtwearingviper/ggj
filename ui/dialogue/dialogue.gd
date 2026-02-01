extends MarginContainer


func _ready() -> void:
	Global.send_dialogue.connect(send_dialogue)
	Global.clear_dialogue.connect(clear_dialogue)


func send_dialogue(_text:String) -> void:
	$Box/Text.text = _text
	show()


func clear_dialogue() -> void:
	$Box/Text.text = ''
	hide()
