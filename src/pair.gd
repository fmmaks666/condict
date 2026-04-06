class_name Pair extends Resource

@export var left: String
@export var right: String

func _init(l: String, r: String) -> void:
	left = l
	right = r

func to_json() -> Dictionary[String, String]:
	return {"l": left, "r": right}
	
static func from_json(j: Dictionary) -> Pair:
	return Pair.new(j["l"], j["r"])
