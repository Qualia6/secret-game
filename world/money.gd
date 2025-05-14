extends BasicClickable

func _ready():
	GLOBAL.emitter.updated.connect(_updated)
	visible = false

var made_visible: bool = false

func _updated():
	if GLOBAL.flags[&"june_moved"] and not made_visible: 
		made_visible = true
		visible = true

func _clicked():
	GLOBAL.update_flag(&"money", GLOBAL.flags[&"money"] + 1)
	visible = false
	queue_free()
