extends Node

#untuk keep track semua maid roster
var maid_roster: Array[MaidResource] = [
	preload("uid://dr3es4e7eyh5i"),
	preload("uid://bytkn0kbdeg6h"),
	preload("uid://qxleno2wpc82")
]

#untuk keep track hanya maid yang available / not in service
var available_maids: Array[MaidResource]

enum Personality{ELEGANT, TSUNDERE, KUUDERE, ULTIMATE}
enum Menu{OMURICE, TEA, MIXED_JUICE}
enum Skills{MULTIPLIER, MATCHING, PATIENCE}

const CUSTOMER_LINES := {
	Personality.ELEGANT: [
		"I had such a rough day.. I need someone cute to cheer me up",
		"I hope there's an adorable little sister type working today",
		"I'm exhausted. I just want someone who'll make me smile",
		"I could really use someone bubbly to brighten my mood",
		"Can someone call me 'Onii-chan' today?",
		"I'm looking for the cutest maid in the café",
	],
	Personality.TSUNDERE: [
		"I wonder if the grumpy maid is working today",
		"A bit of attitude keeps life interesting",
		"Hopefully I get roasted a little today",
		"I like girls who pretend they don't care",
		"Someone who'll tell me to stop slacking off would be nice",
		"I don't mind getting scolded once in a while",
	],
	Personality.KUUDERE: [
		"I just want some peace and quiet today",
		"A calm maid sounds perfect tonight",
		"Someone composed would really help me relax",
		"I like people who don't talk more than necessary",
		"I'd rather have a quiet conversation than loud cheering",
		"A cool personality is surprisingly comforting",
	]
}

func _ready() -> void:
	available_maids = maid_roster
	
func get_random_line(personality: Personality) -> String:
	var lines: Array = CUSTOMER_LINES[personality]
	return lines.pick_random()
