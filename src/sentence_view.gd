class_name SentenceView extends HBoxContainer

signal delete(sentence: Sentence, widget: SentenceView)

var sentence: Sentence:
	set(s):
		sentence = s
		update()

# NOTE: This is a mess
var chars: Array[String]:
	set(c):
		chars = c
		update()

func _ready() -> void:
	%Original.text_changed.connect(func(text: String): if sentence != null: sentence.text = text)
	%Translation.text_changed.connect(func(text: String): if sentence != null: sentence.translated = text)
	%Delete.pressed.connect(func(): delete.emit(sentence, self))

func update() -> void:
	if chars == null and chars.is_empty():
		return
	if sentence == null:
		return
	%Original.chars = chars
	%Translation.chars = chars
	%Original.text = sentence.text
	%Translation.text = sentence.translated
