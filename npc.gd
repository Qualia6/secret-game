class_name NPC extends Clickable

@export_multiline var all_dialoge : String
@export var images : Dictionary[StringName, Texture2D]

var dialoge: PackedStringArray
var current_dialoge: int = 0

func execute_dialoge():
	if current_dialoge >= len(dialoge): 
		$Label.text = ""
		return
	
	if dialoge[current_dialoge].begins_with("!GoTo "):
		current_dialoge = int(dialoge[current_dialoge].right(-6))
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!FlagTrue "):
		GLOBAL.flags[StringName(dialoge[current_dialoge].right(-10))] = true
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
	
	if dialoge[current_dialoge].begins_with("!Image "):
		texture = images[StringName(dialoge[current_dialoge].right(-7))]
		current_dialoge += 1
		execute_dialoge()
		return
	
	$Label.text = dialoge[current_dialoge]

func parse_all_dialoge():
	dialoge = all_dialoge.split("\n")

func _ready() -> void:
	parse_all_dialoge()
	current_dialoge = 0
	execute_dialoge()

func _gui_input(event: InputEvent) -> void:
	@warning_ignore("unsafe_void_return")
	if GLOBAL.flags[&"has_destroy_yet"]: return super._gui_input(event)
	if event is not InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return
	if current_dialoge >= len(dialoge): return
	current_dialoge += 1
	execute_dialoge()
