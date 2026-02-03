extends MarginContainer

var locked:bool = false

func _ready() -> void:
	Global.send_dialogue.connect(send_dialogue)
	Global.clear_dialogue.connect(clear_dialogue)
	Global.lock_dialogue.connect(set.bind(&'locked', true))
	Global.unlock_dialogue.connect(set.bind(&'locked', false))


func send_dialogue(_text:String) -> void:
	if locked:
		return
	$Box/Text.text = _text
	show()


func clear_dialogue() -> void:
	if locked:
		return
	$Box/Text.text = ''
	hide()
