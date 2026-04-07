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
	set(s):
		button_text = s
		if is_node_ready():
			%Submit.text = s

@export
var delete_text: bool = false

var chars: Array[String]:
	set(c):
		chars = c
		update()

func _ready() -> void:
	%Submit.text = button_text
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

func update() -> void:
	if chars == null:
		return
	%Input.chars = chars

func get_line_edit() -> LineEdit:
	return %Input
