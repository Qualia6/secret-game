extends Clickable

signal jeff_recovered
signal june_recovered
signal jerboa_recovered

func _ready() -> void:
	GLOBAL.emitter.updated.connect(_updated)

func _updated():
	if GLOBAL.flags[&"jeff_dead"]:
		$light_jeff.frame = 1
		$lever_jeff.frame = 0
	else:
		$light_jeff.frame = 0
		$lever_jeff.frame = 1
	
	if GLOBAL.flags[&"june_dead"]:
		$light_june.frame = 1
		$lever_june.frame = 0
	else:
		$light_june.frame = 0
		$lever_june.frame = 1
	
	if GLOBAL.flags[&"jerboa_dead"]:
		$light_jerboa.frame = 1
		$lever_jerboa.frame = 0
	else:
		$light_jerboa.frame = 0
		$lever_jerboa.frame = 1

func _about_to_explode():
	GLOBAL.update_flag(&"control_pannel_destroied", true)

func _on_jeff_clicked() -> void:
	if INVENTORY.selected_item_id == &"gun" and can_be_exploded(): 
		try_to_explode()
		return
	if GLOBAL.flags[&"recovery_center_destroied"]: return
	if GLOBAL.flags[&"jeff_dead"]:
		jeff_recovered.emit()
		$chime.play()

func _on_june_clicked() -> void:
	if INVENTORY.selected_item_id == &"gun" and can_be_exploded(): 
		try_to_explode()
		return
	if GLOBAL.flags[&"recovery_center_destroied"]: return
	if GLOBAL.flags[&"june_dead"]:
		june_recovered.emit()
		$chime.play()

func _on_jerboa_clicked() -> void:
	if INVENTORY.selected_item_id == &"gun" and can_be_exploded(): 
		try_to_explode()
		return
	if GLOBAL.flags[&"recovery_center_destroied"]: return
	if GLOBAL.flags[&"jerboa_dead"]:
		jerboa_recovered.emit()
		$chime.play()
