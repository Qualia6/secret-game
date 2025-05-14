class_name Clickable extends TextureRect

@export var explodeable: bool = true
@export var free_on_explode: bool = true
@export var strong: bool = false

signal clicked

func _clicked(): 
	clicked.emit()

func _about_to_explode():
	pass

func can_be_exploded() -> bool:
	if INVENTORY.selected_item_id != &"gun": return false
	if not explodeable: return false
	if GLOBAL.flags[&"gun_lvl"] >= 2: return true
	if GLOBAL.flags[&"gun_lvl"] <= 0: return false
	return not strong

func try_to_explode():
	if can_be_exploded():
		_about_to_explode()
		Explode.explode(position, size, texture, get_parent())
		if free_on_explode: queue_free()
		visible = false

func _gui_input(event):
	if event is not InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return
	if can_be_exploded():
		try_to_explode()
		event.canceled = true
	else:
		_clicked()
