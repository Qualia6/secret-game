extends Clickable

func _clicked():
	GLOBAL.update_flag(&"has_destroy", true)
	visible = false
	queue_free()
