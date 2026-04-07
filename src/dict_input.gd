@tool
class_name DictEdit extends HBoxContainer

@export
var text: String:
	set(s):
		text = s
		if is_node_ready() and text != %Input.text:
			%Input.text = s

@export
var placeholder_text: String:
	set(s):
		placeholder_text = s
		if is_node_ready():
			%Input.placeholder_text = s

@export
var line_edit_alignment: HorizontalAlignment:
	set(a):
		line_edit_alignment = a
		if is_node_ready():
			%Input.alignment = a

signal text_changed(new_text: String)
signal text_submitted(text: String)

var chars: Array[String]:  # NOTE: It could be enough to supply the array of chars
	set(c):
		chars = c
		update()

func _ready() -> void:
	%Input.text = text
	%Input.placeholder_text = placeholder_text
	%Input.alignment = line_edit_alignment
	%CharsBtn.pressed.connect(_on_chars_pressed)
	%Input.text_changed.connect(func(t: String):
		text_changed.emit(t)
		text = t
	)
	%Input.text_submitted.connect(func(t: String): text_submitted.emit(t))

func get_line_edit() -> LineEdit:
	return %Input

func update() -> void:
	if chars == null and chars.is_empty():
		%CharsBtn.hide()
		return
	%CharsBtn.visible = not chars.is_empty()
	for c in %Chars.get_children():
		c.queue_free()
	for ch in chars:
		_add_char(ch)

func select_all() -> void:
	%Input.select_all()

func _on_chars_pressed() -> void:
	update()
	_show_popup()

func _on_char_pressed(chr: String) -> void:
	%Input.insert_text_at_caret(chr)
	%Input.text_changed.emit(%Input.text)

func _add_char(chr: String) -> void:
	var btn := Button.new()
	btn.text = chr
	btn.pressed.connect(func(): _on_char_pressed(chr))
	%Chars.add_child(btn)

func _show_popup() -> void:
	%Popup.size.x = round(size.x)
	var sz := get_viewport_rect()
	sz.size = Vector2(%Popup.size)
	sz.position.x += global_position.x
	sz.position.y += global_position.y + size.y
	%Popup.popup(sz)

func _hide_popup() -> void:
	%Popup.show()
