extends Node2D

func _ready() -> void:
	$anim.play("RESET")
	visible = false

func play_animation(animation: int) -> void:
	match animation:
		1: $anim.play("1")
		2: $anim.play("2")
		_: $anim.play("RESET")
