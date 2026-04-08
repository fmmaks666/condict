class_name Filter extends RefCounted

enum MATCHERS {
	ALL,
	PREFIX,
	SUFFIX,
}

enum WHAT {
	ENTRY,
	DEFINITION,
	ROOT
}

var match_options: MATCHERS
var matcher: Callable:
	get:
		match match_options:
			MATCHERS.ALL:
				return func(s: String, w: String) -> bool: return w in s
			MATCHERS.PREFIX:
				return func(s: String, w: String) -> bool: return s.begins_with(w)
			MATCHERS.SUFFIX:
				return func(s: String, w: String) -> bool: return s.ends_with(w)
			_:
				return func(s: String, w: String) -> bool: return w in s

var pos: Array[String]
var tags: Array[String]

func _init(m: MATCHERS, p: Array[String], t: Array[String]) -> void:
	match_options = m
	pos = p
	tags = t

func check(e: Entry, s: String) -> bool:
	for x in [e.text, e.definition, e.root]:
		if s.is_empty():
			break
		if not matcher.call(x, s):
			return false
	for p in pos:
		if p in e.pos:
			return true
	for t in tags:
		if t in e.tags:
			return true
	return true

static func default(p: Array[String], t: Array[String]) -> Filter:
	return Filter.new(MATCHERS.ALL, p, t)
