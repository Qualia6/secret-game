class_name NPC extends Clickable

@export_multiline var all_dialoge : String
@export var images : Dictionary[StringName, Texture2D]

var markers: Dictionary[String, int] = {}
var dialoge: PackedStringArray
var current_dialoge: int = 0
var executions: Dictionary[String, Callable]

var register

func goto(marked: String) -> void:
	current_dialoge = markers[marked]
	execute_dialoge()

var waiting_for_exec: bool = false

func execute_dialoge():
	if current_dialoge >= len(dialoge): 
		say("")
		return
	
	if dialoge[current_dialoge].begins_with("~"):
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!Halt"):
		say("")
		current_dialoge -= 1
		return
	
	if dialoge[current_dialoge].begins_with("!GoTo "):
		goto(dialoge[current_dialoge].right(-6))
		return
	
	if dialoge[current_dialoge].begins_with("!Load "):
		register = dialoge[current_dialoge].right(-6)
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!Exec "):
		var call_result = executions[dialoge[current_dialoge].right(-6)].call()
		if call_result is Signal:
			waiting_for_exec = true
			await call_result 
			waiting_for_exec = false
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!IfExec "):
		var call_result = executions[dialoge[current_dialoge].right(-8)].call()
		if call_result:
			current_dialoge += 1
		else:
			current_dialoge += 2
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!FlagTrue "):
		GLOBAL.update_flag(StringName(dialoge[current_dialoge].right(-10)), true)
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!FlagInc "):
		var flag_name : StringName = StringName(dialoge[current_dialoge].right(-9))
		GLOBAL.update_flag(flag_name, GLOBAL.flags[flag_name] + 1)
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!FlagDec "):
		var flag_name : StringName = StringName(dialoge[current_dialoge].right(-9))
		GLOBAL.update_flag(flag_name, GLOBAL.flags[flag_name] - 1)
		current_dialoge += 1
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!FlagSetFloat "):
		var flag_name : StringName = StringName(dialoge[current_dialoge].right(-14))
		GLOBAL.update_flag(flag_name, register)
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
	
	if dialoge[current_dialoge].begins_with("!If > "):
		var flag_value = GLOBAL.flags[StringName(dialoge[current_dialoge].right(-6))]
		if flag_value > float(register):
			current_dialoge += 1
		else:
			current_dialoge += 2
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!If >= "):
		var flag_value = GLOBAL.flags[StringName(dialoge[current_dialoge].right(-7))]
		if flag_value >= float(register):
			current_dialoge += 1
		else:
			current_dialoge += 2
		execute_dialoge()
		return
	
	if dialoge[current_dialoge].begins_with("!If == "):
		var flag_value = GLOBAL.flags[StringName(dialoge[current_dialoge].right(-7))]
		if flag_value == float(register):
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
	
	say(dialoge[current_dialoge])

func say(text: String):
	$Label.text = text.replace("\\n", "\n")

func _updated(): pass

func parse_all_dialoge():
	dialoge = all_dialoge.split("\n")
	var current_line: int = 0
	markers = {}
	for d: String in dialoge:
		if d.begins_with("~"):
			markers.set(d.right(-2), current_line)
		current_line += 1

func _get_executions() -> Dictionary[String, Callable]:
	return {}

func _ready() -> void:
	executions = _get_executions()
	parse_all_dialoge()
	current_dialoge = 0
	execute_dialoge()
	GLOBAL.emitter.updated.connect(_updated)

func _clicked() -> void:
	if current_dialoge >= len(dialoge): return
	if waiting_for_exec: return
	current_dialoge += 1
	execute_dialoge()
