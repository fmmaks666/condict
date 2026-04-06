class_name Dict extends Resource

const VERSION = "version 1 by fmmaks"
@export var version: String = VERSION

@export var language: String

@export var chars: Array[String]
@export var pos: Array[String]
@export var tags: Array[String]

@export var entries: Array[Entry]

func _init(lang: String, ch: Array[String], p: Array[String], t: Array[String], e: Array[Entry], ver = VERSION) -> void:
	version = ver
	language = lang
	chars = ch
	pos = p
	tags = t
	entries = e

static func create() -> Dict:
	return Dict.new(
		"Neo Latin",
		[],
		["Noun", "Pronoun", "Adjective", "Verb", "Adverb", "Preposition", "Particle"],
		["Proper noun", "Loanword"],
		[],
	)

func to_json() -> Dictionary:
	return {
		"ver": version,
		"lang": language,
		"chars": chars,
		"pos": pos,
		"tags": tags,
		"entries": entries.map(func(e: Entry): return e.to_json())
	}

static func from_json(j: Dictionary) -> Dict:
	var en_arr: Array = (j["entries"] as Array[Dictionary]).map(func (e): return Entry.from_json(e))
	var en: Array[Entry] = []
	for e: Entry in en_arr:
		en.append(e)
	var p: Array[String] = []
	for ip: String in j["pos"]:
		p.append(ip)
	var t: Array[String] = []
	for it: String in j["tags"]:
		t.append(it)
	var chars_: Array[String] = []
	for c: String in j["chars"]:
		chars_.append(c)
	return Dict.new(
		j["lang"],
		chars_,
		p, t, en
	)
