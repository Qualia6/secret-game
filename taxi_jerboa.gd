extends NPC

signal departing_time

func _get_executions() -> Dictionary[String, Callable]:
	return {
		"depart": depart
	}

var already_activated: bool = false

func _updated():
	if GLOBAL.flags[&"jeff_up"] and GLOBAL.flags[&"june_up"] and not already_activated:
		already_activated = true
		goto("LETS ROLL")


func depart():
	departing_time.emit()
