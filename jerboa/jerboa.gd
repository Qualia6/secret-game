extends NPC

func _about_to_explode():
	GLOBAL.update_flag(&"jerboa_dead", true)
