extends Control

func _ready() -> void:
	var words: Array[Entry] = [
		Entry.new("fanjak", "A girl", ["noun"]),
		Entry.new("em", "I (Nominative)", ["pronoun"]),
		Entry.new("kerse", "to use, to utilize", ["verb"]),
		Entry.new("kemsharas", "A constitution", ["noun"]),
		Entry.new("Kambuxxamak", "The Destroyer", ["noun"], ["proper"]),
		Entry.new("xanjak", "Center, middle, heart (of something)", ["noun"]),
	]
	var dict := Dict.new(
		"Tasxamot",
		[],
		[Pair.new("noun", "Noun"), Pair.new("pronoun", "Pronoun"), Pair.new("verb", "Verb")],
		[Pair.new("proper", "Proper noun")],
		words
	)

	#var d: Dict

	var f := FileAccess.open("/home/fmmaks/tasxamot.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(dict.to_json()))
	#var f := FileAccess.open("/home/fmmaks/tasxamot.json", FileAccess.READ)
	#d = Dict.from_json((JSON.parse_string(f.get_as_text()) as Dictionary))
	#for e in d.entries:
		#print(e)
