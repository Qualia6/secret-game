extends NPC

func _clicked() -> void:
	if INVENTORY.selected_item_id == &"key":
		goto("HIT BY KEY")
		GLOBAL.update_flag(&"jeff_killed_by_key", true)
		return
	
	super._clicked()
