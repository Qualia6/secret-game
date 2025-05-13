extends NPC

func _about_to_explode():
	GLOBAL.update_flag(&"jerboa_dead", true)

func _get_executions() -> Dictionary[String, Callable]:
	return {
		"show_gun": show_gun,
		"hide_gun": hide_gun,
		"is_gun_visible": is_gun_visible
	}

func show_gun():
	$gun.visible = true
	$gun.play_animation(int(register))

func hide_gun():
	$gun.visible = false

var talking_about_money: bool = false

func is_gun_visible() -> bool:
	return $gun.visible

func _clicked():
	if INVENTORY.selected_item_id == &"money":
		if not talking_about_money:
			talking_about_money = true
			match GLOBAL.flags[&"gun_lvl"]:
				-1:
					goto("TALK ABOUT MONEY FIRST")
					return
				0:
					pass
				1:
					pass
	super._clicked()
