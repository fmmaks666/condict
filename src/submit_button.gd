@tool
class_name SubmitButton extends HBoxContainer

signal submitted(text: String)

@export
var placeholder_text: String:
	get:
		return %Input.placeholder_text
	set(s):
		%Input.placeholder_text = s

@export
var button_text: String:
	get:
		return %Submit.text
	set(s):
		%Submit.text = s

@export
var delete_text: bool = false

func _ready() -> void:
	%Submit.pressed.connect(func():
		submitted.emit(%Input.text)
		if delete_text:
			%Input.text = ""
	)
	%Input.text_submitted.connect(func(text: String):
		submitted.emit(text)
		if delete_text:
			%Input.text = ""
	)

func get_line_edit() -> LineEdit:
	return %Input
