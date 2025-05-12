class_name NPC extends Clickable

@export_multiline var all_dialoge : String
@export var images : Dictionary[StringName, Texture2D]

var markers: Dictionary[String, int] = {}
var dialoge: PackedStringArray
var current_dialoge: int = 0


func goto(marked: String) -> void:
	current_dialoge = markers[marked]
	execute_dialoge()


func execute_dialoge():
	if current_dialoge >= len(dialoge): 
		$Label.text = ""
		return
	
	if dialoge[current_dialoge].begins_with("~"):
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!GoTo "):
		goto(dialoge[current_dialoge].right(-6))
		return
	
	if dialoge[current_dialoge].begins_with("!FlagTrue "):
		GLOBAL.update_flag(StringName(dialoge[current_dialoge].right(-10)), true)
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!IfFlag "):
		if GLOBAL.flags[StringName(dialoge[current_dialoge].right(-8))]:
			current_dialoge += 1
		else:
			current_dialoge += 2
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!IfHolding "):
		if INVENTORY.selected_item_id == StringName(dialoge[current_dialoge].right(-11)):
			current_dialoge += 1
		else:
			current_dialoge += 2
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!Image "):
		texture = images[StringName(dialoge[current_dialoge].right(-7).to_lower())]
		current_dialoge += 1
		execute_dialoge()
		return
	
	$Label.text = dialoge[current_dialoge]

func _updated(): pass

func parse_all_dialoge():
	dialoge = all_dialoge.split("\n")
	var current_line: int = 0
	markers = {}
	for d: String in dialoge:
		if d.begins_with("~"):
			markers.set(d.right(-2), current_line)
		current_line += 1
	print(markers)

func _ready() -> void:
	parse_all_dialoge()
	current_dialoge = 0
	execute_dialoge()
	GLOBAL.emitter.updated.connect(_updated)

func _clicked() -> void:
	if current_dialoge >= len(dialoge): return
	current_dialoge += 1
	execute_dialoge()
