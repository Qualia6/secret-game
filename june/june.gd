extends NPC

@export var respawn_location_1: Vector2
@export var respawn_location_2: Vector2
@export var respawn_location_3: Vector2
var respawning: bool = false
var respawn_t: float = 1.

var not_realized_jeff_key_killed: bool = true

func _get_executions() -> Dictionary[String, Callable]:
	return {
		"leave_up": leave_up
	}

func leave_up():
	visible = false
	queue_free()

var already_go_upped: bool = false

func _clicked() -> void:
	if GLOBAL.flags[&"june_dead"]: return
	if GLOBAL.flags[&"jerboa_up"] and not already_go_upped:
		already_go_upped = true
		goto("GO UP")
		return
	super._clicked()

var alerady_key_hint: bool = false

func _updated():
	if not_realized_jeff_key_killed and GLOBAL.flags[&"jeff_killed_by_key"]:
		goto("WOW KEY KILL")
		not_realized_jeff_key_killed = false
	if GLOBAL.flags[&"jeff_said_puzzle"] and not GLOBAL.flags[&"june_moved"] and not alerady_key_hint:
		goto("KEY HINT")
		alerady_key_hint = true


func _about_to_explode():
	show_image(&"aaaa")
	GLOBAL.update_flag(&"june_dead", true)
	GLOBAL.update_flag(&"june_moved", true)


func _on_control_pannel_june_recovered():
	show_image(&"uhh")
	respawning = true
	respawn_t = 0.
	waiting_for_exec = true
	GLOBAL.update_flag(&"june_dead", false)
	visible = true

func _process(delta: float) -> void:
	if not respawning: return
	respawn_t += delta * 1.5
	if respawn_t < 1.:
		position = lerp(respawn_location_1, respawn_location_2, respawn_t)
	elif respawn_t < 2.:
		position = lerp(respawn_location_2, respawn_location_3, respawn_t - 1.)
	else:
		respawning = false
		waiting_for_exec = false
		position = respawn_location_3
		goto("RESPAWNED")
