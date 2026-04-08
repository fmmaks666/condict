class_name FilterView extends PanelContainer

signal close

var dict: Dict:
	set(d):
		dict = d
		update()

var filter: Filter

func  _ready() -> void:
	filter = Filter.default([], [])
	%Default.pressed.connect(func(): if dict != null: filter = filter.default(dict.pos, dict.tags))
	%AllPos.pressed.connect(func(): select_all(%PosList))
	%NonePos.pressed.connect(func(): deselect_all(%PosList))
	%AllTags.pressed.connect(func(): select_all(%TagList))
	%NoneTags.pressed.connect(func(): deselect_all(%TagList))
	%PosList.multi_selected.connect(func(): _refresh_filter())
	%TagList.multi_selected.connect(func(): _refresh_filter())
	
	%Close.pressed.connect(func(): close.emit())

func update() -> void:
	if dict == null:
		return
	filter.pos = dict.pos
	filter.tags = dict.tags
	%PosList.clear()
	%TagList.clear()
	for p in dict.pos:
		var _id: int = %PosList.add_item(p)
	for t in dict.tags:
		var _id: int = %TagList.add_item(t)

func select_all(list: ItemList) -> void:
	for i in range(list.item_count):
		list.select(i, false)
	_refresh_filter()

func deselect_all(list: ItemList) -> void:
	list.deselect_all()
	_refresh_filter()

func _refresh_filter() -> void:
	# SLOW?
	filter.pos.clear()
	filter.tags.clear()
	for p in %PosList.get_selected_items():
		filter.pos.append(%PosList.get_item_text(p))
	for t in %TagList.get_selected_items():
		filter.tags.append(%TagList.get_item_text(t))
