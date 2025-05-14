extends NPC

@export var respawn_location_1: Vector2
@export var respawn_location_2: Vector2
@export var respawn_location_3: Vector2
var respawning: bool = false
var respawn_t: float = 1.

var not_realized_jeff_key_killed: bool = true

func _updated():
	if not_realized_jeff_key_killed and GLOBAL.flags[&"jeff_killed_by_key"]:
		goto("WOW KEY KILL")
		not_realized_jeff_key_killed = false

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
