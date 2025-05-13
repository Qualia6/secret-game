class_name BasicClickable extends Control

signal clicked

func _clicked(): 
	clicked.emit()

func _gui_input(event):
	if event is not InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return
	_clicked()
