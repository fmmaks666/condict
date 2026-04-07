class_name EntryView extends PanelContainer

signal close

var sentence_scene := preload("res://ui/sentence_view.tscn")

var entry: Entry:
	set(e):
		entry = e
		update()

# TODO: Get this out of here? Should I have a singleton to provide these?
var chars: Array[String]:
	set(c):
		chars = c
		update()

var pos: Array[String]:
	set(p):
		pos = p
		update()
		
var tags: Array[String]:
	set(t):
		tags = t
		update()

func  _ready() -> void:
	%Entry.text_changed.connect(func(text: String): if entry != null: entry.text = text)
	%Definition.text_changed.connect(func(text: String): if entry != null: entry.definition = text)
	%Root.text_changed.connect(func(text: String): if entry != null: entry.root = text)
	%PosBtn.toggled.connect(func(on: bool): %PosList.visible = on)
	%TagsBtn.toggled.connect(func(on: bool): %TagList.visible = on)
	%PosList.multi_selected.connect(_on_pos_list_changed)
	%TagList.multi_selected.connect(_on_tag_list_changed)
	%Add.pressed.connect(_on_add_pressed)
	%Close.pressed.connect(func():
		close.emit()
		clear()
	)

func update() -> void:
	if entry == null:
		return
	%Entry.chars = chars
	%Entry.text = entry.text
	%Definition.text = entry.definition
	%Definition.chars = chars
	%Root.text = entry.root
	%Root.chars = chars
	%PosList.clear()
	%TagList.clear()
	%Pos.text = ", ".join(entry.pos)
	%Tags.text = ", ".join(entry.tags)
	%Original.chars = chars
	%Translated.chars = chars
	%SentSep.visible = not entry.examples.is_empty()
	for s in %Sentences.get_children():
		s.queue_free()
	for p in pos:
		var id: int = %PosList.add_item(p)
		if p in entry.pos and p in pos:
			%PosList.select(id, false)
	for t in tags:
		var id: int = %TagList.add_item(t)
		if t in entry.tags:
			%TagList.select(id, false)
	for ex in entry.examples:
		_add_sentence(ex)

func clear() -> void:
	%Original.text = ""
	%Translated.text = ""

func edit() -> void:
	%Entry.get_line_edit().grab_focus()
	%Entry.select_all()
	%Definition.select_all()

func _on_pos_list_changed(id: int, selected: bool) -> void:
	var item: String = %PosList.get_item_text(id)
	if selected:
		if item not in entry.pos:
			entry.pos.append(item)
	else:
		entry.pos.erase(item)
	%Pos.text = ", ".join(entry.pos)

func _on_tag_list_changed(id: int, selected: bool) -> void:
	var item: String = %TagList.get_item_text(id)
	if selected:
		if item not in entry.tags:
			entry.tags.append(item)
	else:
		entry.tags.erase(item)
	%Tags.text = ", ".join(entry.tags)

func _add_sentence(s: Sentence) -> SentenceView:
	var sent: SentenceView = sentence_scene.instantiate()
	# THIS IS BAD
	sent.sentence = s
	sent.chars = chars
	sent.update()
	sent.delete.connect(_on_sentence_delete)
	%Sentences.add_child(sent)
	return sent

func _on_add_pressed() -> void:
	if %Original.text.is_empty() or %Translated.text.is_empty():
		return
	var s := Sentence.new(%Original.text, %Translated.text)
	%Original.text = ""
	%Translated.text = ""
	entry.examples.append(s)
	_add_sentence(s)
	%SentSep.visible = not entry.examples.is_empty()
	

func _on_sentence_delete(it: Sentence, widget: SentenceView) -> void:
	widget.queue_free()
	entry.examples.erase(it)
	%SentSep.visible = not entry.examples.is_empty()
