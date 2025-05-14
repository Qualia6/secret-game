extends Node2D

signal arrow_back_down
signal fix_camera_position

func _on_arrow_back_down_clicked() -> void:
	arrow_back_down.emit()

func _ready():
	$jeff.visible = false
	$june.visible = false
	GLOBAL.emitter.updated.connect(_updated)


func _updated():
	$jeff.visible = GLOBAL.flags[&"jeff_up"]
	$june.visible = GLOBAL.flags[&"june_up"]


func _on_jerboa_departing_time() -> void:
	GLOBAL.update_flag(&"game_end", true)
	fix_camera_position.emit()
	$arrow_back_down.visible = false
	$jeff.goto("SILENCE")
	$june.goto("SILENCE")
	$animtree.set("parameters/conditions/begin", true)
