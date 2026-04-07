class_name Stats extends PanelContainer

signal close

var dict: Dict:
	set(d):
		dict = d
		update()

func  _ready() -> void:
	%Close.pressed.connect(func(): close.emit())

func update() -> void:
	if dict == null:
		return
	print("Allah 'akbar")
	%Name.text = dict.language
	var stats = """
	Has %d entries
	""" % dict.entries.size()
	%Stuff.text = stats
