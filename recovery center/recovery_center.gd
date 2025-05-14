extends Clickable


func _about_to_explode():
	GLOBAL.update_flag(&"recovery_center_destroied", true)
