extends NPC

@export var respawn_location_1: Vector2
@export var respawn_location_2: Vector2
@export var respawn_location_3: Vector2
var respawning: bool = false
var respawn_t: float = 1.

func _about_to_explode():
	GLOBAL.update_flag(&"jerboa_dead", true)

func _get_executions() -> Dictionary[String, Callable]:
	return {
		"show_gun": show_gun,
		"hide_gun": hide_gun,
		"is_gun_visible": is_gun_visible,
		"stop_holding": stop_holding,
	}

func stop_holding():
	INVENTORY.deselect_current_item()

func show_gun():
	$gun.visible = true
	$gun.play_animation(int(register))

func hide_gun():
	$gun.visible = false

func is_gun_visible() -> bool:
	return $gun.visible

func _clicked():
	if INVENTORY.selected_item_id == &"money" and GLOBAL.flags[&"jerboa_showed_gun"] and not respawning and not GLOBAL.flags[&"jerboa_talking_about_money"]:
		match GLOBAL.flags[&"gun_lvl"]:
			-1:
				goto("TALK ABOUT MONEY 1")
				return
			0:
				goto("TALK ABOUT MONEY 2")
				return
			1:
				goto("TALK ABOUT MONEY 3")
				return
	super._clicked()

func _on_control_pannel_jerboa_recovered():
	show_image(&"front")
	say("")
	respawning = true
	respawn_t = 0.
	waiting_for_exec = true
	visible = true
	GLOBAL.update_flag(&"jerboa_dead", false)

func _process(delta: float) -> void:
	if not respawning: return
	respawn_t += delta * 1.5
	if respawn_t < 1.:
		position = lerp(respawn_location_1, respawn_location_2, respawn_t)
	elif respawn_t < 2.:
		show_image(&"side")
		position = lerp(respawn_location_2, respawn_location_3, respawn_t - 1.)
	else:
		respawning = false
		waiting_for_exec = false
		position = respawn_location_3
