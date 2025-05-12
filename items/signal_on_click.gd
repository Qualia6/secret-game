extends CanvasItem

signal clicked(node: CanvasItem)

func _gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return
	event.canceled = true
	clicked.emit(self)
