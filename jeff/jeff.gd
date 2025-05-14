extends NPC

@export var respawn_location_1: Vector2
@export var respawn_location_2: Vector2
@export var respawn_location_3: Vector2
var respawning: bool = false
var respawn_t: float = 1.

func _get_executions() -> Dictionary[String, Callable]:
	return {
		"go_to_previous_line": go_to_previous_line,
	}

var already_respawned: bool = false

func _clicked() -> void:
	if respawning or jumping: return
	if INVENTORY.selected_item_id == &"key":
		if already_respawned: save_line_as_previous()
		goto("HIT BY KEY")
		GLOBAL.update_flag(&"jeff_killed_by_key", true)
		GLOBAL.update_flag(&"jeff_dead", true)
		return
	if INVENTORY.selected_item_id == &"gun":
		jump()
		return
	super._clicked()

func _on_control_pannel_jeff_recovered():
	show_image(&"yay")
	respawning = true
	respawn_t = 0.
	waiting_for_exec = true
	GLOBAL.update_flag(&"jeff_dead", false)

func _process(delta: float) -> void:
	if respawning:
		respawn_t += delta * 1.5
		if respawn_t < 1.:
			position = lerp(respawn_location_1, respawn_location_2, respawn_t)
		elif respawn_t < 2.:
			position = lerp(respawn_location_2, respawn_location_3, respawn_t - 1.)
		else:
			respawning = false
			waiting_for_exec = false
			position = respawn_location_3
			if already_respawned:
				goto("RESPAWN AGAIN")
			else:
				already_respawned = true
				goto("RESPAWNED")
	elif jumping:
		jump_t += delta
		if jump_t > 1.:
			position.y = jump_start_y
			waiting_for_exec = false
			jumping = false
			GLOBAL.update_flag(&"jeff_jumped_before", true)
		else:
			position.y = jump_start_y + 4 * (jump_t * jump_t - jump_t) * jump_height


var jumping: bool = false
var jump_t: float = 1.
var jump_start_y: float = position.y
var jump_height: float

var previous_line: int = -1
var previous_expression: StringName

func go_to_previous_line():
	if previous_line == -1:
		push_error("tried to go to previous but there is no previous")
	#print("loading ", previous_line)
	gotoline(previous_line - 1)
	show_image(previous_expression)
	previous_line = -1

func save_line_as_previous():
	if previous_line == -1:
		#print("saving ", current_dialoge)
		previous_line = current_dialoge
		previous_expression = current_image_name
	#else:
		#print("not saving ", current_dialoge)

func jump():
	if GLOBAL.flags[&"jeff_jumped_before"]:
		jump_height = 400
		save_line_as_previous()
		goto("JUMP AGAIN")
	else:
		jump_height = 1200
		if position.y  < 400:
			GLOBAL.update_flag(&"ceiling_broken", true)
			goto("JUMP SURFACE FIRST")
			%CeillingHole.appear()
		else:
			goto("JUMP CAVE FIRST")
	
	jumping = true
	waiting_for_exec = true
	jump_start_y = position.y
	jump_t = 0.

var knows_that_talked_to_m: bool = false

func _updated():
	if GLOBAL.flags[&"spoken_to_m"]:
		if not knows_that_talked_to_m:
			knows_that_talked_to_m = true
			if GLOBAL.flags[&"jeff_killed_by_key"]:
				goto("SPOKEN WITH M")
			else:
				goto("SEE M EARLY")
