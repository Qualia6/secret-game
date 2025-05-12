extends Sprite2D


func _ready():
	GLOBAL.emitter.updated.connect(_updated)


func _updated():
	visible = GLOBAL.flags[&"has_key"]
