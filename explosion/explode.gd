class_name Explode extends ColorRect

var frame: int = 0
var time_since_frame_change: float = 0
var time_per_frame: float = 0.04

signal finished

static var explode_class: PackedScene = preload("res://explosion/explode.tscn")
static func explode(new_pos: Vector2, new_size: Vector2, image: Texture2D, new_parent: Node):
	var node := explode_class.instantiate()
	node.position = new_pos - new_size * 0.5
	node.size = new_size * 2
	node.material.set_shader_parameter("real_texture", image)
	new_parent.add_child(node)


func _process(delta: float) -> void:
	if not visible: return
	time_since_frame_change += delta
	if (time_since_frame_change > time_per_frame):
		frame += floori(time_since_frame_change / time_per_frame)
		time_since_frame_change -= floorf(time_since_frame_change / time_per_frame) * time_per_frame
		if frame > 36: 
			visible = false
		material.set_shader_parameter("frame_x", frame % 6)
		@warning_ignore("integer_division")
		material.set_shader_parameter("frame_y", frame/6)


func _on_sound_finished() -> void:
	finished.emit()
	queue_free()
