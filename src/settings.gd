class_name Settings extends PanelContainer

signal close

var dict: Dict:
	set(d):
		dict = d
		update()

func  _ready() -> void:
	%Name.text_changed.connect(func(text: String): if dict != null: dict.language = text)
	%PosBtn.submitted.connect(func(pos: String): if dict != null and  pos not in dict.pos: _add_new(pos, dict.pos))
	%TagBtn.submitted.connect(func(tag: String): if dict != null and tag not in dict.tags: _add_new(tag, dict.tags))
	%CharBtn.submitted.connect(func(chars: String):
		if dict != null:
			if chars.begins_with("~"):
				chars = chars.trim_prefix("~")
				for chr in chars.split(" "):
					dict.chars.erase(chr.strip_edges())
			else:
				for chr in chars.split(" "):
					if not chr.strip_edges().is_empty():
						dict.chars.append(chr.strip_edges())
			update()
	)
	%PosList.item_activated.connect(func(id: int): _on_item_activated(id, %PosList, %PosBtn))
	%TagList.item_activated.connect(func(id: int): _on_item_activated(id, %TagList, %TagBtn))
	
	%Close.pressed.connect(func(): close.emit())

func update() -> void:
	if dict == null:
		return
	%Name.text = dict.language
	%PosList.clear()
	%TagList.clear()
	for p in dict.pos:
		var _id: int = %PosList.add_item(p)
	for t in dict.tags:
		var _id: int = %TagList.add_item(t)
	%Chars.text = " ".join(dict.chars)

func _add_new(what: String, where: Array[String]) -> void:
	if what.begins_with("~"):
		where.erase(what.trim_prefix("~"))
	else:
		if what not in where:
			where.append(what)
	update()

func _on_item_activated(id: int, list: ItemList, line: SubmitButton) -> void:
	line.get_line_edit().text = "~" + list.get_item_text(id)
