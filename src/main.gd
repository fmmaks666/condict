extends PanelContainer

var entry_scene := preload("res://ui/entry.tscn")
var entry_view_scene := preload("res://ui/entry_view.tscn")
var entry_view: EntryView
var settings_scene := preload("res://ui/settings.tscn")
var settings: Settings
var about_scene := preload("res://ui/about.tscn")
var about: About
var stats_scene := preload("res://ui/stats.tscn")
var stats: Stats
var filter_view_scene := preload("res://ui/filter.tscn")
var filter_view: FilterView



var dict: Dict:
	set(d):
		dict = d
		update()

func _ready() -> void:
	%Add.pressed.connect(_on_add_pressed)
	%Save.pressed.connect(_on_save_pressed)
	%Load.pressed.connect(_on_load_pressed)
	%New.pressed.connect(_on_new_pressed)
	%Search.text_submitted.connect(func(_text: String): %Enter.pressed.emit())
	%Filter.pressed.connect(func(): if filter_view != null: _show_popup(filter_view))
	%Enter.pressed.connect(_on_enter_pressed)
	%Settings.pressed.connect(func(): if settings != null: _show_popup(settings))
	%Stats.pressed.connect(
		func(): if stats != null:
			stats.update()
			_show_popup(stats)
	)
	%About.pressed.connect(func(): if about != null: _show_popup(about))
	
	entry_view = _add_view(entry_view_scene)
	settings = _add_view(settings_scene, func(): %Search.update())
	about = _add_view(about_scene)
	stats = _add_view(stats_scene)
	filter_view = _add_view(filter_view_scene)

func update() -> void:
	if dict == null:
		return
	%Search.chars = dict.chars
	entry_view.pos = dict.pos
	entry_view.tags = dict.tags
	entry_view.chars = dict.chars
	settings.dict = dict
	stats.dict = dict
	filter_view.dict = dict
	# Do I need this?
	for c in %Entries.get_children():
		#if (c is EntryWidget):
			#for i in c.view.get_connections():
				#c.view.disconnect(i["callable"])
			#for i in c.delete.get_connections():
				#c.view.disconnect(i["callable"])
		c.queue_free()
	for e in dict.entries:
		_add_entry(e)

func _on_add_pressed() -> void:
	if dict == null:
		return
	var entry := Entry.new("New word", "New definition")
	dict.entries.append(entry)
	var e := _add_entry(entry)
	var vs: VScrollBar = %Scroll.get_v_scroll_bar()
	_on_entry_view(entry, e, true)
	await entry_view.close
	vs.value = vs.max_value - vs.page

func _on_save_pressed() -> void:
	if dict == null: return
	DisplayServer.file_dialog_show(
		"Save %s" % dict.language,
		"user://",
		"%s.json" % dict.language,
		false,
		DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,
		PackedStringArray(["*.json"]),
		func(status: bool, selected_paths: PackedStringArray, _selected_filter_index: int):
			if not status:
				return
			var path := selected_paths[0]
			var f := FileAccess.open(path, FileAccess.WRITE)
			f.store_string(JSON.stringify(dict.to_json()))
			f.close()
	)

func _on_load_pressed() -> void:
	DisplayServer.file_dialog_show(
		"Open a dictionary",
		"user://",
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		PackedStringArray(["*.json"]),
		func(status: bool, selected_paths: PackedStringArray, _selected_filter_index: int):
			if not status:
				return
			var path := selected_paths[0]
			var f := FileAccess.open(path, FileAccess.READ)
			dict = Dict.from_json((JSON.parse_string(f.get_as_text()) as Dictionary))
			f.close()
	)

func _on_new_pressed() -> void:
	dict = Dict.create()

func _on_enter_pressed() -> void:
	var text: String = %Search.text
	# TODO: Move the filtering into a separate function
	for c in %Entries.get_children():
		if c is EntryWidget:
			if text not in c.entry.text and not text.is_empty():
				c.hide()
			else:
				c.show()

func _on_entry_view(it: Entry, widget: EntryWidget, is_new: bool = false) -> void:
	_open_entry(it)
	if is_new:
		entry_view.edit()
	# NOTE: This is a little bit shaky but it works
	await entry_view.close
	widget.update()
	
func _on_entry_delete(it: Entry, widget: EntryWidget) -> void:
	widget.queue_free()
	dict.entries.erase(it)

func _add_view(sc: PackedScene, custom: Callable = func(): pass) -> Node:
	var view: Node = sc.instantiate()
	view.hide()
	view.close.connect(
		func():
			_hide_popup(entry_view)
			custom.call()
	)
	%PopupContainer.add_child(view)
	return view

func _open_entry(e: Entry) -> void:
	entry_view.entry = e
	_show_popup(entry_view)

func _add_entry(e: Entry) -> EntryWidget:
	var entry: EntryWidget = entry_scene.instantiate()
	entry.entry = e
	entry.view.connect(_on_entry_view)
	entry.delete.connect(_on_entry_delete)
	%Entries.add_child(entry)
	return entry

func _show_popup(view: Control) -> void:
	%Popup.show()
	view.show()
	
func _hide_popup(view: Control) -> void:
	%Popup.hide()
	view.hide()
