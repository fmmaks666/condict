class_name Sentence extends Resource

@export var text: String
@export var translated: String

func _init(txt: String, trans: String) -> void:
	text = txt
	translated = trans

func _to_string() -> String:
	return text

func to_json() -> Dictionary:
	return {
		"txt": text,
		"tr": translated
	}

static func from_json(j: Dictionary) -> Sentence:
	return Sentence.new(j["txt"], j["tr"])
