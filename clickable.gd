class_name Clickable extends TextureRect

var GLOBAL = preload("res://GLOBAL.gd")

func _gui_input(event):
	if event is not InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return
	if not GLOBAL.flags[&"has_destroy_yet"]: return
	Explode.explode(position, size, texture, get_parent())
	queue_free()
	visible = false
