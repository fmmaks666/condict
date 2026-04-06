class_name About extends PanelContainer

signal close

func  _ready() -> void:
	%Close.pressed.connect(func(): close.emit())
