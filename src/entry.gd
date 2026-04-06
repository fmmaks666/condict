class_name Entry extends Resource

@export var text: String
@export var definition: String
@export var root: String

@export var pos: Array[String]
@export var tags: Array[String]

@export var examples: Array[Sentence]

func _init(txt: String, def: String, rt: String = "",p: Array[String] = [], t: Array[String] = [], ex: Array[Sentence] = []) -> void:
	text = txt
	definition = def
	root = rt
	pos = p
	tags = t
	examples = ex

func _to_string() -> String:
	return "[%s]" % text

func to_json() -> Dictionary:
	return {
		"txt": text,
		"def": definition,
		"root": root,
		"pos": pos,
		"tags": tags,
		
		"ex": examples.map(func(s: Sentence): return s.to_json())
	}

static func from_json(j: Dictionary) -> Entry:
	var ex_arr: Array = (j["ex"] as Array[Dictionary]).map(func (s): return Sentence.from_json(s))
	var ex: Array[Sentence] = []
	for e: Sentence in ex_arr:
		ex.append(e)
	var pos_: Array[String] = []
	for p: String in j["pos"]:
		pos_.append(p)
	var tags_: Array[String] = []
	for t: String in j["tags"]:
		tags_.append(t)
	return Entry.new(
		j["txt"], j["def"], j["root"],
		pos_, tags_,
		ex
	)
