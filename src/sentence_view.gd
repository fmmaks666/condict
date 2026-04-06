class_name SentenceView extends HBoxContainer

signal delete(sentence: Sentence, widget: SentenceView)

var sentence: Sentence:
	set(s):
		sentence = s
		update()

func _ready() -> void:
	%Original.text_changed.connect(func(text: String): if sentence != null: sentence.text = text)
	%Translation.text_changed.connect(func(text: String): if sentence != null: sentence.translated = text)
	%Delete.pressed.connect(func(): delete.emit(sentence, self))

func update() -> void:
	if sentence == null:
		return
	%Original.text = sentence.text
	%Translation.text = sentence.translated
