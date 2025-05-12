class_name Clickable extends TextureRect

var GLOBAL = preload("res://GLOBAL.gd")

@export var explodeable: bool = true

signal clicked

func _clicked(): 
	clicked.emit()

func _gui_input(event):
	if event is not InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return
	if explodeable and INVENTORY.selected_item_id == &"destroy":
		Explode.explode(position, size, texture, get_parent())
		queue_free()
		visible = false
		event.canceled = true
	else:
		_clicked()
