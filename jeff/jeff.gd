extends NPC

@export var respawn_location_1: Vector2
@export var respawn_location_2: Vector2
@export var respawn_location_3: Vector2
var respawning: bool = false
var respawn_t: float = 1.

func _clicked() -> void:
	if respawning: return
	if INVENTORY.selected_item_id == &"key":
		goto("HIT BY KEY")
		GLOBAL.update_flag(&"jeff_killed_by_key", true)
		GLOBAL.update_flag(&"jeff_dead", true)
		return
	
	super._clicked()

func _on_control_pannel_jeff_recovered():
	show_image(&"yay")
	respawning = true
	respawn_t = 0.
	waiting_for_exec = true
	GLOBAL.update_flag(&"jeff_dead", false)

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
