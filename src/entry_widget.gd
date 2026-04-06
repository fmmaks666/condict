class_name EntryWidget extends PanelContainer

signal view(entry: Entry, widget: EntryWidget)
signal delete(entry: Entry, widget: EntryWidget)

var entry: Entry:
	set(e):
		entry = e
		update()


func _ready() -> void:
	
	%View.pressed.connect(func(): view.emit(entry, self))
	%Delete.pressed.connect(func(): delete.emit(entry, self))

func update() -> void:
	if entry == null:
		return
	%Text.text = entry.text
	%Defention.text = entry.definition
	%Pos.text = ", ".join(entry.pos)
	%PosSep.visible = not entry.pos.is_empty()
