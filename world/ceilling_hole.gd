extends Sprite2D

signal utilize_hole

func _updated():
	if GLOBAL.flags[&"jeff_mentioned_hole"]: 
		$arrow.visible = true

func _ready():
	visible = false
	$arrow.visible = false
	GLOBAL.emitter.updated.connect(_updated)

func appear():
	$anim.play("appear")

func _on_arrow_clicked() -> void:
	utilize_hole.emit()
